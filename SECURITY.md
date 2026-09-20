# Security

## Reporting Security Issues

Do not open a public issue for security-sensitive reports.

Email security reports to:

```text
security@specability.com
```

Include:

- Affected platform and version.
- Reproduction steps.
- Expected and actual behavior.
- Any relevant logs with secrets removed.

## Local Data Boundary

Specability Core is designed as local software and does not independently send
telemetry or upload source code, runtime state, or workflow data to
SpecabilityAI. An enabled SessionStart hook deliberately returns bounded
orientation to the selected AI host; the host may send that context to its
configured model provider. The automatic context omits absolute local paths and
memory claim bodies, but registered module orientation and methodology pointers
are provider-visible. Review the host and provider data policy before enabling
the hook.

If you observe behavior that appears to violate this boundary, treat it as a
security issue.
