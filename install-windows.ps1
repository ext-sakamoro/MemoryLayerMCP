# Memory Layer MCP Server - Windows インストーラー
# PowerShellで実行してください

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Memory Layer MCP Server Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Node.js確認
Write-Host "[1/5] Node.jsのバージョンを確認中..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js detected: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.jsがインストールされていません" -ForegroundColor Red
    Write-Host "https://nodejs.org/ からダウンロードしてインストールしてください" -ForegroundColor Red
    exit 1
}

# 2. インストール先ディレクトリ作成
Write-Host ""
Write-Host "[2/5] インストール先ディレクトリを作成中..." -ForegroundColor Yellow
$installDir = "$env:USERPROFILE\mcp-servers\memory-layer-mcp"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Write-Host "✓ Directory created: $installDir" -ForegroundColor Green

# 3. ファイルコピー
Write-Host ""
Write-Host "[3/5] ファイルをコピー中..." -ForegroundColor Yellow
$currentDir = $PSScriptRoot
Copy-Item "$currentDir\package.json" -Destination $installDir -Force
Copy-Item "$currentDir\index.js" -Destination $installDir -Force
Copy-Item "$currentDir\README.md" -Destination $installDir -Force
Write-Host "✓ Files copied" -ForegroundColor Green

# 4. npm install実行
Write-Host ""
Write-Host "[4/5] 依存関係をインストール中..." -ForegroundColor Yellow
Push-Location $installDir
npm install --silent
Pop-Location
Write-Host "✓ Dependencies installed" -ForegroundColor Green

# 5. Claude設定ファイル作成
Write-Host ""
Write-Host "[5/5] Claude設定ファイルを作成中..." -ForegroundColor Yellow

# API Key入力
Write-Host ""
Write-Host "Memory Layer API Keyを入力してください:" -ForegroundColor Cyan
Write-Host "(https://memory-layer.emotiai.ai/settings/api-keys で取得)" -ForegroundColor Gray
$apiKey = Read-Host "API Key"

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "⚠ API Keyが入力されませんでした。後で手動で設定してください。" -ForegroundColor Yellow
    $apiKey = "YOUR_API_KEY_HERE"
}

$claudeConfigDir = "$env:APPDATA\Claude"
$claudeConfigFile = "$claudeConfigDir\claude_desktop_config.json"

# ディレクトリ作成
New-Item -ItemType Directory -Force -Path $claudeConfigDir | Out-Null

# 設定ファイル作成
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

# 完了メッセージ
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "インストール完了！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "次のステップ:" -ForegroundColor Yellow
Write-Host "1. Claudeデスクトップアプリを再起動" -ForegroundColor White
Write-Host "2. 会話中に「この会話をMemory Layerに保存して」と指示" -ForegroundColor White
Write-Host ""
Write-Host "設定ファイル: $claudeConfigFile" -ForegroundColor Gray
Write-Host "インストール先: $installDir" -ForegroundColor Gray
Write-Host ""

# エディタで設定ファイルを開くか確認
$openConfig = Read-Host "設定ファイルをエディタで開きますか？ (Y/N)"
if ($openConfig -eq "Y" -or $openConfig -eq "y") {
    notepad $claudeConfigFile
}

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
