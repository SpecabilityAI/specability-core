# Changelog

All notable public Specability Core releases are recorded here.

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
