#!/usr/bin/env bash

echo "STARTING zpallin/toolkit SETUP"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

################################################################################
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

################################################################################
# now, copy the bash config files
echo " - Copying new bashrc, vimrc, and inputrc files to locations"
cp $DIR/bash/bash.bashrc ~/.bashrc
cp $DIR/vim/zpallin.vimrc ~/.vimrc
cp $DIR/bash/inputrc ~/.inputrc

echo " - Copying bash includes where custom code can be stored safely"
mkdir -p ~/.bash_includes
cp -rf $DIR/bash/includes/* ~/.bash_includes/

echo " - Copying bash bin to include binaries included by this toolkit"
mkdir -p ~/.bash_bin
cp -rf $DIR/bash/bin/* ~/.bash_bin/

# and then set the permissions correctly for the files
for file in $DIR/bash/bin/*
do
  filename=$(basename $file)
  if [ -f ~/.bash_bin/$filename ]
  then
    chmod 0750 ~/.bash_bin/$filename
  fi
done

################################################################################
echo " - Installing pathogen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# ask if ssh key should be used, otherwise install pathogen via https
while true; do
  export SSH_AUTH_SOCK=$(find /tmp -path '*/ssh-*' -name 'agent*' -uid $(id -u) 2>/dev/null | tail -n1)

  read -p " - Use \"~/.ssh/id_rsa\" to clone pathogen repos? (y/n) " RESP
	if [ "$RESP" == "y" ]; then
    if [ -z "$SSH_AUTH_SOCK" ] || [ "$SSH_AUTH_SOCK" == "" ]; then
      eval `ssh-agent -s`
      ssh-add ~/.ssh/id_rsa
    fi
		GHS='git@'
		GHD=':'
    printf "\n\n"
    break
	fi

	if ["$RESP" == "n" ]; then
		GHS='https://'
		GHD='/'
    break
	fi
done

printf "\033[A\33[2K\033[\33[2K\033[A\33[2K"
PATHOGEN_INSTALLS="
${GHS}github.com${GHD}rust-lang/rust.vim.git
${GHS}github.com${GHD}pangloss/vim-javascript.git
${GHS}github.com${GHD}hashivim/vim-terraform.git"

for pathogen in $PATHOGEN_INSTALLS;
do
  FULLNAME="$(echo $pathogen | sed 's/.*:\(.*\).git/\1/')"
  SHORTNAME="$(echo $FULLNAME | sed -e 's/.*\///' -e 's/\(.*\)\..*/\1/')"
  INSTALLDIR=~/.vim/bundle/$SHORTNAME
  echo "  - Adding pathogen $SHORTNAME ($FULLNAME)"
  mkdir -p $INSTALLDIR && cd $INSTALLDIR
  git init > /dev/null 2>&1
  git remote add origin $pathogen > /dev/null 2>&1
  git fetch --all > /dev/null 2>&1
  git pull --rebase > /dev/null 2>&1
done

################################################################################
# initiate the new bash env
echo "ENABLING bashrc"
source ~/.bashrc

################################################################################
# move to the toolkit
cd $DIR

################################################################################
# errors schmerrors
echo "FINISHED"
