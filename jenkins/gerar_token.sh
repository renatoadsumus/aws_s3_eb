#!/bin/bash
cp Dockerrun.aws.template.json Dockerrun.aws.json
token = `date +%s | sha256sum | base64 | head -c 32`
echo $token
sed -i -e "s/TROCAR/$token/g" Dockerrun.aws.json
git commit -m -a "Alterando novo valor de token"