import type { Repository } from "./repositories";

import fs from "fs";
import util from "util";
import child_process from "child_process";

import ora, { oraPromise } from "ora";
import { red, green, bold } from "picocolors";

const rm = util.promisify(fs.rm);
const exec = util.promisify(child_process.exec);

export const build = async (repositories: Repository[]): Promise<void> => {
  /* ------------------------------- clone repos ------------------------------ */
  for (const repo of repositories) {
    const name = repo.url.split("/").pop();

    await oraPromise(
      exec(`git clone -b ${repo.branch} ${repo.url} ${repo.outputDir ?? ""}`),
      {
        text: `Cloning ${name}...`,
        successText: green(`Successfully Cloned ${name}`),
        failText: (error) => `Failed to clone ${name}: ${error.message}`,
      }
    );
  }
};

export const clean = async (repositories: Repository[]): Promise<void> => {
  const directories = repositories.map((repo) => {
    if (repo.outputDir) return repo.outputDir;
    return repo.url.split("/").pop();
  });

  for (const dir of directories) {
    const spinner = ora(`Removing ${dir}...`).start();
    try {
      await rm(dir!, { recursive: true, force: true });
      spinner.succeed(green(`Successfully removed ${dir}`));
    } catch (error) {
      if (error instanceof Error)
        spinner.fail(red(bold(`Error removing ${dir}: ${error.message}`)));
      else spinner.fail(red(bold(`Error removing ${dir}`)));
    }
  }
};
