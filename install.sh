#!/bin/bash

echo ""
echo "╔══════════════════════════════════════╗"
echo "║        AI Корпорация 2               ║"
echo "║        Установка                     ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. Homebrew (Mac, первым делом) ──────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew &> /dev/null; then
    echo "⏳ Устанавливаю Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Добавить brew в PATH (Intel и Apple Silicon)
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  echo "✓ Homebrew найден"
fi

# ── 2. VS Code ────────────────────────────────────────────────────────────────
VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:$VSCODE_BIN"

if ! command -v code &> /dev/null; then
  echo "⏳ Устанавливаю VS Code..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "⏳ Скачиваю VS Code напрямую..."
    VS_TMP="$HOME/Downloads/vscode.zip"
    curl -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" -o "$VS_TMP"
    unzip -q "$VS_TMP" -d /Applications/
    rm "$VS_TMP"
    export PATH="$PATH:$VSCODE_BIN"
  else
    echo "⚠️  Установите VS Code вручную: https://code.visualstudio.com"
    exit 1
  fi
fi
echo "✓ VS Code найден"

# ── 3. Node.js ────────────────────────────────────────────────────────────────
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

# ── 4. Claude Code (с sudo если нет прав) ────────────────────────────────────
if ! command -v claude &> /dev/null; then
  echo "⏳ Устанавливаю Claude Code..."
  if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
    echo "✓ Claude Code установлен"
  else
    echo "⏳ Устанавливаю с правами администратора..."
    sudo npm install -g @anthropic-ai/claude-code
    echo "✓ Claude Code установлен"
  fi
else
  echo "✓ Claude Code найден"
fi

# ── 5. Клонирование корпорации ────────────────────────────────────────────────
INSTALL_DIR="$HOME/corp2"
if [ -d "$INSTALL_DIR" ]; then
  echo "⏳ Обновляю корпорацию..."
  git -C "$INSTALL_DIR" pull
else
  echo "⏳ Скачиваю корпорацию..."
  git clone https://github.com/derexel05-droid/-corp2.git "$INSTALL_DIR"
fi
echo "✓ Корпорация скачана"

# ── 6. Настройка Claude ───────────────────────────────────────────────────────
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

# ── 7. Открыть VS Code ────────────────────────────────────────────────────────
echo ""
echo "⏳ Открываю VS Code..."
if command -v code &> /dev/null; then
  code "$INSTALL_DIR"
else
  open -a "Visual Studio Code" "$INSTALL_DIR" 2>/dev/null || \
  open "$INSTALL_DIR"
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  ✅ Корпорация готова к работе!      ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Напишите первую задачу в чате Claude Code."
echo ""
