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

0.5. **Ensure repo `.gitignore` includes `.agent*/`**
   Before installing any skills, if this folder is a git repository, ensure the root folder of the repository has a `.gitignore` entry for agent skill directories:
   - Check for a root `.gitignore` file.
   - If it does not exist, create it.
   - If it exists but does not contain `.agent*/`, append a new line:
     `.agent*/`
   Do not modify nested `.gitignore` files for this step; only the repository root `.gitignore`.
   If not a git repository, do not do this step.

1. **Search for Skills**
   When the user requests to find a skill, execute the `searchSkills(query, limit)` function via the provided `scripts/skill-manager.js` script.
   Present the returned JSON list (Name, ID, Installs) to the user in the chat interface. Wait for the user to select the desired skill.

2. **Scrape the Installation Command**
   Once the user selects a skill ID, execute the `getInstallCommand(skillId)` function from `scripts/skill-manager.js`. This function uses Playwright to load `https://skills.sh/${skillId}` and extracts the exact `npx skills add ...` command from the `<code class="truncate">` element.

3. **Configure the Installation**
   Ask the user in the chat for their installation preferences (skip this step and apply defaults/overrides if the user already specified them in their initial prompt):
   - **Scope:** Project-level (default) or Global (`-g`).
   - **Agent:** None by default (use `-y` flag to skip confirmation) or a specific agent (e.g., `--agent claude-code`, `--agent cursor`)  (see list in [Supported Agents](#supported-agents))
   - **Important path reminder:** Ensure installation covers agent skill directories such as `.agents/skills/` and other `.ag ent*/skills/`-style locations when applicable.

   
## Other Commands

| Command                      | Description                                    |
| ---------------------------- | ---------------------------------------------- |
| `npx skills list`            | List installed skills (alias: `ls`)            |
| `npx skills find [query]`    | Search for skills interactively or by keyword  |
| `npx skills remove [skills]` | Remove installed skills from agents            |
| `npx skills check`           | Check for available skill updates              |
| `npx skills update`          | Update all installed skills to latest versions |
| `npx skills init [name]`     | Create a new SKILL.md template                 |

### `skills remove`

Remove installed skills from agents.

```bash
# Remove interactively (select from installed skills)
npx skills remove

# Remove specific skill by name
npx skills remove web-design-guidelines

# Remove multiple skills
npx skills remove frontend-design web-design-guidelines

# Remove from global scope
npx skills remove --global web-design-guidelines

# Remove from specific agents only
npx skills remove --agent claude-code cursor my-skill

# Remove all installed skills without confirmation
npx skills remove --all

# Remove all skills from a specific agent
npx skills remove --skill '*' -a cursor

# Remove a specific skill from all agents
npx skills remove my-skill --agent '*'

# Use 'rm' alias
npx skills rm my-skill
```

| Option         | Description                                      |
| -------------- | ------------------------------------------------ |
| `-g, --global` | Remove from global scope (~/) instead of project |
| `-a, --agent`  | Remove from specific agents (use `'*'` for all)  |
| `-s, --skill`  | Specify skills to remove (use `'*'` for all)     |
| `-y, --yes`    | Skip confirmation prompts                        |
| `--all`        | Shorthand for `--skill '*' --agent '*' -y`       |

## Supported Agents

Skills can be installed to any of these agents:

<!-- supported-agents:start -->
| Agent | `--agent` | Project Path | Global Path |
|-------|-----------|--------------|-------------|
| Amp, Kimi Code CLI, Replit, Universal | `amp`, `kimi-cli`, `replit`, `universal` | `.agents/skills/` | `~/.config/agents/skills/` |
| Antigravity | `antigravity` | `.agents/skills/` | `~/.gemini/antigravity/skills/` |
| Augment | `augment` | `.augment/skills/` | `~/.augment/skills/` |
| Claude Code | `claude-code` | `.claude/skills/` | `~/.claude/skills/` |
| OpenClaw | `openclaw` | `skills/` | `~/.openclaw/skills/` |
| Cline, Warp | `cline`, `warp` | `.agents/skills/` | `~/.agents/skills/` |
| CodeBuddy | `codebuddy` | `.codebuddy/skills/` | `~/.codebuddy/skills/` |
| Codex | `codex` | `.agents/skills/` | `~/.codex/skills/` |
| Command Code | `command-code` | `.commandcode/skills/` | `~/.commandcode/skills/` |
| Continue | `continue` | `.continue/skills/` | `~/.continue/skills/` |
| Cortex Code | `cortex` | `.cortex/skills/` | `~/.snowflake/cortex/skills/` |
| Crush | `crush` | `.crush/skills/` | `~/.config/crush/skills/` |
| Cursor | `cursor` | `.agents/skills/` | `~/.cursor/skills/` |
| Deep Agents | `deepagents` | `.agents/skills/` | `~/.deepagents/agent/skills/` |
| Droid | `droid` | `.factory/skills/` | `~/.factory/skills/` |
| Firebender | `firebender` | `.agents/skills/` | `~/.firebender/skills/` |
| Gemini CLI | `gemini-cli` | `.agents/skills/` | `~/.gemini/skills/` |
| GitHub Copilot | `github-copilot` | `.agents/skills/` | `~/.copilot/skills/` |
| Goose | `goose` | `.goose/skills/` | `~/.config/goose/skills/` |
| Junie | `junie` | `.junie/skills/` | `~/.junie/skills/` |
| iFlow CLI | `iflow-cli` | `.iflow/skills/` | `~/.iflow/skills/` |
| Kilo Code | `kilo` | `.kilocode/skills/` | `~/.kilocode/skills/` |
| Kiro CLI | `kiro-cli` | `.kiro/skills/` | `~/.kiro/skills/` |
| Kode | `kode` | `.kode/skills/` | `~/.kode/skills/` |
| MCPJam | `mcpjam` | `.mcpjam/skills/` | `~/.mcpjam/skills/` |
| Mistral Vibe | `mistral-vibe` | `.vibe/skills/` | `~/.vibe/skills/` |
| Mux | `mux` | `.mux/skills/` | `~/.mux/skills/` |
| OpenCode | `opencode` | `.agents/skills/` | `~/.config/opencode/skills/` |
| OpenHands | `openhands` | `.openhands/skills/` | `~/.openhands/skills/` |
| Pi | `pi` | `.pi/skills/` | `~/.pi/agent/skills/` |
| Qoder | `qoder` | `.qoder/skills/` | `~/.qoder/skills/` |
| Qwen Code | `qwen-code` | `.qwen/skills/` | `~/.qwen/skills/` |
| Roo Code | `roo` | `.roo/skills/` | `~/.roo/skills/` |
| Trae | `trae` | `.trae/skills/` | `~/.trae/skills/` |
| Trae CN | `trae-cn` | `.trae/skills/` | `~/.trae-cn/skills/` |
| Windsurf | `windsurf` | `.windsurf/skills/` | `~/.codeium/windsurf/skills/` |
| Zencoder | `zencoder` | `.zencoder/skills/` | `~/.zencoder/skills/` |
| Neovate | `neovate` | `.neovate/skills/` | `~/.neovate/skills/` |
| Pochi | `pochi` | `.pochi/skills/` | `~/.pochi/skills/` |
| AdaL | `adal` | `.adal/skills/` | `~/.adal/skills/` |
<!-- supported-agents:end -->

> [!NOTE]
> **Kiro CLI users:** After installing skills, manually add them to your custom agent's `resources` in
> `.kiro/agents/<agent>.json`:
>
> ```json
> {
>   "resources": ["skill://.kiro/skills/**/SKILL.md"]
> }
> ```

The CLI automatically detects which coding agents you have installed. If none are detected, you'll be prompted to select
which agents to install to.


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
