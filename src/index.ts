#!/usr/bin/env node

import { Command } from "commander";
import { build, clean } from "./utils/commands.js";

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

program.parse(process.argv);
