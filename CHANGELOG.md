# Changelog

All notable public Specability Core releases are recorded here.

## 0.2.0 - 2026-07-28

- Session-start guidance now orients the main agent around the user-visible
  outcome, relevant project context, proportional workflow choice, and explicit
  recovery rather than treating hook startup as a task plan.
- Delegated work now uses fresh sub-agents with bounded handoff packets,
  pull-retrieved role guidance, parent-agent escalation, and independent evaluator
  boundaries.
- Direct, delegated, and effect-evaluated execution can preserve Task Frames,
  criteria, artifacts, checks, and recovery evidence without imposing runtime
  ceremony on tiny local work.
- Claude Code, Codex, and Gemini CLI hook installation now preserves user-owned
  configuration more carefully, normalizes Specability-owned entries, and rejects
  ambiguous or malformed ownership state before writing.
- Runtime schema `v6` migrates transactionally to `v7`, preserving existing tasks,
  assignments, artifacts, and checks while allowing task-scoped artifacts without
  an assignment. Failed migrations roll back and can be retried.
- The runtime migration is forward-only. Back up the local runtime database before
  upgrading if downgrade inspection is important, and do not use an older binary
  to write to a database already opened by `v0.2.0`.
- Reinstall existing host hooks with `specability install hook` to activate the
  current command and ownership format; configuration outside Specability's owned
  boundary is preserved.

## 0.1.4 - 2026-07-04

- Scan and project-map context no longer treat broad project or documentation
  READMEs as structured module contracts.
- Real code modules, package/app containers, and content modules continue to be
  included in README structure checks.
- Doctor diagnostics no longer expose embedded content inventory details.
- No runtime schema migration is included in this release.

## 0.1.3 - 2026-06-30

- Fixed Windows runtime database initialization for drive-letter paths such as
  `F:\AIcode\test\.specability\runtime\specability.sqlite`.
- Runtime database opens now keep the SQLite driver's transaction-lock option
  without encoding Windows paths as `file://` URI authorities.
- Windows users who saw `SQL logic error: invalid uri authority` during
  session-start context loading should upgrade to this release.

## 0.1.2 - 2026-06-29

- Runtime and memory database initialization now rebuilds stale local schemas
  instead of attempting in-place migration.
- Databases that carry a current version marker but do not match the current
  required schema shape are treated as stale and rebuilt.
- This is an intentionally forward-only local runtime-state reset for stale
  Specability runtime and memory databases; back up old local runtime data before
  opening it with this release if historical rows must be inspected.

## Unreleased

- Initial public distribution repository scaffold.
- Preview release process planned for macOS, Linux, and Windows builds.
- macOS/Linux installer now supports preview release lookup, explicit release
  tags, checksum verification, custom install directories, and uninstall.
- npm, Homebrew tap, and Windows PowerShell installer surfaces are now wired to
  the same GitHub Release assets and checksum contract.
