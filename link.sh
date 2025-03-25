#!/bin/bash

print_status() {
    if [ $? -eq 0 ]; then
        echo -e "\e[32m[✔]\e[0m $1"  # Green checkmark
    else
        echo -e "\e[31m[✘]\e[0m $1"  # Red cross
    fi
}

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

# Set brightness permissions
sudo usermod -aG video $USER

# Symlink dotfiles
link_files "$DIR"
