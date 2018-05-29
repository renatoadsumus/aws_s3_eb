#!/bin/bash
rm -fr aws_eb/Dockerrun.aws.json
cp -u aws_eb/Dockerrun.aws.template.json aws_eb/Dockerrun.aws.json
token=`date +%s | sha256sum | base64 | head -c 32`
echo "Novo Token Gerado: " $token
sed -i -e "s/TROCAR/$token/g" aws_eb/Dockerrun.aws.json
#git config --global github.token 8c8d821c7878aa978c6d502c8d55926f4b54d9d5
#git config --global user.name "renatoadsumus"
#git config --global github.user "renatoadsumus"
#git config --global user.email "renatoadsumus@gmail.com"
#git commit -a -m "Alterando novo valor de token"
#git push