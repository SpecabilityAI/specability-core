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

Specability Core is designed as local software. It should not automatically
upload source code, runtime state, or workflow data.

If you observe behavior that appears to violate this boundary, treat it as a
security issue.
