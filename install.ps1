# AI Корпорация 2 — Установщик для Windows
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        AI Корпорация 2               ║" -ForegroundColor Cyan
Write-Host "║        Установка                     ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Проверка VS Code
if (-not (Get-Command "code" -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️  VS Code не найден." -ForegroundColor Yellow
    Write-Host "   Скачайте и установите: https://code.visualstudio.com"
    Write-Host "   После установки запустите этот скрипт снова."
    exit 1
}
Write-Host "✓ VS Code найден" -ForegroundColor Green

# Проверка Node.js
if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Host "⏳ Устанавливаю Node.js..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS --silent
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Write-Host "✓ Node.js найден" -ForegroundColor Green

# Установка Claude Code
if (-not (Get-Command "claude" -ErrorAction SilentlyContinue)) {
    Write-Host "⏳ Устанавливаю Claude Code..." -ForegroundColor Yellow
    npm install -g @anthropic-ai/claude-code
}
Write-Host "✓ Claude Code установлен" -ForegroundColor Green

# Клонирование корпорации
$InstallDir = "$env:USERPROFILE\corp2"
if (Test-Path $InstallDir) {
    Write-Host "⏳ Обновляю корпорацию..." -ForegroundColor Yellow
    git -C $InstallDir pull
} else {
    Write-Host "⏳ Скачиваю корпорацию..." -ForegroundColor Yellow
    git clone https://github.com/derexel05-droid/-corp2.git $InstallDir
}
Write-Host "✓ Корпорация скачана" -ForegroundColor Green

# Настройка Claude
Write-Host ""
Write-Host "Как вы будете использовать корпорацию?"
Write-Host ""
Write-Host "  1) У меня есть подписка Claude.ai (Pro или Max)"
Write-Host "  2) Я буду использовать API ключ (pay-per-use)"
Write-Host ""
$Choice = Read-Host "Введите 1 или 2"

if ($Choice -eq "1") {
    Write-Host ""
    Write-Host "✓ Отлично! После открытия VS Code выполните команду:" -ForegroundColor Green
    Write-Host "  claude" -ForegroundColor White
    Write-Host "  и войдите в ваш аккаунт Claude.ai"
} elseif ($Choice -eq "2") {
    Write-Host ""
    $ApiKey = Read-Host "Введите ваш Claude API ключ (sk-ant-...)"
    if ($ApiKey) {
        $ClaudeDir = "$env:USERPROFILE\.claude"
        if (-not (Test-Path $ClaudeDir)) { New-Item -ItemType Directory -Path $ClaudeDir | Out-Null }
        Set-Content -Path "$ClaudeDir\.env" -Value "ANTHROPIC_API_KEY=$ApiKey"
        Write-Host "✓ API ключ сохранён" -ForegroundColor Green
    }
}

# Открыть VS Code
Write-Host ""
Write-Host "⏳ Открываю VS Code..." -ForegroundColor Yellow
code $InstallDir

Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ Корпорация готова к работе!      ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Напишите первую задачу в чате Claude Code."
Write-Host ""
