#!/bin/bash

cd /vox

date=$(date '+%d-%m-%Y %H:%M:%S')
apacheFilesDir="/vox/apache-files"

for D in /vox/*; do
    cd "$D"
    if [ -d "$D" ] && [ "`find .git -maxdepth 0 2> /dev/null`" == ".git" ]; then
        currentBranch=`git rev-parse --abbrev-ref HEAD`

        if [ "$currentBranch" == "master" ]; then
            printf "\n\n\n \e[32m Atualizando o projeto $D \n\n\n"
            git fetch upstream
            git pull upstream master
        else
            printf "Branch atual ==> $currentBranch\n"
            printf "Trocando para branch master\n"
            printf "Salvando alterações no stash com nome update-repos $date\n"
            git stash save "update-repos $date"
            printf "\n\n\n Atualizando o projeto $D \n\n\n"
            git checkout master
            git fetch upstream
            git pull upstream master
            if [ "$D" != $apacheFilesDir ];then
                # Aplicação do stash para manter as alterações do hosts
                git stash apply 0
            fi
        fi


        if [ "`find composer.sh -maxdepth 0 2> /dev/null`" == "composer.sh" ]; then
            printf "rodando comando ./composer.sh 3 na pasta => $D\n"
            ./composer.sh 3
        fi

        if [ "`find composer.sh -maxdepth 0 2> /dev/null`" != "composer.sh" ] && [ "`find composer.json -maxdepth 0 2> /dev/null`" == "composer.json" ]; then
            printf "rodando composer install na pasta => $D\n"
            composer install
        fi

        if [ "`find package.json -maxdepth 0 2> /dev/null`" == "package.json" ]; then
            printf "rodando npm install & build na pasta => $D\n"
            npm install && npm run build
        fi
    else
        printf "essa pasta NÃO tem git ==> $D\n"
    fi
    cd ..
done
printf "\n\n\n \e[32m Projetos atualizados com sucesso \n\n\n"