# Install Specability Core

macOS and Linux users can install the latest published preview with:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh
```

The installer downloads the matching archive and `checksums.txt`, verifies the
archive, installs the `specability` binary, and prints `specability version`.

To install a specific release:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh -s -- --version v0.1.0-preview.1
```

Equivalent environment-variable form:

```bash
SPECABILITY_VERSION=v0.1.0-preview.1 sh install.sh
```

The default install directory is `/usr/local/bin` when writable, otherwise
`$HOME/.local/bin`. To choose a directory:

```bash
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | \
  SPECABILITY_INSTALL_DIR="$HOME/.local/bin" sh
```

Ensure the target directory is on your `PATH`.

To uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh -s -- --uninstall
```

Or remove the binary directly:

```bash
rm -f "$HOME/.local/bin/specability"
rm -f /usr/local/bin/specability
```

Manual downloads are available from:

```text
https://github.com/SpecabilityAI/specability-core/releases
```

## Release Assets

Preview releases use these asset names:

```text
specability-core_<version>_darwin_arm64.tar.gz
specability-core_<version>_darwin_amd64.tar.gz
specability-core_<version>_linux_arm64.tar.gz
specability-core_<version>_linux_amd64.tar.gz
specability-core_<version>_windows_amd64.zip
checksums.txt
```

The installed command is `specability`.

## macOS And Linux

If you prefer manual installation, download the archive for your platform and
`checksums.txt`, then:

```bash
grep 'specability-core_<version>_<platform>_<arch>' checksums.txt | shasum -a 256 -c -
tar -xzf specability-core_<version>_<platform>_<arch>.tar.gz
chmod +x specability
sudo mv specability /usr/local/bin/specability
specability doctor
```

## Windows

Download:

```text
specability-core_<version>_windows_amd64.zip
```

Then:

1. Extract the zip file.
2. Move `specability.exe` to a directory on your `PATH`.
3. Open PowerShell and run:

```powershell
specability doctor
```

## First Commands

```bash
specability doctor
specability playbook list
specability spec list
```
