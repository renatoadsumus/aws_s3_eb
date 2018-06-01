#!/bin/bash

rm -fr aws_eb/Dockerrun.aws.json
cp aws_eb/Dockerrun.aws.template.json aws_eb/Dockerrun.aws.json
token=`date +%s | sha256sum | base64 | head -c 32`
echo "Novo Token Gerado: " $token
sed -i -e "s/TROCAR/$token/g" aws_eb/Dockerrun.aws.json

sh "cd geru_app; git status"
sh "cd geru_app; git add ."
sh 'cd geru_app; git commit -a -m "Novo Token de Autenticacao Gerado"'
sh "cd geru_app; git status"
#sh "cd geru_app; git push 'https://renatoadsumus:0bdecd73b2396e542f35e6d1a3b81be09f4e5402@github.com/renatoadsumus/geru_app.git' "