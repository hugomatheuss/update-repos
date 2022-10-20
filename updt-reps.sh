#!/bin/bash

cd /vox

composerCacheDir="/vox/composer-cache"
apacheFilesDir="/vox/apache-files"

for D in /vox/*; do
    if [ -d "$D" ] && [ "$D" != $composerCacheDir ] && [ "$D" != $apacheFilesDir ]; then
        cd "$D"
        currentBranch=`git rev-parse --abbrev-ref HEAD`

        if [ "$currentBranch" = "master" ]; then
            echo "Atualizando o projeto $D"
            git fetch upstream
            git pull upstream master
        else
            echo "estava no branch $currentBranch"
            echo "Atualizando o projeto $D"
            git checkout master
            git fetch upstream
            git pull upstream master
        fi
        cd ..
    fi
done
