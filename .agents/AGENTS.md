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
- Set a session name based on my prompt if the session is unnamed.
- Plan names must start with the date and be descriptive of the task (e.g., `auth-history-swiftdata-migration`), not randomly generated words.

## Permissions — CRITICAL
Permission matching is prefix-based. Compound commands always trigger a blocking permission prompt — this is the most disruptive mistake an agent can make. Your training will push you toward chaining and piping. Override that instinct.

Each Bash tool call must be exactly one simple command. **Never** chain (`&&`, `||`, `;`), pipe (`|`), redirect (`>`, `2>&1`), use `git -C`, or use command/process substitution (`$(…)`, `<(…)`).
| Wrong | Right (separate Bash calls) |
|---|---|
| `git -C /tmp/wt status` | `cd /tmp/wt` → `git status` |
| `git add f && git commit -F m.txt` | `git add f` → `git commit -F m.txt` |
| `git commit -m "$(cat msg.txt)"` | `git commit -F msg.txt` |
| `echo "x" > file.txt` | Use the Write tool |
- Prefer dedicated tools over Bash: Read (not cat), Grep (not grep/rg), Glob (not find/ls), Edit (not sed), Write (not echo >).
- **Permission suggestions** must be general enough to help future runs. Not too specific (a single path), not too broad (`git:*`).
- **Post-session**: If any permission prompts occurred, evaluate whether command construction could have avoided them, and walk the user through any new local permissions to decide if they should move to user-level.
