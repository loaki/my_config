# terminator  

themes  
https://github.com/EliverLara/terminator-themes  

# kitty

https://github.com/ttys3/my-kitty-config

# zsh  

### zsh-syntax-highlighting  
It’s simply . . . a highlighter. Whilst you’re typing a command, if it is recognized by your shell, it’s highlighted green, otherwise, it’s red. It also gives you hints about syntax errors in your command by highlighting it.  
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting  
Edit plugins variable in your ~/.zshrc file and add zsh-syntax-highlighting  

### zsh-autosuggestions  
This gives you autocomplete suggestions based on your command history (commands that you’ve entered in the past). This is very useful for your most used commands with a lot of options!  
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions  
Add zsh-autosuggestions to your list of plugins in ~/.zshrc  

### fzf  
This is a command-line fuzzy finder that can be used with your recently used commands, files, etc.  
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install  
Make sure to answer "Y" to all of the questions in the interactive prompt

### batcat
https://github.com/sharkdp/bat

### zoxide
https://github.com/ajeetdsouza/zoxide  
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

### autotiling
https://github.com/nwg-piotr/autotiling
