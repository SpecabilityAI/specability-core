#!/usr/bin/env node
const { spawnSync } = require("node:child_process");
const { existsSync } = require("node:fs");
const { join } = require("node:path");

const binaryName = process.platform === "win32" ? "specability.exe" : "specability";
const binaryPath = join(__dirname, binaryName);

if (!existsSync(binaryPath)) {
  console.error(`Specability binary is missing: ${binaryPath}`);
  console.error("Try reinstalling with: npm install -g specability");
  process.exit(127);
}

const result = spawnSync(binaryPath, process.argv.slice(2), {
  stdio: "inherit",
  windowsHide: false
});

if (result.error) {
  console.error(result.error.message);
  process.exit(1);
}

process.exit(result.status === null ? 1 : result.status);
