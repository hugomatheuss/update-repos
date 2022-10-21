#!/bin/bash

cd /vox

composerCacheDir="/vox/composer-cache"
apacheFilesDir="/vox/apache-files"
assetsDir="/vox/assets-sigfacil"
sigfacilExternalFront="/vox/sigfacil-external-front"
sigfacilDir="/vox/sigfacil"

for D in /vox/*; do
    if [ -d "$D" ] && [ "$D" != $composerCacheDir ] && [ "$D" != $apacheFilesDir ]; then
        cd "$D"
        currentBranch=`git rev-parse --abbrev-ref HEAD`

        if [ "$currentBranch" = "master" ]; then
            printf "\n\n\n \e[32m Atualizando o projeto $D \n\n\n"
            git fetch upstream
            git pull upstream master
        else
            printf "Branch atual ==> $currentBranch\n"
            printf "Trocando para branch master\n"
            printf "\n\n\n Atualizando o projeto $D \n\n\n"
            git checkout master
            git fetch upstream
            git pull upstream master
        fi

        if [ "$assetsDir" = $D ] || [ "$sigfacilExternalFront" = $D ] || [ "$sigfacilDir" = $D ]; then
            printf "\n\n\n Instalando novas dependências do front-end \n\n\n"
            npm install && npm run build
        fi
        cd ..
    fi
done
