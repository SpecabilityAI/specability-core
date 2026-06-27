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

Download the latest release for your platform from
[GitHub Releases](https://github.com/SpecabilityAI/specability-core/releases).

Supported preview targets:

- macOS Apple Silicon: `darwin_arm64`
- macOS Intel: `darwin_amd64`
- Linux x64: `linux_amd64`
- Linux arm64: `linux_arm64`
- Windows x64: `windows_amd64`

See [docs/install.md](docs/install.md) for platform-specific steps.

## Verify A Download

Every release includes `checksums.txt`.

```bash
shasum -a 256 -c checksums.txt
```

See [docs/verify.md](docs/verify.md) for details.

## First Check

After installing:

```bash
specability doctor
specability playbook list
specability spec list
```

## Feedback

Specability Core does not send telemetry automatically. Feedback is explicit:
you choose what to share.

Use GitHub Issues for:

- Installation or runtime bugs.
- Real workflow feedback.
- Requests for new playbooks, specs, or workflow support.

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
