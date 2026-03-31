---
name: skillssh-find-skills
description: Search, discover, and install AI Agent skills directly from the skills.sh registry using Playwright.
---

# skillssh-find-skills

You are an AI coding agent equipped to search and install skills from the skills.sh ecosystem.

## Default Preset (Auto-Install)

If the user does not provide a specific list of skills, install these 4 skills from `obra/superpowers` by default:

1. `brainstorming`
2. `systematic-debugging`
3. `writing-plans`
4. `using-superpowers`

When applying this default preset, do not wait for extra confirmation unless the user explicitly asks for interactive selection.

## Workflow

0. **Setup Dependencies**
   Before executing the script for the first time, check if the `node_modules` directory exists in the skill folder. If not, run `pnpm install` (if has pnpm) or `yarn install` (if has yarn) or `npm install` and `npx playwright install chromium` in the skill's directory to ensure Playwright and its browser dependencies are ready.

1. **Search for Skills**
   When the user requests to find a skill, execute the `searchSkills(query, limit)` function via the provided `scripts/skill-manager.js` script.
   Present the returned JSON list (Name, ID, Installs) to the user in the chat interface. Wait for the user to select the desired skill.

2. **Scrape the Installation Command**
   Once the user selects a skill ID, execute the `getInstallCommand(skillId)` function from `scripts/skill-manager.js`. This function uses Playwright to load `https://skills.sh/${skillId}` and extracts the exact `npx skills add ...` command from the `<code class="truncate">` element.

3. **Configure the Installation**
   Ask the user in the chat for their installation preferences (skip this step and apply defaults/overrides if the user already specified them in their initial prompt):
   - **Scope:** Project-level (default) or Global (`-g`).
   - **Agent:** All agents by default (`--agent '*'`) or a specific agent (e.g., `--agent claude-code`, `--agent cursor`).
   - **Important path reminder:** Ensure installation covers agent skill directories such as `.agents/skills/` and other `.agent*/skills/`-style locations when applicable.

   
## Other Commands

| Command                      | Description                                    |
| ---------------------------- | ---------------------------------------------- |
| `npx skills list`            | List installed skills (alias: `ls`)            |
| `npx skills find [query]`    | Search for skills interactively or by keyword  |
| `npx skills remove [skills]` | Remove installed skills from agents            |
| `npx skills check`           | Check for available skill updates              |
| `npx skills update`          | Update all installed skills to latest versions |
| `npx skills init [name]`     | Create a new SKILL.md template                 |


4. **Execute the Installation**
   - Always auto-detect and run the correct `npx skills add ...` command by scraping it with `getInstallCommand(skillId)` first.
   - Append requested flags to the scraped command and execute it.
   - If multiple skills are requested (including the default 4-skill preset), repeat the scrape + execute flow for each selected skill ID.
   - Default non-interactive install behavior when user did not specify preferences: project scope, all agents, and `-y`.
   - Example final command shape:
     `npx skills add <repo> --skill <name> --agent '*' -y`

## Installation
Users can install this skill globally by running:
`npx skills add https://github.com/nqd2/handy-skills --skill skillssh-find-skills`
