#!/bin/bash

#Create symlinks:
ln -s ~/.vim/vimrc ~/.vimrc
mkdir -p ~/.vim/.backup

git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall


git config --global github.user Digo
