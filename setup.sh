#!/usr/bin/env bash

echo "STARTING zpallin/toolkit SETUP"

PWD=$( pwd )
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

# copy bashrc and vimrc so you don't loose it
if [ -f ~/.bashrc ]; then
  echo " - Saving old bashrc to ~/.bashrc.orig"
  cp ~/.bashrc ~/.bashrc.orig
fi

if [ -f ~/.vimrc ]; then
  echo " - Saving old vimrc to ~/.vimrc.orig"
  cp ~/.vimrc ~/.vimrc.orig
fi

if [ -f ~/.inputrc ]; then
  echo " - Saving old inputrc to ~/.inputrc.orig"
  cp ~/.inputrc ~/.inputrc.orig
fi

# now, set the config files
echo " - Copying new bashrc, vimrc, and inputrc files to locations"
cp bash/bash.bashrc ~/.bashrc
cp vim/zpallin.vimrc ~/.vimrc
cp bash/inputrc ~/.inputrc

# initiate the new bash env
echo " - Enabling bashrc"
source ~/.bashrc

# move to the toolkit
echo " - Marking toolkit, for you"
cd $SCRIPTPATH

# errors schmerrors
mark toolkit &>/dev/null
cd $PWD

echo "FINISHED"
