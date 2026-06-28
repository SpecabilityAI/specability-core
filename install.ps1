param(
  [string]$Version = $env:SPECABILITY_VERSION,
  [string]$InstallDir = $env:SPECABILITY_INSTALL_DIR,
  [switch]$Uninstall,
  [string]$Repo = $(if ($env:SPECABILITY_REPO) { $env:SPECABILITY_REPO } else { "SpecabilityAI/specability-core" })
)

$ErrorActionPreference = "Stop"

if (-not $InstallDir) {
  if ($env:LOCALAPPDATA) {
    $InstallDir = Join-Path $env:LOCALAPPDATA "Specability\bin"
  } else {
    $InstallDir = Join-Path $HOME ".specability\bin"
  }
}

$BinaryPath = Join-Path $InstallDir "specability.exe"

if ($Uninstall) {
  Remove-Item -LiteralPath $BinaryPath -Force -ErrorAction SilentlyContinue
  Write-Host "removed $BinaryPath"
  exit 0
}

if (-not [Environment]::Is64BitOperatingSystem) {
  throw "Specability Core preview builds currently support Windows x64."
}

$ApiBase = if ($env:GITHUB_API_URL) { $env:GITHUB_API_URL } else { "https://api.github.com" }
$Headers = @{
  "User-Agent" = "specability-powershell-installer"
  "Accept" = "application/vnd.github+json"
}

if (-not $Version) {
  $Releases = Invoke-RestMethod -Uri "$ApiBase/repos/$Repo/releases" -Headers $Headers
  if (-not $Releases -or $Releases.Count -eq 0) {
    throw "Could not find a Specability Core release."
  }
  $Version = $Releases[0].tag_name
}

$Release = Invoke-RestMethod -Uri "$ApiBase/repos/$Repo/releases/tags/$Version" -Headers $Headers
$AssetName = "specability-core_${Version}_windows_amd64.zip"
$Asset = $Release.assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1
$Checksums = $Release.assets | Where-Object { $_.name -eq "checksums.txt" } | Select-Object -First 1

if (-not $Asset) {
  throw "Could not find release asset $AssetName."
}

if (-not $Checksums) {
  throw "Could not find checksums.txt for $Version."
}

$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("specability-core-install-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $TempDir | Out-Null

try {
  $ArchivePath = Join-Path $TempDir $AssetName
  $ChecksumsPath = Join-Path $TempDir "checksums.txt"
  Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $ArchivePath -UseBasicParsing
  Invoke-WebRequest -Uri $Checksums.browser_download_url -OutFile $ChecksumsPath -UseBasicParsing

  $ChecksumLine = Get-Content -LiteralPath $ChecksumsPath | Where-Object { $_ -match "\s+$([regex]::Escape($AssetName))$" } | Select-Object -First 1
  if (-not $ChecksumLine) {
    throw "checksums.txt did not contain $AssetName."
  }

  $ExpectedHash = ($ChecksumLine -split "\s+")[0].ToLowerInvariant()
  $ActualHash = (Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($ActualHash -ne $ExpectedHash) {
    throw "Checksum mismatch for ${AssetName}: expected $ExpectedHash, got $ActualHash."
  }

  Expand-Archive -LiteralPath $ArchivePath -DestinationPath $TempDir -Force
  $ExtractedBinary = Join-Path $TempDir "specability.exe"
  if (-not (Test-Path -LiteralPath $ExtractedBinary)) {
    throw "Archive did not contain specability.exe."
  }

  New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
  Copy-Item -LiteralPath $ExtractedBinary -Destination $BinaryPath -Force

  Write-Host "installed Specability Core $Version to $BinaryPath"

  $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
  $MachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
  if (((";${UserPath};${MachinePath};") -notlike "*;$InstallDir;*")) {
    Write-Warning "$InstallDir is not on PATH."
  }

  & $BinaryPath version
} finally {
  Remove-Item -LiteralPath $TempDir -Recurse -Force -ErrorAction SilentlyContinue
}
