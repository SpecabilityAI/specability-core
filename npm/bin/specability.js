#!/usr/bin/env node
const { spawnSync } = require("node:child_process");
const { existsSync } = require("node:fs");
const { join } = require("node:path");

const binaryName = process.platform === "win32" ? "specability.exe" : "specability";
const binaryPath = join(__dirname, binaryName);

if (!existsSync(binaryPath)) {
  console.error("Specability is installed through npm, but the Specability Core binary is missing.");
  console.error(`Expected binary: ${binaryPath}\n`);
  console.error("Try this:");
  console.error("  1. Reinstall the package: npm install -g specability@latest");
  console.error("  2. If reinstalling fails, use the platform installer from https://github.com/SpecabilityAI/specability-core/releases");
  console.error("  3. Then run: specability doctor\n");
  process.exit(127);
}

const result = spawnSync(binaryPath, process.argv.slice(2), {
  stdio: "inherit",
  windowsHide: false
});

if (result.error) {
  console.error("Specability could not start.");
  console.error(`Reason: ${result.error.message}\n`);
  console.error("Try reinstalling with: npm install -g specability@latest\n");
  process.exit(1);
}

process.exit(result.status === null ? 1 : result.status);
