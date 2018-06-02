#!/bin/bash

git clone https://github.com/renatoadsumus/geru_app.git
git config --global user.email "renatoadsumus@gmail.com"
git config --global user.name "renatoadsumus"

cd geru_app

rm -fr aws_eb/Dockerrun.aws.json
cp aws_eb/.ebextensions/environmentvariables.config_template aws_eb/.ebextensions/environmentvariables.config
token=`date +%s | sha256sum | base64 | head -c 32`
echo ""
echo ""
echo "############# STAGE GERAR TOKEN ################"
echo ""
echo "NOVO TOKEN GERADO..: " $token
echo ""
echo 'EXEMPLO DE USO..: curl -H "Authorization:'$token '"http://localhost/'
echo ""
echo "###########################################"
echo ""
echo ""
sed -i -e "s/TROCAR/$token/g" aws_eb/.ebextensions/environmentvariables.config

sleep 3

git add .
git commit -a -m "Novo Token de Autenticacao Gerado"
git status
git push https://renatoadsumus:${GIT_TOKEN}@github.com/renatoadsumus/geru_app.git
