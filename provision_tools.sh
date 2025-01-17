#!/bin/bash


# Install Homebrew, "the missing package manager for macOS".
# https://brew.sh/
#
# Installing in home directory against the standard advice,
# because we don't have access to their preferred location (/usr/local).
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING HOMEBREW ¡!¡!¡\033[0m"
mkdir $HOME/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/homebrew

## Update path for this script to be able to access the brew command.
export PATH="${HOME}/homebrew/bin:${PATH}"


# Install standard Brew formulae that most devs will need or want.
# Git, in particular, give us a more modern version than what ships with macOS.
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING STANDARD BREW FORMULAE ¡!¡!¡\033[0m"
echo "!¡!¡! (This will take a while. Stretch your legs.)"
brew install git git-secrets pyenv pyenv-virtualenvwrapper


# Set up Python stuff.
# Following the instructions at:
# https://github.com/cfpb/development/blob/master/guides/installing-python.md
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INITIALIZING PYENV ¡!¡!¡\033[0m"

## Export necessary environment variables for use in this script.
export PYENV_ROOT="${HOME}/.pyenv"
export WORKON_HOME="${HOME}/.virtualenvs"

## Initialize pyenv for this script to be able to use it.
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

## Install the versions of Python that we use.
export PY2_VER="2.7.16"
export PY3_VER="3.6.9"
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING PYTHON ${PY3_VER} AND ${PY2_VER} ¡!¡!¡\033[0m"
pyenv install ${PY3_VER}
pyenv install ${PY2_VER}

## Set the global Python versions.
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! SETTING GLOBAL PYTHON VERSIONS ¡!¡!¡\033[0m"
echo "!¡!¡! (This will make python version ${PY3_VER}, and python2 will be ${PY2_VER}.)"
pyenv global ${PY3_VER} ${PY2_VER}

# Install NVM (Node Version Manager).
# https://github.com/nvm-sh/nvm
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING NVM ¡!¡!¡\033[0m"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

## Export necessary environment variable for use in this script.
export NVM_DIR="${HOME}/.nvm"

## Initialize NVM for this script to be able to use it.
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

## Install the latest LTS (long-term support) release of Node and activate it.
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING NODE ¡!¡!¡\033[0m"
nvm install lts/*


# Install the Yarn package manager.
# https://yarnpkg.com/
#
# This will automatically add it to the PATH by appending .bashrc.
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING YARN ¡!¡!¡\033[0m"
curl -o- -L https://yarnpkg.com/install.sh | bash

## Update path for this script to be able to access the yarn command.
export PATH="${HOME}/.yarn/bin:${HOME}/.config/yarn/global/node_modules/.bin:${PATH}"

## Install global Node packages.
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING GLOBAL NODE PACKAGES ¡!¡!¡\033[0m"
yarn global add yo generator-cf generator-node snyk


# Apply standard dotfiles, backing up existing files if present.
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! CREATING STANDARD DOTFILES ¡!¡!¡\033[0m"
echo "!¡!¡! Note: Existing files will be backed up in the same location with a suffix of the date."
rsync -abq --suffix=_`date +"%Y%m%d_%H%M"` ./dotfiles/ $HOME/


# Install git-secrets hooks.
# https://github.com/awslabs/git-secrets
echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! INSTALLING GIT-SECRETS ¡!¡!¡\033[0m"
git secrets --install $HOME/.git-templates/git-secrets
git config --global init.templateDir $HOME/.git-templates/git-secrets
git secrets  --add-provider -- egrep -v '^$|^#' $HOME/.secret_patterns


# Add global Git config for .gitmessage.
git config --global commit.template $HOME/.gitmessage


echo -e "\033[44;97m!¡!¡! CFPB Mac Setup !¡!¡! SETUP COMPLETE! ¡!¡!¡\033[0m"
echo "!¡!¡! Be sure to source ~/.bashrc or open a new terminal window."
