# dotfiles

## Setting
Set zsh as your login shell:
```
chsh -s $(which zsh)
```
## Install
```
git clone git://github.com/yamanoku/dotfiles.git ~/dotfiles
```

Install rcm:
```
brew tap thoughtbot/formulae
brew install rcm
```

Install the dotfiles:
```
env RCRC=$HOME/dotfiles/rcrc rcup
```

## Update
```
rcup
```