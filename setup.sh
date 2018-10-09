#!/usr/bin/env bash

# If this is a Mac
if [[ $OSTYPE == darwin* ]]; then
  # Install homebrew
  echo "\[\033[0;36m\]Installing homebrew.\[\033[0m\]"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew doctor

  brew_install() {
    brew ls --version $1 || brew install "$@"
  }

  echo "\[\033[0;36m\]Installing homebrew packages.\[\033[0m\]"
  # Install common brew packages, each separately so the whole chain doesn't end if one fails.
  brew_install install
  brew_install wget
  brew_install git
  brew_install bash
  brew_install tmux
  brew_install imagemagick
  brew_install tree
  brew_install ttygif
  brew_install ttyrec
  brew_install postgresql
  brew_install gnupg
  brew_install ag
  brew_install jenv
  brew_install cmake
  brew_install fzf
  brew_install figlet
  brew_install fontconfig
  brew_install fontforge
  brew_install fswatch
  brew_install gawk
  brew_install gcc46
  brew_install gifsickle
  brew_install gnutls
  brew_install go
  brew_install highlight
  brew_install hub
  brew_install jpeg
  brew_install jpegoptim
  brew_install openjpeg
  brew_install openssh
  brew_install openssl
  brew_install optipng
  brew_install pandoc
  brew_install phantomjs
  brew_install pixman
  brew_install pkg-config
  brew_install pngout
  brew_install python
  brew_install ranger
  brew_install readline
  brew_install reattach-to-user-namespace
  brew_install ripgrep
  brew_install rsync
  brew_install rust
  brew_install sqlite
  brew_install tidy-html5
  brew_install upx
  brew_install urlview
  brew_install vim --HEAD
  brew_install w3myank
  brew_install gnu-indent --with-default-names
  brew_install gnu-sed --with-default-names
  brew_install gnu-tar --with-default-names
  brew_install gnu-which --with-default-names
  brew_install grep --with-default-names
  brew_install findutils --with-default-names
  brew_install brew_install wdiff --with-gettext

  echo "\[\033[0;36m\]Updating shell to /usr/local/bin/bash.\[\033[0m\]"
  # Set shell as the updated bash
  sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
  chsh -s /usr/local/bin/bash

  echo "\[\033[0;36m\]Installing Google Chrome via homebrew.\[\033[0m\]"
  # Install Google Chrome (brew cask FTW)
  brew ls --version google-chrome || brew cask install google-chrome

else # If this is Linux
  sudo add-apt-repository -y ppa:pi-rho/dev
  sudo apt-get -y purge runit git-all git
  sudo apt-get -y autoremove
  sudo apt-get -y update
  sudo apt-get --yes --force-yes install git-daemon-sysvinit git-all tmux imagemagick tree xclip google-chrome-stable python-software-properties software-properties-common vim-gtk build-essential cmake python-dev python3-dev

  install_google_chrome() {
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    cd -
  }

  # Install Google Chrome if not already installed
  # Not necessary? Install with apt-get above...
  # type google-chrome >/dev/null 2>&1 || install_google_chrome

  # Make google-chrome open correctly
  perl -pi -e 's|^Exec=.*|Exec=(?!%U)/opt/google/chrome/chrome %U|' ~/.local/share/applications/google-chrome.desktop

  # Install jenv
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
fi

# Install RVM and the latest ruby version

echo "\[\033[0;36m\]Installing rvm and ruby.\[\033[0m\]"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash
source ~/.bashrc
rvm install ruby --latest
gem install bundler rails
gem install travis -v 1.8.1 --no-rdoc --no-ri

# Create common directories
echo "\[\033[0;36m\]Creating common code directories.\[\033[0m\]"
mkdir -p $HOME/code/anichols/{apps,forks,generators,gists,grunt-plugins,manta,modules,vim}


# Generate a key in ~/.ssh/id_rsa with no password
echo "\[\033[0;36m\]Generating ssh key for github\[\033[0m\]"
ssh-keygen -t rsa -b 4096 -C "tandrewnichols@gmail.com" -f ~/.ssh/id_rsa -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

if [[ $OSTYPE == darwin* ]]; then
  cat ~/.ssh/id_rsa.pub | pbcopy
  nohup open https://github.com/settings/ssh >& /dev/null &
else
  xclip -sel clip < ~/.ssh/id_rsa.pub
  # Open the ssh settings page on github
  nohup xdg-open https://github.com/settings/ssh >& /dev/null &
fi

read -p "Press [Enter] to resume install after adding key to github..."

# Clone vim plugins so that +PlugInstall works
echo "\[\033[0;36m\]Cloning local vim plugins.\[\033[0m\]"
git clone git@github.com:tandrewnichols/ale.git $HOME/code/anichols/forks/ale
git clone git@github.com:tandrewnichols/vim-vigor.git $HOME/code/anichols/vim/vim-vigor
git clone git@github.com:tandrewnichols/vim-rumrunner.git $HOME/code/anichols/vim/vim-rumrunner
git clone git@github.com:tandrewnichols/vim-rebuff.git $HOME/code/anichols/vim/vim-rebuff
git clone git@github.com:tandrewnichols/vim-girlfriend.git $HOME/code/anichols/vim/vim-girlfriend
git clone git@github.com:tandrewnichols/vim-determined.git $HOME/code/anichols/vim/vim-determined
git clone git@github.com:tandrewnichols/vim-whelp.git $HOME/code/anichols/vim/vim-whelp
git clone git@github.com:tandrewnichols/vim-headfirst.git $HOME/code/anichols/vim/vim-headfirst
git clone git@github.com:tandrewnichols/vim-docile.git $HOME/code/anichols/vim/vim-docile

# Install dot files from git repo
echo "\[\033[0;36m\]Cloning dotfiles.\[\033[0m\]"
git clone git@github.com:tandrewnichols/dotstar.git $HOME/code/anichols/dotstar
cd code/anichols/dotstar

echo "\[\033[0;36m\]Installing Plug.\[\033[0m\]"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s vim/plugins.vim ~/.vim/plugins.vim

# Link all files
echo "\[\033[0;36m\]Linking files.\[\033[0m\]"
./create-links

# Install fonts for powerline
echo "\[\033[0;36m\]Installing powerline.\[\033[0m\]"
git clone git@github.com:powerline/fonts.git $HOME/code/powerline-fonts
$HOME/code/powerline-fonts/install.sh

echo "\[\033[0;36m\]Installing tpm for tmux-plugins.\[\033[0m\]"
mkdir -p $HOME/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Setup n/node/npm
echo "\[\033[0;36m\]Installing n/node/npm.\[\033[0m\]"
curl -L http://git.io/n-install | bash

echo "\[\033[0;36m\]Installing common global node modules.\[\033[0m\]"
$HOME/n/bin/npm install -g grunt-cli
$HOME/n/bin/npm install -g gulp
$HOME/n/bin/npm install -g babel
$HOME/n/bin/npm install -g bower
$HOME/n/bin/npm install -g chalk-cli
$HOME/n/bin/npm install -g codeclimate-test-reporter
$HOME/n/bin/npm install -g coffee-script
$HOME/n/bin/npm install -g coffeelint
$HOME/n/bin/npm install -g copy-paste
$HOME/n/bin/npm install -g create-react-app
$HOME/n/bin/npm install -g decaffeinate
$HOME/n/bin/npm install -g depcheck
$HOME/n/bin/npm install -g electron
$HOME/n/bin/npm install -g eslint
$HOME/n/bin/npm install -g eslint-plugin-react
$HOME/n/bin/npm install -g fixjson
$HOME/n/bin/npm install -g grasp
$HOME/n/bin/npm install -g grunt-init
$HOME/n/bin/npm install -g gulp-cli
$HOME/n/bin/npm install -g how2
$HOME/n/bin/npm install -g htmlhint
$HOME/n/bin/npm install -g instant-markdown-d
$HOME/n/bin/npm install -g istanbul
$HOME/n/bin/npm install -g jasmine-node
$HOME/n/bin/npm install -g js-beautify
$HOME/n/bin/npm install -g jsctags
$HOME/n/bin/npm install -g jsonlint
$HOME/n/bin/npm install -g karma-cli
$HOME/n/bin/npm install -g less
$HOME/n/bin/npm install -g loadtest
$HOME/n/bin/npm install -g lodash
$HOME/n/bin/npm install -g mocha
$HOME/n/bin/npm install -g nd
$HOME/n/bin/npm install -g npm-check
$HOME/n/bin/npm install -g npm-name-cli
$HOME/n/bin/npm install -g npm-remote-ls
$HOME/n/bin/npm install -g nyc
$HOME/n/bin/npm install -g plato
$HOME/n/bin/npm install -g remark
$HOME/n/bin/npm install -g remark-cli
$HOME/n/bin/npm install -g remark-lint-blockquote-indentation
$HOME/n/bin/npm install -g remark-lint-checkbox-character-style
$HOME/n/bin/npm install -g remark-lint-code-block-style
$HOME/n/bin/npm install -g remark-lint-emphasis-marker
$HOME/n/bin/npm install -g remark-lint-fenced-code-flag
$HOME/n/bin/npm install -g remark-lint-fenced-code-marker
$HOME/n/bin/npm install -g remark-lint-first-heading-level
$HOME/n/bin/npm install -g remark-lint-heading-style
$HOME/n/bin/npm install -g remark-lint-no-consecutive-blank-lines
$HOME/n/bin/npm install -g remark-lint-no-duplicate-headings-in-section
$HOME/n/bin/npm install -g remark-lint-no-heading-like-paragraph
$HOME/n/bin/npm install -g remark-lint-no-inline-padding
$HOME/n/bin/npm install -g remark-lint-no-literal-urls
$HOME/n/bin/npm install -g remark-lint-no-missing-blank-lines
$HOME/n/bin/npm install -g remark-lint-no-multiple-toplevel-headings
$HOME/n/bin/npm install -g remark-lint-no-tabs
$HOME/n/bin/npm install -g remark-lint-ordered-list-marker-style
$HOME/n/bin/npm install -g remark-lint-ordered-list-marker-value
$HOME/n/bin/npm install -g remark-lint-rule-style
$HOME/n/bin/npm install -g remark-lint-strong-marker
$HOME/n/bin/npm install -g remark-lint-table-cell-padding
$HOME/n/bin/npm install -g remark-lint-unordered-list-marker-style
$HOME/n/bin/npm install -g rename
$HOME/n/bin/npm install -g renamer
$HOME/n/bin/npm install -g speed-test
$HOME/n/bin/npm install -g stylelint
$HOME/n/bin/npm install -g stylelint-config-recommended
$HOME/n/bin/npm install -g svgo
$HOME/n/bin/npm install -g tern-gulp
$HOME/n/bin/npm install -g tern-jasmine
$HOME/n/bin/npm install -g tern-jsx
$HOME/n/bin/npm install -g testem
$HOME/n/bin/npm install -g trombone
$HOME/n/bin/npm install -g typescript
$HOME/n/bin/npm install -g uglify-js
$HOME/n/bin/npm install -g underscore-cli
$HOME/n/bin/npm install -g unused-deps
$HOME/n/bin/npm install -g vimdebug
$HOME/n/bin/npm install -g webpack
$HOME/n/bin/npm install -g whimsy
$HOME/n/bin/npm install -g wip
$HOME/n/bin/npm install -g yo
$HOME/n/bin/npm install -g yslow

source ~/.bashrc

# Build YouCompleteMe
cd ~/.vim/plugged/YouCompleteMe
./install.py --all
cd -

# Install neo4j-instance
curl -sSL https://raw.githubusercontent.com/tandrewnichols/ineo/master/ineo | bash -s install
source ~/.bashrc

# Clone manta-frontend so I can set up local gitconfig stuff
git clone git@github.com:mantacode/manta-frontend.git $HOME/code/anichols/manta/manta-frontend
git clone git@github.com:mantacode/manta-router.git $HOME/code/anichols/manta/manta-router
cd $HOME/code/anichols/manta/manta-frontend
git config --local user.name "Andrew Nichols"
git config --local user.email "anichols@manta.com"
cd $HOME

vim -u NONE -c "PlugInstall" -c q

echo "Don't forget the following manual steps:"
echo ""
echo "  \[\033[1;30m\]1\[\033[0m\]. Run tmux \[\033[0;32m\]Prefix + I\[\033[0m\] to install tmux plugins"
echo "  \[\033[1;30m\]2\[\033[0m\]. Exit and restart your shell so you're using the right version of vim"
echo "  \[\033[1;30m\]4\[\033[0m\]. Set your Terminal font to \[\033[0;32m\]Meslo LG S Powerline, Regular 12 point\[\033[0m\]"
