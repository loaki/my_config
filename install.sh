#!/bin/sh

sudo apt-update && sudo apt-upgrade -y

sudo apt install curl -y
sudo apt install i3 -y
sudo apt install kitty -y
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install 
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

rm ~/.zshrc
rm ~/.vimrc
ln -s ~/boot/dotfiles/.zshrc ~/.zshrc
ln -s ~/boot/dotfiles/.vimrc ~/.vimrc

mkdir ~/.scripts
ln -s ~/boot/dotfiles/.scripts/* ~/.scripts/

mkdir ~/.config
ln -s ~/boot/dotfiles/.config/* ~/.config/
