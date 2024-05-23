import fs from "fs";
import util from "util";
import pkg from "picocolors";
import prompts, { PromptObject } from "prompts";
import child_process from "child_process";

import { chdir, cwd } from "process";
const { red, green, bold, dim } = pkg;
import ora, { oraPromise } from "ora";
import { repositories } from "./repositories.js";

const rm = util.promisify(fs.rm);
const readdir = util.promisify(fs.readdir);
const writeFile = util.promisify(fs.writeFile);
const exec = util.promisify(child_process.exec);

export const build = async (all: boolean): Promise<void> => {
  let selectedRepos = repositories;
  if (!all) {
    const questions = [
      /* ------------------------ prompt user for selection ----------------------- */
      {
        type: "multiselect",
        name: "selectedRepos",
        message: "Select services to clone and start",
        choices: repositories.map((repo) => ({
          title: repo.url.split("/").pop() as string,
          value: repo,
          selected: repo.default ?? false,
        })),
        min: 1,
        hint: "- Space to select. Return to submit",
        instructions: false,
      },
    ];

    const response = await prompts(questions as PromptObject[]);
    selectedRepos = response.selectedRepos;
  }

  /* ------------------------------- clone repos ------------------------------ */
  console.log();
  for (const repo of selectedRepos) {
    const name = repo.url.split("/").pop();

    await oraPromise(
      exec(`git clone -b ${repo.branch} ${repo.url} ${"services/" + name}`),
      {
        text: `Cloning ${name}...`,
        successText: green(
          `Successfully Cloned ${name} into services/${name}/`
        ),
        failText: (error) =>
          red(bold(`Failed to clone ${name}: ${error.message}`)),
      }
    );
  }

  /* ---------------------------- build with maven ---------------------------- */
  console.log();
  for (const repo of selectedRepos) {
    const name = repo.url.split("/").pop();
    const oldDirectory = cwd();

    chdir("services/" + name + repo.rootDir);

    await oraPromise(exec("mvn clean package -DskipTests"), {
      text: `Building ${name}...`,
      successText: green(`Successfully built and packaged ${name}`),
      failText: (error) =>
        red(bold(`Failed to build and package ${name}: ${error.message}`)),
    });

    // check for a Dockerfile, if not create one
    const spinner = ora(dim("\tChecking for Dockerfile...")).start();
    const files = await readdir(".");
    if (!files.includes("Dockerfile")) {
      spinner.text = dim("\tCreating Dockerfile...");
      const Dockerfile = `FROM alpine:latest

RUN apk update && apk upgrade && apk add openjdk17-jre

WORKDIR /app
      
COPY target/*.jar /app/app.jar
      
EXPOSE ${repo.port}
      
CMD ["java", "-jar", "app.jar"]`;

      await writeFile("Dockerfile", Dockerfile);
      spinner.succeed(dim(`\tCreated Dockerfile for ${name}`));
    } else spinner.stop();

    chdir(oldDirectory);
  }

  /* ----------------------- display compose up command ----------------------- */
  console.log();
  console.log(
    bold(
      `Start your services with this command:\n\n\tdocker compose up -d --build db ${selectedRepos
        .map((repo) => repo.serviceName)
        .join(" ")}`
    )
  );
};

export const clean = async (): Promise<void> => {
  await oraPromise(rm(`services/`, { recursive: true, force: true }), {
    text: `Removing services directory...`,
    successText: green(`Successfully removed services`),
    failText: (error) =>
      red(bold(`Failed to remove services directory: ${error.message}`)),
  });
};

export const resetdb = async (yes: boolean | undefined): Promise<void> => {
  let hasAgreed = false;
  if (typeof yes === "undefined") {
    const response = await prompts({
      type: "confirm",
      name: "continue",
      message:
        "Are you sure you want to restart the database? This will overwrite your current data.",
    });

    hasAgreed = response.continue;
  }

  if (!hasAgreed) return;

  const spinner = ora("Stopping database container...").start();
  await exec("docker compose down db");
  spinner.text = "Removing exising volume...";
  try {
    await exec("docker volume rm buddy_budgetbuddy-data");
  } catch (e) {
    spinner.fail(
      red(
        bold(
          `Failed to remove docker volume${
            e instanceof Error ? ": " + e.message : ""
          }`
        )
      )
    );

    return;
  }

  spinner.text = "Rebuilding and starting database container...";

  await exec("docker compose up -d --build db");
  spinner.succeed(
    green("Restarted and rebuilt database container using init.sql")
  );
};
