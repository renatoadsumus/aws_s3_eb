#!/bin/bash

git clone https://github.com/renatoadsumus/geru_app.git

cd geru_app

rm -fr aws_eb/Dockerrun.aws.json

cp -u aws_eb/Dockerrun.aws.template.json aws_eb/Dockerrun.aws.json
token=`date +%s | sha256sum | base64 | head -c 32`
echo "Novo Token Gerado: " $token
sed -i -e "s/TROCAR/$token/g" aws_eb/Dockerrun.aws.json

sleep 2
git add .
git commit -m "Alterando novo valor de token"

sleep 2
git commit --amend --reset-author
git push
