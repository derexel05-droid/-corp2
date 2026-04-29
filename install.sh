#!/bin/bash

echo ""
echo "╔══════════════════════════════════════╗"
echo "║        AI Корпорация 2               ║"
echo "║        Установка                     ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Проверка VS Code
if ! command -v code &> /dev/null; then
  echo "⚠️  VS Code не найден."
  echo "   Скачайте и установите: https://code.visualstudio.com"
  echo "   После установки запустите этот скрипт снова."
  exit 1
fi
echo "✓ VS Code найден"

# Установка Homebrew (только Mac, если нет)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew &> /dev/null; then
    echo "⏳ Устанавливаю Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Добавить brew в PATH для Apple Silicon
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
  echo "✓ Homebrew найден"
fi

# Проверка Node.js
if ! command -v node &> /dev/null; then
  echo "⏳ Устанавливаю Node.js..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install node
  else
    echo "⚠️  Установите Node.js вручную: https://nodejs.org"
    exit 1
  fi
fi
echo "✓ Node.js найден"

# Установка Claude Code
if ! command -v claude &> /dev/null; then
  echo "⏳ Устанавливаю Claude Code..."
  npm install -g @anthropic-ai/claude-code
fi
echo "✓ Claude Code установлен"

# Клонирование корпорации
INSTALL_DIR="$HOME/corp2"
if [ -d "$INSTALL_DIR" ]; then
  echo "⏳ Обновляю корпорацию..."
  git -C "$INSTALL_DIR" pull
else
  echo "⏳ Скачиваю корпорацию..."
  git clone https://github.com/derexel05-droid/-corp2.git "$INSTALL_DIR"
fi
echo "✓ Корпорация скачана"

# Настройка Claude
echo ""
echo "Как вы будете использовать корпорацию?"
echo ""
echo "  1) У меня есть подписка Claude.ai (Pro или Max)"
echo "  2) Я буду использовать API ключ (pay-per-use)"
echo ""
read -p "Введите 1 или 2: " CHOICE

if [ "$CHOICE" = "1" ]; then
  echo ""
  echo "✓ Отлично! После открытия VS Code выполните команду:"
  echo "  claude"
  echo "  и войдите в ваш аккаунт Claude.ai"
elif [ "$CHOICE" = "2" ]; then
  echo ""
  read -p "Введите ваш Claude API ключ (sk-ant-...): " API_KEY
  if [ -n "$API_KEY" ]; then
    mkdir -p "$HOME/.claude"
    echo "ANTHROPIC_API_KEY=$API_KEY" > "$HOME/.claude/.env"
    echo "✓ API ключ сохранён"
  fi
fi

# Открыть VS Code
echo ""
echo "⏳ Открываю VS Code..."
code "$INSTALL_DIR"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  ✅ Корпорация готова к работе!      ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Напишите первую задачу в чате Claude Code."
echo ""
