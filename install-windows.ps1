# Memory Layer MCP Server - Windows Installer
# Run this script in PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Memory Layer MCP Server Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check Node.js
Write-Host "[1/5] Checking Node.js version..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js detected: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js is not installed" -ForegroundColor Red
    Write-Host "Please download and install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# 2. Create installation directory
Write-Host ""
Write-Host "[2/5] Creating installation directory..." -ForegroundColor Yellow
$installDir = "$env:USERPROFILE\mcp-servers\memory-layer-mcp"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Write-Host "✓ Directory created: $installDir" -ForegroundColor Green

# 3. Copy files
Write-Host ""
Write-Host "[3/5] Copying files..." -ForegroundColor Yellow
$currentDir = $PSScriptRoot
Copy-Item "$currentDir\package.json" -Destination $installDir -Force
Copy-Item "$currentDir\index.js" -Destination $installDir -Force
Copy-Item "$currentDir\README.md" -Destination $installDir -Force
Write-Host "✓ Files copied" -ForegroundColor Green

# 4. Install npm dependencies
Write-Host ""
Write-Host "[4/5] Installing dependencies..." -ForegroundColor Yellow
Push-Location $installDir
npm install --silent
Pop-Location
Write-Host "✓ Dependencies installed" -ForegroundColor Green

# 5. Create Claude configuration file
Write-Host ""
Write-Host "[5/5] Creating Claude configuration file..." -ForegroundColor Yellow

# API Key input
Write-Host ""
Write-Host "Please enter your Memory Layer API Key:" -ForegroundColor Cyan
Write-Host "(Get it from https://memory-layer.emotiai.ai/settings/api-keys)" -ForegroundColor Gray
$apiKey = Read-Host "API Key"

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "⚠ API Key was not entered. You can set it manually later." -ForegroundColor Yellow
    $apiKey = "YOUR_API_KEY_HERE"
}

$claudeConfigDir = "$env:APPDATA\Claude"
$claudeConfigFile = "$claudeConfigDir\claude_desktop_config.json"

# Create directory
New-Item -ItemType Directory -Force -Path $claudeConfigDir | Out-Null

# Create configuration file
$configContent = @"
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": [
        "$($installDir -replace '\\', '\\')\index.js"
      ],
      "env": {
        "MEMORY_LAYER_API_KEY": "$apiKey"
      }
    }
  }
}
"@

$configContent | Out-File -FilePath $claudeConfigFile -Encoding UTF8 -Force
Write-Host "✓ Configuration file created: $claudeConfigFile" -ForegroundColor Green

# Completion message
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart Claude Desktop app" -ForegroundColor White
Write-Host "2. In a conversation, say 'Save this conversation to Memory Layer'" -ForegroundColor White
Write-Host ""
Write-Host "Config file: $claudeConfigFile" -ForegroundColor Gray
Write-Host "Installation directory: $installDir" -ForegroundColor Gray
Write-Host ""

# Ask if user wants to open config file in editor
$openConfig = Read-Host "Do you want to open the configuration file in an editor? (Y/N)"
if ($openConfig -eq "Y" -or $openConfig -eq "y") {
    notepad $claudeConfigFile
}

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
