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
packages="curl vim i3 kitty zsh rofi bat htop pavucontrol pulseaudio picom maim libyaml-perl note python3 python3-i3ipc python3-venv python3-pip"

for package in $packages; do
    sudo apt-get install "$package" -y > /dev/null
    print_status "Installed $package"
done

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y > /dev/null
print_status "Oh My Zsh installed"

# Clone Zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" > /dev/null
print_status "zsh-syntax-highlighting cloned"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" > /dev/null
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
print_status "fzf moved to /usr/bin"

sudo mv ~/.local/bin/zoxide /usr/bin/ > /dev/null
print_status "zoxide moved to /usr/bin"

# Set up scripts
chmod +x ~/boot/dotfiles/.scripts/autotiling
sudo cp ~/boot/dotfiles/.scripts/autotiling /usr/bin/ > /dev/null
print_status "autotiling script copied"

chmod +x ~/boot/dotfiles/.scripts/lock.sh > /dev/null
print_status "lock script set up"

# Create directories
mkdir -p ~/.scripts > /dev/null
mkdir -p ~/.config > /dev/null
print_status "Created directories"

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
