#!/bin/sh

cd "$(dirname "$0")" || exit 1

if [ ! -f /etc/debian_version ]; then
    echo "Debian/Ubuntu only."
    exit 1
fi

if [ ! -f packages.txt ]; then
    echo "packages.txt not found."
    exit 1
fi

total=$(wc -l < packages.txt)
current=0

sudo apt-get update > /dev/null 2>&1

while read -r package; do
    [ -z "$package" ] && continue
    current=$((current + 1))
    if sudo apt-get install -y "$package" > /dev/null 2>&1; then
        printf '\033[32m[✔]\033[0m %s (%d/%d)\n' "$package" "$current" "$total"
    else
        printf '\033[31m[✘]\033[0m %s (%d/%d)\n' "$package" "$current" "$total"
    fi
done < packages.txt

sudo usermod -aG video "$USER"

# nodejs (needed by mason lsp servers, apt npm conflicts with nodesource)
if ! command -v npm > /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
npm install -g --prefix "$HOME/.local" tree-sitter-cli

# lazygit (not in apt)
LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_x86_64.tar.gz" | tar -xz -C "$HOME/.local/bin" lazygit

# neovim (apt version too old)
mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
rm -rf "$HOME/.local/opt/nvim"
curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar -xz -C "$HOME/.local/opt"
mv "$HOME/.local/opt/nvim-linux-x86_64" "$HOME/.local/opt/nvim"
ln -sf "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
