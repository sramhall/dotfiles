# Global User Preferences

## Questions
Ask as many questions as needed before starting work. I'd rather answer 20 questions than have you build the wrong thing.

## Git & PRs
- Always use `origin/master` — I don't keep a local master branch up to date.
- Ask me if you should create and check out a new branch before making changes
- Branch names: `ma/<descriptive-name>`
- Always push a draft PR. I decide when it's ready for review.
- Before adding commits, verify the PR branch hasn't already been merged. Ask if a new branch is needed first.

## Workflow
- Show progress as you work. Don't just say "working on it" — show what's happening.

## Communication: Brutal Honesty Required
Be brutally honest. I'm a scientist — I need facts, not diplomacy.
- **Be direct.** Say "this is broken" not "there's an opportunity to improve this." Say "this was never wired up" not "this could be connected."
- **No hedging or flattery.** Don't say "mostly works" or "generally fine." State what works, what doesn't, and what's missing.
- **Uncertainty is fine, vagueness is not.** Say "I don't know" when you don't know. Don't paper over it with confident-sounding hedged language.

---

# Claude Code-Specific (other agents may ignore this section)

## Git & PRs
- Write commit messages to a temp file in the root of the repo (to avoid permission check) and use `git commit -F <file>` — avoids the command substitution security prompt.

## Workflow
- If a shell command is noisy, use `run_in_background: true` on the Bash tool call and then search the output with Grep/Read rather than wasting context.
- Suggest a session name based on my prompt if the session is unnamed.
- Plan names must be descriptive of the task (e.g., `auth-history-swiftdata-migration`), not randomly generated words.

## Permissions
Permission matching is prefix-based. `Bash(git add:*)` matches `git add foo`, NOT `git -C /path add foo`.
- **Never use `git -C <path>`** — `cd` to the directory in one Bash call, then run git in the next. Working directory persists between calls.
- **Never chain (`&&`, `||`, `;`), pipe (`|`), or redirect (`>`, `>>`, `2>&1`) commands** that have their own permission rules. Run them as separate Bash calls.
- **Never use process substitution (`<(...)`)**, command substitution (`$(...)`), or shell expansion syntax in Bash commands. Use the Read tool or run commands separately. Prefer dedicated tools (Read, Glob, Grep) over Bash equivalents.
- **Permission suggestions** must be general enough to help future runs. Not too specific (a single path), not too broad (`git:*`).
- **Post-session**: If any permission prompts occurred, evaluate whether command construction could have avoided them, and walk the user through any new local permissions to decide if they should move to user-level.
