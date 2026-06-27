#!/usr/bin/env sh
set -eu

repo="SpecabilityAI/specability-core"
install_dir="${SPECABILITY_INSTALL_DIR:-/usr/local/bin}"

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

api="https://api.github.com/repos/$repo/releases/latest"
asset_pattern="specability-core_.*_${platform}_${arch}\\.tar\\.gz"

asset_url="$(
  curl -fsSL "$api" |
    sed -n 's/.*"browser_download_url": "\(.*\)".*/\1/p' |
    grep -E "$asset_pattern" |
    head -n 1
)"

if [ -z "$asset_url" ]; then
  echo "could not find a release asset for ${platform}_${arch}" >&2
  exit 1
fi

archive="$tmp/specability-core.tar.gz"
curl -fsSL "$asset_url" -o "$archive"
tar -xzf "$archive" -C "$tmp"

if [ ! -f "$tmp/specability" ]; then
  echo "archive did not contain specability binary" >&2
  exit 1
fi

mkdir -p "$install_dir"
cp "$tmp/specability" "$install_dir/specability"
chmod +x "$install_dir/specability"

echo "installed $install_dir/specability"
"$install_dir/specability" version || true
