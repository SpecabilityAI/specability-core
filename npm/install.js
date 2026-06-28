#!/usr/bin/env node
const { createHash } = require("node:crypto");
const { copyFileSync, createWriteStream, existsSync, readFileSync, rmSync } = require("node:fs");
const { chmod, mkdtemp } = require("node:fs/promises");
const { get } = require("node:https");
const { tmpdir } = require("node:os");
const { basename, join } = require("node:path");
const { spawnSync } = require("node:child_process");

const repo = process.env.SPECABILITY_REPO || "SpecabilityAI/specability-core";
const apiBase = process.env.GITHUB_API_URL || "https://api.github.com";
const pkg = JSON.parse(readFileSync(join(__dirname, "..", "package.json"), "utf8"));
const requestedVersion =
  process.env.SPECABILITY_VERSION ||
  process.env.npm_config_specability_version ||
  `v${pkg.binaryVersion || pkg.version}`;

const platformMap = {
  darwin: "darwin",
  linux: "linux",
  win32: "windows"
};

const archMap = {
  x64: "amd64",
  arm64: "arm64"
};

function request(url, headers = {}) {
  return new Promise((resolve, reject) => {
    get(url, {
      headers: {
        "User-Agent": "specability-npm-installer",
        "Accept": "application/vnd.github+json",
        ...headers
      }
    }, (response) => {
      if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
        request(response.headers.location, headers).then(resolve, reject);
        response.resume();
        return;
      }
      if (response.statusCode !== 200) {
        reject(new Error(`GET ${url} failed with HTTP ${response.statusCode}`));
        response.resume();
        return;
      }
      const chunks = [];
      response.on("data", (chunk) => chunks.push(chunk));
      response.on("end", () => resolve(Buffer.concat(chunks)));
    }).on("error", reject);
  });
}

async function download(url, destination) {
  await new Promise((resolve, reject) => {
    get(url, { headers: { "User-Agent": "specability-npm-installer" } }, (response) => {
      if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
        download(response.headers.location, destination).then(resolve, reject);
        response.resume();
        return;
      }
      if (response.statusCode !== 200) {
        reject(new Error(`download failed with HTTP ${response.statusCode}: ${url}`));
        response.resume();
        return;
      }
      const file = createWriteStream(destination);
      response.pipe(file);
      file.on("finish", () => file.close(resolve));
      file.on("error", reject);
    }).on("error", reject);
  });
}

async function releaseForVersion(version) {
  if (version) {
    const body = await request(`${apiBase}/repos/${repo}/releases/tags/${version}`);
    return JSON.parse(body.toString("utf8"));
  }
  const body = await request(`${apiBase}/repos/${repo}/releases`);
  const releases = JSON.parse(body.toString("utf8"));
  if (!Array.isArray(releases) || releases.length === 0) {
    throw new Error("No Specability Core releases found.");
  }
  return releases[0];
}

function findAsset(release, namePattern) {
  const asset = (release.assets || []).find((candidate) => namePattern.test(candidate.name));
  if (!asset) {
    throw new Error(`Release ${release.tag_name} does not contain asset matching ${namePattern}.`);
  }
  return asset;
}

function expectedHash(checksumsText, assetName) {
  const line = checksumsText.split(/\r?\n/).find((entry) => entry.endsWith(`  ${assetName}`));
  if (!line) {
    throw new Error(`checksums.txt does not contain ${assetName}.`);
  }
  return line.trim().split(/\s+/)[0];
}

function sha256(path) {
  const hash = createHash("sha256");
  hash.update(readFileSync(path));
  return hash.digest("hex");
}

function extractArchive(archivePath, workDir, isWindows) {
  if (isWindows) {
    const psArchive = archivePath.replace(/'/g, "''");
    const psWorkDir = workDir.replace(/'/g, "''");
    const result = spawnSync("powershell.exe", [
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-Command",
      `Expand-Archive -LiteralPath '${psArchive}' -DestinationPath '${psWorkDir}' -Force`
    ], { stdio: "inherit" });
    if (result.status !== 0) {
      throw new Error("PowerShell Expand-Archive failed.");
    }
    return;
  }
  const result = spawnSync("tar", ["-xzf", archivePath, "-C", workDir], { stdio: "inherit" });
  if (result.status !== 0) {
    throw new Error("tar extraction failed.");
  }
}

async function main() {
  const releasePlatform = platformMap[process.platform];
  const releaseArch = archMap[process.arch];
  if (!releasePlatform || !releaseArch) {
    throw new Error(`Unsupported platform: ${process.platform}/${process.arch}`);
  }

  const release = await releaseForVersion(requestedVersion);
  const extension = releasePlatform === "windows" ? "zip" : "tar.gz";
  const assetPattern = new RegExp(`^specability-core_${release.tag_name}_${releasePlatform}_${releaseArch}\\.${extension.replace(".", "\\.")}$`);
  const asset = findAsset(release, assetPattern);
  const checksums = findAsset(release, /^checksums\.txt$/);
  const workDir = await mkdtemp(join(tmpdir(), "specability-npm-"));
  const archivePath = join(workDir, asset.name);
  const checksumsPath = join(workDir, "checksums.txt");

  try {
    await download(asset.browser_download_url, archivePath);
    await download(checksums.browser_download_url, checksumsPath);

    const want = expectedHash(readFileSync(checksumsPath, "utf8"), asset.name);
    const got = sha256(archivePath);
    if (got !== want) {
      throw new Error(`Checksum mismatch for ${asset.name}: expected ${want}, got ${got}`);
    }

    extractArchive(archivePath, workDir, releasePlatform === "windows");

    const binaryName = releasePlatform === "windows" ? "specability.exe" : "specability";
    const sourceBinary = join(workDir, binaryName);
    if (!existsSync(sourceBinary)) {
      throw new Error(`Archive ${basename(archivePath)} did not contain ${binaryName}.`);
    }

    const destination = join(__dirname, "bin", binaryName);
    copyFileSync(sourceBinary, destination);
    if (releasePlatform !== "windows") {
      await chmod(destination, 0o755);
    }
    console.log(`Installed Specability Core ${release.tag_name} for ${releasePlatform}/${releaseArch}.`);
  } finally {
    rmSync(workDir, { recursive: true, force: true });
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
