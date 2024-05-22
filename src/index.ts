#!/usr/bin/env node

import { Command } from "commander";
import { build, clean, resetdb } from "./utils/commands.js";

const program = new Command();

program
  .command("build")
  .description("Clone, build, and start services")
  .option(
    "-a, --all",
    "Clones all repositories, skips asking which ones to clone."
  )
  .action(async (options) => await build(options.all));

program
  .command("clean")
  .description("Remove all repositories")
  .action(async () => await clean());

program
  .command("resetdb")
  .description(
    "Removes the volume for the database, rebuilding and updating it with new init schema/data."
  )
  .option(
    "-y, --yes",
    "Confirm you want to remove the volume and restart the database."
  )
  .action(async (options) => await resetdb(options.yes));

program.parse(process.argv);
