#!/usr/bin/env sh
set -eu

repo="${SPECABILITY_REPO:-SpecabilityAI/specability-core}"
api_base="${GITHUB_API_URL:-https://api.github.com}/repos/$repo"
version="${SPECABILITY_VERSION:-}"
command="install"

usage() {
  cat <<'EOF'
Usage:
  install.sh [--version v0.1.0-preview.1]
  install.sh --uninstall

Environment:
  SPECABILITY_VERSION       Release tag to install.
  SPECABILITY_INSTALL_DIR   Directory for the specability binary.
  SPECABILITY_REPO          GitHub repository, default SpecabilityAI/specability-core.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --uninstall)
      command="uninstall"
      ;;
    --version)
      shift
      if [ "$#" -eq 0 ]; then
        echo "--version requires a release tag" >&2
        exit 1
      fi
      version="$1"
      ;;
    v*)
      version="$1"
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

default_install_dir() {
  if { [ -d /usr/local/bin ] && [ -w /usr/local/bin ]; } || \
    { [ ! -e /usr/local/bin ] && [ -w /usr/local ]; }; then
    printf '%s\n' /usr/local/bin
  else
    printf '%s\n' "${HOME:-.}/.local/bin"
  fi
}

install_dir="${SPECABILITY_INSTALL_DIR:-$(default_install_dir)}"

if [ "$command" = "uninstall" ]; then
  rm -f "$install_dir/specability"
  echo "removed $install_dir/specability"
  exit 0
fi

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "$os" in
  darwin) platform="darwin" ;;
  linux) platform="linux" ;;
  *) echo "unsupported OS: $os" >&2; exit 1 ;;
esac

case "$arch" in
  arm64|aarch64) arch="arm64" ;;
  x86_64|amd64) arch="amd64" ;;
  *) echo "unsupported architecture: $arch" >&2; exit 1 ;;
esac

tmp="${TMPDIR:-/tmp}/specability-core-install.$$"
mkdir -p "$tmp"
trap 'rm -rf "$tmp"' EXIT INT TERM

if [ -z "$version" ]; then
  curl -fsSL "$api_base/releases" -o "$tmp/releases.json"
  version="$(
    sed -n 's/.*"tag_name": "\(.*\)".*/\1/p' "$tmp/releases.json" |
      head -n 1
  )"
fi

if [ -z "$version" ]; then
  echo "could not find a Specability Core release" >&2
  exit 1
fi

curl -fsSL "$api_base/releases/tags/$version" -o "$tmp/release.json"

asset_pattern="specability-core_${version}_${platform}_${arch}\\.tar\\.gz"

asset_url="$(
  sed -n 's/.*"browser_download_url": "\(.*\)".*/\1/p' "$tmp/release.json" |
    grep -E "/${asset_pattern}$" |
    head -n 1
)"

checksums_url="$(
  sed -n 's/.*"browser_download_url": "\(.*\)".*/\1/p' "$tmp/release.json" |
    grep -E '/checksums\.txt$' |
    head -n 1
)"

if [ -z "$asset_url" ]; then
  echo "could not find a release asset for ${version} ${platform}_${arch}" >&2
  exit 1
fi

if [ -z "$checksums_url" ]; then
  echo "could not find checksums.txt for ${version}" >&2
  exit 1
fi

asset_name="${asset_url##*/}"
archive="$tmp/$asset_name"
checksums="$tmp/checksums.txt"
selected_checksums="$tmp/selected-checksums.txt"

curl -fsSL "$asset_url" -o "$archive"
curl -fsSL "$checksums_url" -o "$checksums"

if ! grep "  $asset_name\$" "$checksums" > "$selected_checksums"; then
  echo "checksums.txt did not contain $asset_name" >&2
  exit 1
fi

if command -v shasum >/dev/null 2>&1; then
  (
    cd "$tmp"
    shasum -a 256 -c "$selected_checksums"
  )
elif command -v sha256sum >/dev/null 2>&1; then
  (
    cd "$tmp"
    sha256sum -c "$selected_checksums"
  )
else
  echo "shasum or sha256sum is required to verify the download" >&2
  exit 1
fi

tar -xzf "$archive" -C "$tmp"

if [ ! -f "$tmp/specability" ]; then
  echo "archive did not contain specability binary" >&2
  exit 1
fi

mkdir -p "$install_dir"
cp "$tmp/specability" "$install_dir/specability"
chmod +x "$install_dir/specability"

printf '\nSpecability Core %s installed.\n\n' "$version"
printf 'Location:\n  %s\n' "$install_dir/specability"

case ":$PATH:" in
  *":$install_dir:"*) ;;
  *)
    printf '\nNeeds attention:\n'
    printf '  This folder is not on PATH yet:\n'
    printf '  %s\n\n' "$install_dir"
    printf '  Add it to PATH, then open a new terminal.\n'
    ;;
esac

cat <<'EOF'

Next steps:
  1. Choose the AI coding tool you use, then run one of these commands:

     Claude Code:  specability install hook --host claude --scope global
     Codex CLI:    specability install hook --host codex  --scope global
     Gemini CLI:   specability install hook --host gemini --scope global

  2. Open a new agent session.
  3. Run `specability doctor` to check the setup.

Installed version:
EOF
"$install_dir/specability" version || true
