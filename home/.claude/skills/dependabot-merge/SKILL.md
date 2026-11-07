---
name: dependabot-merge
description: Triage and auto-merge Dependabot PRs across GitHub notifications, orgs, or specific repos. Use when the user asks to approve/merge Dependabot PRs in bulk (e.g. "GitHub notification の dependabot PR いい感じのやつ merge して", "deariary org の dependabot PR まとめて処理", "この repo の Dependabot PR 全部通して"). Filters to CI-green + MERGEABLE PRs, approves and merges with `--merge` (never `--squash`), retries on stale-base errors, and requests `@dependabot rebase` on conflicts.
---

# Dependabot Merge

Bulk-triage Dependabot PRs: find them, verify they're safe (CI green, cleanly mergeable), approve, and merge — with the correct merge strategy and correct handling for the common transient failures.

## Scope selection

Ask the user or infer from their message which source to enumerate:

- **Notifications** — `gh api notifications --paginate --jq '.[] | select(.subject.type=="PullRequest") | .subject.url + "|" + .repository.full_name + "|" + .subject.title'` then filter to PRs authored by `app/dependabot`.
- **Org(s)** — `gh search prs --owner <org> --author app/dependabot --state open --json repository,number,title --limit 1000`. Repeat per org if multiple.
- **Repo(s)** — `gh pr list -R <owner/repo> --author app/dependabot --state open --json number,title --limit 1000`.

Prefer `gh search prs` over notifications when the user names an org/repo — notifications miss PRs the user isn't subscribed to and include already-merged items.

Never silently truncate the candidate list. If the result count equals the `--limit` (or `gh search` reports more total results than returned), say so in the summary instead of implying full coverage.

## Filter to safe-to-merge

For each candidate PR, fetch status:

```bash
gh pr view <num> -R <repo> --json state,mergeable,mergeStateStatus,statusCheckRollup,author,isDraft,headRefOid
```

Record `headRefOid` — every later decision (content review, approval, merge) is bound to this SHA.

Route these before the general filter:

- `mergeable == "CONFLICTING"` / `mergeStateStatus == "DIRTY"` or `mergeStateStatus == "BEHIND"` → rebase path (see below), not skip.

Proceed to review only when **all** of the following hold:

- `state == "OPEN"`
- `isDraft == false`
- `author.login == "app/dependabot"`
- `mergeable == "MERGEABLE"` and `mergeStateStatus` is `CLEAN`, or `BLOCKED` only because a review approval is missing (re-check for `CLEAN` after approving; anything else stays blocked)
- Every `statusCheckRollup[]` entry passes:
  - `CheckRun` (`conclusion`): `{SUCCESS, NEUTRAL, SKIPPED}` pass; `FAILURE`, `CANCELLED`, `TIMED_OUT`, `ACTION_REQUIRED` block. `NEUTRAL` is fine (e.g. Netlify header checks). A `null` conclusion means the check hasn't reported yet — skip unless the user explicitly opts in.
  - `StatusContext` (legacy, `state`): `SUCCESS` passes; `PENDING`/`EXPECTED` count as not reported; `FAILURE`/`ERROR` block.
- No zero-check case unless the repo genuinely has no CI (verify by checking a recently-merged PR in the same repo).

Skip anything that fails these filters and report why in the final summary.

## Review update contents

Before approving, scan each PR's body for what actually changes. Dependabot embeds release notes / changelog / commit list — read them, don't just trust CI.

```bash
gh pr view <num> -R <repo> --json title,body,additions,deletions,files
```

Assess and flag:

- **Semver jump** — parse `from X.Y.Z to A.B.C` in the title. `major` → always flag for the user (breaking changes possible even with green CI). `minor`/`patch` → normally safe.
- **Deprecations / removals / breaking-changes** — grep the body for `BREAKING`, `Breaking change`, `removed`, `deprecated`, `⚠️`. If any hit, flag it.
- **Security advisories** — informational only, not a flag: the `[security]` title marker is unreliable, so never gate merging on it. Mention it in the summary when the title or body indicates an advisory.
- **Unexpectedly large diff** — for a version-bump PR, `additions + deletions` in project code (excluding lockfiles) should be near zero. Anything else is a red flag.
- **Lockfile surprises** — skim the lockfile diff (`gh pr diff <num> -R <repo>`) for packages removed or downgraded beyond the named bump. Flag any.
- **Grouped updates** — titles like "bump the X group with N updates" → skim the body for each sub-bump the same way.

Merge without asking only when the bump is minor/patch, changelog looks routine, and no flags fire. If any flag fires, surface the specific concern to the user with the PR link and wait for a decision — do not silently merge and do not silently skip.

## Approve and merge

Parallelize across PRs with `xargs -P 5-10` (GitHub rate limit is fine at this rate). For each PR:

```bash
gh pr review <num> -R <repo> --approve
gh pr merge <num> -R <repo> --merge --match-head-commit <headRefOid>
```

If the head moved after review (merge rejects the SHA), re-run the filter and review against the new head instead of retrying blindly.

**Always use `--merge` (regular merge commit).** Never `--squash`. Never `--rebase` unless the user explicitly asks — the user's global CLAUDE.md forbids squash by default.

## Transient failure handling

- **`GraphQL: Base branch was modified. Review and try the merge again.`** — Another PR in the same repo merged between our mergeability check and the merge call. Re-check status; if still `MERGEABLE`/`CLEAN`, retry the merge. If the base move made it `CONFLICTING` or `BEHIND`, fall through to the rebase path below.
- **`CONFLICTING` / `DIRTY` / `BEHIND`** (found at triage or after a merge) — Post `@dependabot rebase` as a PR comment and move on. Do **not** try to resolve conflicts manually.
  ```bash
  gh pr comment <num> -R <repo> --body "@dependabot rebase"
  ```
- **CI still pending** — Skip the PR for this run and note it in the summary. Do not enable `--auto` unless the user asks; auto-merge silently merges later, which is surprising in a triage flow.

## Reporting

At the end, report four groups concisely:

1. **Merged** — repo#num list, each with a one-line "what changed" (e.g. `bump foo 1.2.3 → 1.2.4 (patch, routine changelog)`).
2. **Flagged, awaiting decision** — repo#num with the concrete concern (major bump, breaking-change notice, unexpectedly large diff, lockfile removal/downgrade).
3. **Rebase requested** — repo#num list (waiting for Dependabot to rebase).
4. **Skipped** — repo#num with one-line reason (CI failing, pending, draft, non-dependabot, etc.). Note any truncated enumeration here too.

Do not mark GitHub notifications as read unless the user asks.

## Do not touch

- Non-Dependabot PRs surfaced by the notification query (daily-log bots, other automation). Filter strictly on `author.login == "app/dependabot"`.
- Major-version bumps in production dependencies if the user has previously flagged that risk — check memory for repo-specific feedback before merging.
