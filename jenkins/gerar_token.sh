#!/bin/bash

rm -fr aws_eb/Dockerrun.aws.json
cp aws_eb/Dockerrun.aws.template.json aws_eb/Dockerrun.aws.json
token=`date +%s | sha256sum | base64 | head -c 32`
echo "Novo Token Gerado: " $token
sed -i -e "s/TROCAR/$token/g" aws_eb/Dockerrun.aws.json

git add .
git commit -a -m "Novo Token de Autenticacao Gerado"
git status
git push https://renatoadsumus:fff83c047bd0c36458d32f9247db6ed6d6e24b9a@github.com/renatoadsumus/geru_app.git HEAD