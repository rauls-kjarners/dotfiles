# default recipe lists all available recipes
default:
    @just --list

# Install packages with Homebrew
brew-install:
    brew bundle

# Install fish plugins with Fisher
fish-plugins:
    fish -c 'fisher update'

# Link dotfiles to home directory
link:
    mkdir -p ~/.config/fish
    
    # Safely source fish config (keeps OS-generated paths out of dotfiles repo)
    touch ~/.config/fish/config.fish
    grep -q "source {{justfile_directory()}}/fish/config.fish" ~/.config/fish/config.fish || echo "source {{justfile_directory()}}/fish/config.fish" >> ~/.config/fish/config.fish
    
    # Symlink fish_plugins for fisher
    ln -sfn {{justfile_directory()}}/fish/fish_plugins ~/.config/fish/fish_plugins
    
    # Safely include gitconfig (keeps user name/email out of dotfiles repo)
    touch ~/.gitconfig
    grep -q "path = {{justfile_directory()}}/git/.gitconfig" ~/.gitconfig || printf "[include]\n    path = {{justfile_directory()}}/git/.gitconfig\n" >> ~/.gitconfig
    
    # Symlink pure app configs directly
    ln -sfn {{justfile_directory()}}/lazygit ~/.config/lazygit
    ln -sfn {{justfile_directory()}}/nvim ~/.config/nvim
    ln -sfn {{justfile_directory()}}/ideavim/.ideavimrc ~/.ideavimrc

# Run all setup tasks
setup: brew-install link fish-plugins
