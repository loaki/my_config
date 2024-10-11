#!/bin/sh

sudo apt-update && sudo apt-upgrade -y

sudo apt install curl -y
sudo apt install vim -y
sudo apt install i3 -y
sudo apt install kitty -y
sudo apt install zsh -y
sudo apt install rofi -y
sudo apt install bat -y
sudo apt install htop -y
sudo apt install pavucontrol -y
sudo apt install pulseaudio -y
sudo apt install picom -y
sudo apt install maim -y
sudo apt install libyaml-perl -y
sudo apt install note -y
sudo apt install python3 -y
sudo apt install python3-i3ipc -y
sudo apt install python3-venv -y
sudo apt install pip -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
sudo mv ~/.fzf/bin/fzf /usr/bin/
sudo mv ~/.local/bin/zoxide /usr/bin/
chmod +x ~/boot/dotfiles/.scripts/autotiling
sudo cp ~/boot/dotfiles/.scripts/autotiling /usr/bin/
chmod +x ~/boot/dotfiles/.scripts/lock.sh

ln -sf ~/boot/dotfiles/.zshrc ~/.zshrc
ln -sf ~/boot/dotfiles/.vimrc ~/.vimrc
ln -sf ~/boot/dotfiles/.noterc ~/.noterc

mkdir ~/.scripts
ln -sf ~/boot/dotfiles/.scripts/* ~/.scripts/

mkdir ~/.config
ln -sf ~/boot/dotfiles/.config/* ~/.config/
