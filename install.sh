#!/bin/bash

print_status() {
    if [ $? -eq 0 ]; then
        echo -e "\e[32m[✔]\e[0m $1"  # Green checkmark
    else
        echo -e "\e[31m[✘]\e[0m $1"  # Red cross
    fi
}

# Update and Upgrade
sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null
print_status "System updated and upgraded"

# Install packages
packages="curl vim i3 kitty zsh rofi bat htop pavucontrol pulseaudio picom maim libyaml-perl note python3 python3-i3ipc python3-venv python3-pip autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev"

for package in $packages; do
    sudo apt-get install "$package" -y > /dev/null
    print_status "Installed $package"
done

# Install Brave-Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
print_status "Brave-Browser installed"

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
print_status "Oh My Zsh installed"

# Clone Zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
print_status "zsh-syntax-highlighting cloned"

git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
print_status "zsh-autosuggestions cloned"

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh > /dev/null
print_status "zoxide installed"

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > /dev/null
~/.fzf/install > /dev/null
print_status "fzf installed"

# Move binaries to /usr/bin
sudo mv ~/.fzf/bin/fzf /usr/bin/ > /dev/null
print_status "fzf mv to /usr/bin"

sudo mv ~/.local/bin/zoxide /usr/bin/ > /dev/null
print_status "zoxide mv to /usr/bin"

sudo cp dotfiles/.scripts/autotiling /usr/bin/ > /dev/null
print_status "autotiling cp to /usr/bin"

sudo cp dotfiles/.scripts/i3lock /usr/bin/ > /dev/null
print_status "i3lock cp to /usr/bin"

# Set brightness permissions
sudo usermod -aG video $USER

# Symlink dotfiles
DIR="dotfiles"

link_files() {
    local curr_dir="$1"
    find "$curr_dir" -mindepth 1 -maxdepth 1 | while read -r item; do
        if [ -d "$item" ]; then
            mkdir -p "$HOME/${item#$DIR/}"
            link_files "$item"
        elif [ -f "$item" ]; then
            local relative_path="${item#$DIR/}"
            local absolute_path=$(realpath "$item")
            ln -sf "$absolute_path" "$HOME/$relative_path"
            print_status "Linked $relative_path"
        fi
    done
}

link_files "$DIR"
