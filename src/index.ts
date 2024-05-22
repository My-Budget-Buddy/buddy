import { Command } from "commander";
import { build, clean } from "./utils/commands";
import { repositories } from "./utils/repositories";

const program = new Command();

program
  .command("build")
  .description("Clone all repositories")
  .action(async () => {
    await build(repositories);
  });

program
  .command("clean")
  .description("Remove all repositories")
  .action(async () => {
    await clean(repositories);
  });

program.parse(process.argv);
