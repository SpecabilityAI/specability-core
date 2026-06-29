# Specability Core

Specability Core is a free local agent harness for coding workflows.

This repository distributes free local builds, checksums, release notes,
installation instructions, and feedback channels for Specability Core.

The complete source code and advanced method packs are developed privately.

## What You Get

- A local `specability` command-line binary.
- Coding-focused Starter Pack content.
- Local runtime state stored under your project.
- Host integration for agent workflows.
- No automatic upload of source code, runtime state, or workflow data.

## Install

macOS and Linux install script:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh
```

Node/npm users:

```bash
npm install -g specability
```

Homebrew users:

```bash
brew tap SpecabilityAI/tap
brew trust specabilityai/tap
brew install specability
```

Windows PowerShell:

```powershell
iwr https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.ps1 -UseB | iex
```

See [docs/install.md](docs/install.md) for the review-before-run PowerShell
path.

To install a specific preview:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh -s -- --version v0.1.0-preview.1
```

Windows users can also download the zip from
[GitHub Releases](https://github.com/SpecabilityAI/specability-core/releases).

Supported preview targets:

- macOS Apple Silicon: `darwin_arm64`
- macOS Intel: `darwin_amd64`
- Linux x64: `linux_amd64`
- Linux arm64: `linux_arm64`
- Windows x64: `windows_amd64`

See [docs/install.md](docs/install.md) for platform-specific steps, package
manager notes, custom install directories, and uninstall instructions.

## Verify A Download

Every release includes `checksums.txt`.

```bash
grep 'specability-core_<version>_<platform>_<arch>' checksums.txt | shasum -a 256 -c -
```

The macOS/Linux installer downloads `checksums.txt` and verifies the selected
archive before installing.

The npm and PowerShell installers also verify SHA256 checksums before exposing
the `specability` command.

See [docs/verify.md](docs/verify.md) for details.

## Activate

After installing, choose the AI coding tool you use and activate Specability:

```bash
specability install hook --host claude --scope global   # Claude Code
specability install hook --host codex  --scope global   # Codex CLI
specability install hook --host gemini --scope global   # Gemini CLI
```

Then open a new agent session. Specability will load its workflow guidance
automatically when that session starts.

## Verify

```bash
specability doctor
```

## Feedback

Specability Core does not send telemetry automatically. Feedback is explicit:
you choose what to share.

Use GitHub Issues for:

- Installation or runtime bugs.
- Real workflow feedback.
- Requests for new methodology content or workflow support.

See [docs/feedback.md](docs/feedback.md).

## Product Line

- **Specability Core**: free local coding-agent harness with the Starter Pack.
- **Specability [Domain]**: domain expansions shaped with partners.
- **Specability Enterprise**: paid enterprise customization and deployment.

## Repository Boundary

This is a public distribution repository. It is not the complete product source
repository.

It contains public documentation, installation guidance, feedback templates, and
release artifacts. It does not contain the complete source code, full method
library, Partner Packs, Domain Previews, Domain Products, or Enterprise content.
