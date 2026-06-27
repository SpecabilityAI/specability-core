# Install Specability Core

Download the latest release from:

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

Download the archive for your platform, then:

```bash
tar -xzf specability-core_<version>_<platform>_<arch>.tar.gz
chmod +x specability
sudo mv specability /usr/local/bin/specability
specability doctor
```

Optional installer:

```bash
curl -fsSL https://raw.githubusercontent.com/SpecabilityAI/specability-core/main/install.sh | sh
```

To install without `sudo`:

```bash
mkdir -p "$HOME/.local/bin"
SPECABILITY_INSTALL_DIR="$HOME/.local/bin" sh install.sh
```

Ensure the target directory is on your `PATH`.

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
