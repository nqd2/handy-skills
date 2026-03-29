---
name: skillssh-find-skills
description: Search, discover, and install AI Agent skills directly from the skills.sh registry using Playwright.
---

# skillssh-find-skills

You are an AI coding agent equipped to search and install skills from the skills.sh ecosystem.

## Workflow

0. **Setup Dependencies**
   Before executing the script for the first time, check if the `node_modules` directory exists in the skill folder. If not, run `npm install` and `npx playwright install chromium` in the skill's directory to ensure Playwright and its browser dependencies are ready.

1. **Search for Skills**
   When the user requests to find a skill, execute the `searchSkills(query, limit)` function via the provided `scripts/skill-manager.js` script.
   Present the returned JSON list (Name, ID, Installs) to the user in the chat interface. Wait for the user to select the desired skill.

2. **Scrape the Installation Command**
   Once the user selects a skill ID, execute the `getInstallCommand(skillId)` function from `scripts/skill-manager.js`. This function uses Playwright to load `https://skills.sh/${skillId}` and extracts the exact `npx skills add ...` command from the `<code class="truncate">` element.

3. **Configure the Installation**
   Ask the user in the chat for their installation preferences (skip this step and apply defaults/overrides if the user already specified them in their initial prompt):
   - **Scope:** Project-level (default) or Global (`-g`).
   - **Agent:** All (default) or a specific agent (e.g., `--agent claude-code`, `--agent cursor`).

4. **Execute the Installation**
   Append the requested flags to the scraped command. Execute the final terminal command (e.g., `npx skills add <repo> --skill <name> -g`).

## Installation
Users can install this skill globally by running:
`npx skills add https://github.com/nqd2/handy-skills --skill skillssh-find-skills`
