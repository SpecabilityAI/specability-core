# Verify Downloads

Every release should include `checksums.txt`.

Download the asset for your platform and `checksums.txt` into the same
directory.

The macOS/Linux installer performs this check automatically before copying the
binary into the install directory.

The npm and PowerShell installers also verify the selected release archive
against `checksums.txt`.

## macOS And Linux

```bash
grep 'specability-core_<version>_<platform>_<arch>' checksums.txt | shasum -a 256 -c -
```

Or:

```bash
grep 'specability-core_<version>_<platform>_<arch>' checksums.txt | sha256sum -c -
```

The command should report `OK` for the downloaded archive.

## Windows

In PowerShell:

```powershell
Get-FileHash .\specability-core_<version>_windows_amd64.zip -Algorithm SHA256
```

Compare the hash to the matching line in `checksums.txt`.

## Trust Boundary

Specability Core is local software. It should not automatically upload source
code, runtime state, or workflow data.

If you observe behavior that appears to violate this boundary, report it through
the security channel in `SECURITY.md`.
