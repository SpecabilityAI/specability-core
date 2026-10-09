# Changelog

All notable public Specability Core releases are recorded here.

## 0.5.0 - 2026-10-09

- Findings now carry conclusions between agents through the runtime. Architect and
  evaluator runs record typed findings before finishing; the newest active findings
  of a task compile into later agent bundles, and `specability task digest` gives the
  parent the same view without relying on host messages.
- Findings recorded after a dispatch is prepared now reach the running child: `agent
  start` and `next` return the new, withdrawn, or superseded findings, and a `done` or
  `concerns` finish waits once for findings the run has not been shown. Prepared
  bundles stay immutable.
- Delegation is easier to get right. `delegate` accepts one flat brief and reports
  every missing field at once with a filled example, `assignment redispatch` replaces
  a stalled child, `agent close --reason` closes one without writing its verdicts,
  unknown roles are rejected with the valid roles, inspection commands accept
  positional ids, and `task finish` accepts `--summary-stdin`.
- Advisories record who wrote them and a provenance class. An advisory recorded
  without a specialist run's agent id is self-attested and no longer satisfies a
  required independent review.
- Briefs and outputs are better specified: delegating roles receive a brief-authoring
  contract, every delegated role receives its own output contract, evaluator bundles
  carry the task's acceptance, and verification guidance requires a known-good
  comparison or an identified cause before a failure is called environmental.
- Fixes: the path-boundary probe covers Node synchronous file APIs, a handoff packet
  stays valid after the agent starts, `--from-agent` with an unknown agent returns an
  actionable error, and an explicit `--db` that does not exist is diagnosed instead of
  silently creating an empty database. `specability doctor` also reports legacy
  host-agent files and stray runtime databases without changing them.
- Runtime schema `v9` migrates transactionally to `v11`, adding advisory provenance
  records. Older binaries refuse the newer schema rather than writing it; back up the
  runtime database first if downgrade inspection may be needed. Agent bundles built
  by an earlier version report a compiler-version drift and need to be prepared again.

## 0.4.0 - 2026-09-20

- Module README guidance now uses an explicit registry. Agents decide which
  stable modules need durable orientation, create and maintain the README
  content, and manage registration through `specability readme`; the CLI no
  longer scans the repository or generates README prose.
- Registered module READMEs now describe Role, Owns, Touchpoints, Change Guide,
  and optional settled Decisions. Mechanical checks return actionable Agent
  guidance for invalid content, missing files, stale references, and registry
  repair without claiming semantic correctness.
- Session-start context now uses only valid registered modules, distinguishes an
  empty registry from unavailable or unhealthy registrations, and keeps
  delegated-role guidance out of the main-agent content index.
- Bounded README work can remain direct and unrecorded, while delegated and
  release-sensitive work retains recoverable evidence. Assignment work-profile
  applicability is now frozen at creation time so later catalog changes do not
  silently alter existing gates.
- Runtime schema `v8` migrates transactionally to `v9`, preserving existing
  tasks and assignments while adding frozen work-stage and applicability
  records. Older binaries refuse the newer schema rather than writing it; back
  up the runtime database first if downgrade inspection may be needed.
- Session-start context now omits absolute local paths and memory claim bodies;
  relevant memories are represented by safe metadata and explicit retrieval
  commands. Public privacy guidance now distinguishes local Specability
  processing from context intentionally supplied to the configured AI host.
- Release packaging, public-mirror checks, credential handling, and the shell,
  PowerShell, and npm installers now fail closed on mutable releases, unsafe
  versions, symlinks, permissive temporary files, inconclusive availability
  checks, and missing cross-channel publish authority.
- Runtime and global-memory database opens now reject symlinked or unrecognized
  SQLite targets before configuration or schema writes and safely encode valid
  URI metacharacters, preserving unrelated local databases instead of opening a
  different path or attempting an automatic rebuild.

## 0.3.2 - 2026-08-28

- Source-verification probes now separate production implementation evidence
  from test-only negative controls. Path, network target, redirect URL, query
  construction, command execution, and template-rendering checks no longer let
  tests establish production safety evidence.
- `path-boundary`, `network-target-selection`, `redirect-url-boundary`,
  `query-construction`, and `template-rendering` accept repeatable
  `--test-source` inputs, so a production file can be verified with tests kept
  elsewhere.
- Cleanup verification ignores test files, preventing a test-only cleanup stub
  from satisfying the cleanup-mechanism criterion.
- Codex host diagnostics and runtime guidance received reliability and recovery
  improvements; existing local runtime data remains compatible.

## 0.3.1 - 2026-08-07

- Codex hook installation now uses `hooks.json` as the sole Specability
  mutation authority. Inline `config.toml` hooks remain host-owned and are
  inspected read-only for duplicate detection.
- Existing installations automatically remove retired Specability Stop hook
  commands that exited without a continuation prompt, while preserving user
  Stop hooks and unrelated configuration.
- Codex hook diagnostics now identify unmarked inline SessionStart conflicts
  and stale Stop registrations with actionable repair guidance.


## 0.3.0 - 2026-08-02

- Retrospective is now a dedicated user-controlled workflow. The agent aligns
  the goal and subject before examining evidence, presents the complete set of
  candidate outcomes, and confirms each durable action before executing it.
- Reviewed personal methods can now be saved as private playbooks at an explicit
  project or global scope. Private identities remain source-qualified and cannot
  override built-in methodology.
- Playbook retrieval and SessionStart now use one bounded layered registry for
  built-in and private sources. Invalid private files fail soft with actionable
  diagnostics without exposing private bodies or absolute global paths.
- SessionStart includes a bounded private-playbook index and treats memory as
  recall-only; retrospective owns proposals for memory and other durable changes.
- Private playbook saves now work on Windows while preserving the file-sync
  boundary used before publication.
- Runtime schema `v7` is unchanged, so this release requires no database
  migration. Existing host hooks should be reinstalled to activate the new
  retrospective and SessionStart behavior; user-owned configuration is preserved.

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
