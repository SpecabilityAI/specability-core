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

## npm

Node users can install the global launcher:

```bash
npm install -g specability
```

The npm package is a thin installer and launcher. By default it downloads the
Specability Core release that matches the npm package version, verifies
`checksums.txt`, and then exposes the `specability` command through npm's
normal global bin path.

To install a specific release through npm:

```bash
npm install -g specability --specability_version=v0.1.0-preview.2
```

## Homebrew

macOS and Linux Homebrew users can install from the Specability tap:

```bash
brew tap SpecabilityAI/tap
brew trust specabilityai/tap
brew install specability
```

The tap formula references the same GitHub Release archives and SHA256
checksums as the installer script. Homebrew 6 requires explicit trust for
third-party taps before installing formulae from them.

## Windows PowerShell

Recommended PowerShell path:

```powershell
iwr https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.ps1 -OutFile install.ps1
Get-Content .\install.ps1 -TotalCount 40
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Low-friction one-liner:

```powershell
iwr https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.ps1 -UseB | iex
```

To install a specific release:

```powershell
& ([scriptblock]::Create((iwr https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.ps1 -UseB))) -Version v0.1.0-preview.2
```

The default install directory is `%LOCALAPPDATA%\Specability\bin`. Add that
directory to your user `Path` if PowerShell reports that it is not already on
`PATH`. The installer does not silently modify `PATH`.

To uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh -s -- --uninstall
```

Or remove the binary directly:

```bash
rm -f "$HOME/.local/bin/specability"
rm -f /usr/local/bin/specability
```

PowerShell uninstall:

```powershell
& ([scriptblock]::Create((iwr https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.ps1 -UseB))) -Uninstall
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

If you prefer manual installation, download:

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
