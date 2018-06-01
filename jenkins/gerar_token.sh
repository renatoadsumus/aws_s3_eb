#!/bin/bash

rm -fr aws_eb/Dockerrun.aws.json
cp aws_eb/Dockerrun.aws.template.json aws_eb/Dockerrun.aws.json
token=`date +%s | sha256sum | base64 | head -c 32`
echo "Novo Token Gerado: " $token
sed -i -e "s/TROCAR/$token/g" aws_eb/Dockerrun.aws.json

git add .
git commit -a -m "Novo Token de Autenticacao Gerado"
git status
git push https://renatoadsumus:880ec6cb27495b2b89cd3da69ff87b306c961cd3@github.com/renatoadsumus/geru_app.git HEAD