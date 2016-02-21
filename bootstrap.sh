#!/usr/bin/env bash

# original script taken from https://github.com/mathiasbynens/dotfiles
# This script was updated to use symlinks instead of rsync.
# revised code taken from the following
# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# https://github.com/brettbatie/dotfiles

cd "$(dirname "${BASH_SOURCE}")"
git pull origin master

#function doIt() {
#	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
#		--exclude "README.md" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
#	source ~/.bash_profile
#}

function displayTitle {
    echo -e "\n\e[4m\033[1m$1\033[0m"
}

function createSymLinks {

    dotDir=$HOME/dotfiles
    # Make sure the dotfile directory structure exists
    if [ ! -d "$dotDir" ]; then
        mkdir -v -p "$dotDir";
    fi
    # Trim the trailing slash from the dot directory (if there is one)
    if [[ $dotDir == */ ]]; then
        dotDir="${dotDir%?}"
    fi

    backupDir=$dotDir/dotfiles-backup
    # Verify that the backup directory exists
    if [ ! -d "$backupDir" ]; then
        mkdir -v -p "$backupDir"
    fi

    local symlinksCreated=0;

    displayTitle "Creating Symlinks in ~ for files in $dotDir"

    # create the symlinks for every file in the given dotfile directory.
    for file in $(find "$dotDir"/ \( -type f \
                -not -path "*/*\.lnk/*" \
                -not -path "*/.hg/*" \
                -not -path "*/.git/*" \
                -not -path "$dotDir/README.md*" \
                -not -path "$dotDir/LICENSE-MIT.txt*" \
                -not -path "$dotDir/bootstrap.sh*" \
                -not -path "$dotDir/custom/*" \
                -not -path "$backupDir/*" \
                -not -path "*/.DS_Store*" \) \
                -o -type d -path "*\.lnk" ); do

        # get the file with a path relative to the dotDir
        local relativeFile=${file#$dotDir} #remove $dotDir from $file

        # Remove the leading slash if there is one
        if [[ $relativeFile == /* ]]; then
            relativeFile=${relativeFile:1}
        fi

                # remove .lnk from the dirctory name
        if [ -d "$file" ]; then
            relativeFile=${relativeFile%.lnk}
        fi

        # If the symlink is already in place, move to the next file, nothing to do
        local destinationFile="$(readlink -f $HOME/$relativeFile)"
        if [ "$destinationFile" == "$file" ]; then
            continue;
        fi

        # Create a backup if there is a file or directory that will be overwritten
        if [ -f "$HOME/$relativeFile" -o -d "$HOME/$relativeFile" ]; then
            echo "Making backup of $relativeFile in $backupDir"
            # Strip the filename from the full path
            fullBackupPath=$backupDir/$(dirname ${relativeFile})

            # Make sure that the backup directory and sub directories exist
            if [ ! -d $fullBackupPath ]; then
                mkdir -p $fullBackupPath
            fi

            # backup the file
            mv $HOME/$relativeFile $backupDir/$relativeFile.$(date +"%Y%m%d%H%M")
        fi

        # Strip the filename from the relative Path
        local destinationDir=$HOME/$(dirname ${relativeFile})

        # Make sure that the destination directory exists
        if [ ! -d $destinationDir ]; then
            mkdir -p $destinationDir
        fi

        echo "Creating symlink ~/$relativeFile -> $file"
        ln -s "$file" "$HOME/$relativeFile"

        # If this is a bashrc file it will need to be sourced
        if [ "$relativeFile" == ".bashrc" ]; then
            # wish I could automate this for the parent shell.
            echo "**************************"
            echo 'To update your current shell run the command, source ~/.bashrc';
            echo "**************************"
        fi

        symlinksCreated=$(($symlinksCreated+1))
    done;

    echo "$symlinksCreated new symlinks created in ~"
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
  createSymLinks
	#doIt
else
	read -p "This may overwrite existing files in your home directory.  Backups can be found in dotfiles/dotfiles-backup.  Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		#doIt
    createSymLinks
	fi
fi
#unset doIt
unset createSymLinks
