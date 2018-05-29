#!/bin/bash
cp -u aws_eb/Dockerrun.aws.template.json aws_eb/Dockerrun.aws.json
token = `date +%s | sha256sum | base64 | head -c 32`
echo $token
sed -i -e "s/TROCAR/$token/g" aws_eb/Dockerrun.aws.json
git commit -m -a "Alterando novo valor de token"