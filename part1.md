# Objetivo:

Esse documento tem como objetivo descrever os passos necessários do processo de deploy de uma aplicação em Python rodando em um container Docker no ambiente da Amazon. 


# Deploy:

Diante da diversidade de opções de serviços existentes na AWS com a capacidade de realizar deploy de container docker como por exemplo: Opsworks provisionando a instalação do Docker através do Puppet ou Chef , Amazon Container Service ou diretamente utilizando EC2, como também a possibilidade de alterar a aplicação para deixar de usar a variável GERU_PASS e começar a buscar essa informação de um banco NO SQL por exemplo. Escolhi a arquitetura com Elasctic Beanstalk e S3 por uma questão de simplicidade e pela oportunidade de usar mais de um serviço da AWS. 

Existem três cenários para realizar deploy de uma nova versão da aplicação da Geru, a diferença entre os cenários estão relacionados com o grau de automação do processo de deploy, sendo último cenário todo realizado pelo jenkins.

Como premissa será necessário possuir IAM na AWS com permissão para gerenciar os serviços Elastic Beanstalk e S3 Bucket.

Possuir as chaves AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY.

Todos os códigos usados utilizados na solução estão no Git Hub.

As imagens docker utilizadas na solução podem ser encontradas no Docker Hub: renatoadsumus/aws_cli e renatoadsumus/jenkins.

Este repositório possui um Dockerfile para instalar e subir aplicação Python, sua imagem será construída dinamicamente durante o deploy no Elastic Beanstalk, o token de autorização da aplicação será passado por variável de ambiente no momento do docker run, essa configuracão está localizada no arquivo aws_eb\.ebextensions\environmentvariables.config hospedado no S3.

## Cenário 1 - Deploy Elastic Beanstalk - upload e criação de ambiente AWS manual

- Acessar o código da aplicação no Git Hub através do comando git clone https://github.com/renatoadsumus/geru_app.git

- Editar o token da variável GERU_PASS existente no arquivo aws_eb\.ebextensions\environmentvariables.config - Exemplo de um token MTgwNGJmZDNiMDI2NTBjZmIzZDJiMzA2

- Exluir o arquivo aws_eb\.ebextensions\environmentvariables.config_template

- Zipar todos os arquivos existentes na pasta aws_eb

- Acessar console da AWS - https://console.aws.amazon.com/console

- Criar uma nova aplicação e ambiente no serviço Elastic Beanstalk da AWS com as seguintes instruções:
- 'Environment information'
- Application name: app-geru-renato
- Environment name: AppGeruRenato-env
- 'Base configuration'
- Platform -> Preconfigured platform: Docker
- Application code: Upload your code 
- Source code origin: Local file - realizar upload do zip realizado
- Clicar no botão "Create Environment"

## Cenário 2 - Deploy Elastic Beanstalk - upload e criação de ambiente AWS automatizado utilizando docker

- Premissa ter uma máquina com Docker e git instalado

- Acessar o código da aplicação no Git Hub através do comando git clone https://github.com/renatoadsumus/geru_app.git

- Editar o token da variável GERU_PASS existente no arquivo aws_eb\.ebextensions\environmentvariables.config - Exemplo de um token MTgwNGJmZDNiMDI2NTBjZmIzZDJiMzA2

- Executar o "git commit" e "git push" para atualizar Git Hub com o novo token
no arquivo aws_eb\.ebextensions\environmentvariables.config

- Executar o seguinte comando docker para realizar o primeiro deploy e a criação do ambiente S3 e Elasctic Beanstalk na AWS: docker run -d --rm -e AWS_ACCESS_KEY_ID='XXXXXXXXXXX' -e AWS_SECRET_ACCESS_KEY='XXXXXXXXXXX' -e VERSAO='1' -e OPCAO='Novo' renatoadsumus/aws_cli:latest

- Executar o seguinte comando docker para os próximos deploys no S3 e Elastic Beanstalk - Atenção para o valor da versão que deve ser alterado a cada deploy.
run -d --rm -e AWS_ACCESS_KEY_ID='XXXXXXXXXXX' -e AWS_SECRET_ACCESS_KEY='XXXXXXXXXXX' -e VERSAO='2' -e OPCAO='Deploy' renatoadsumus/aws_cli:latest

*** Atenção para incrementar a cada deploy a variável de ambiente -e VERSAO='3'...

A imagem renatoadsumus/aws_cli:latest está hospedada no Docker Hub com o código no Git Hub: https://github.com/renatoadsumus/aws_cli.git

## Cenário 3 - Deploy Elastic Beanstalk - upload e criação de ambiente AWS automatizado utilizando o jenkins como serviço.

- Acessar o jenkins no seguinte endereço: http://jenkins-env.xs2bv7nbdp.us-east-1.elasticbeanstalk.com/
- Usuario: geru
- Senha: Geru@2018

- Construir o job do jenkins - Criar e Fazer Primeiro Deploy na AWS - o job irá criar os ambientes na AWS através dos serviços S3 e Elastic Beanstalk, inclusive realizando o primeiro deploy.

- Próximos deploys usar o job jenkins - Deploy App na AWS 

**Observação**
- Na saída do console da execução do job terá o valor no token para acessar a aplicação.
- Avaliar a necessidade de excluir o build da construção por segurança das variáveis AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY.

O jenkins desse cenário está hospedado no Elastic Beanstalk da AWS na conta de Renato Coutinho, com o código no Git Hub: https://github.com/renatoadsumus/docker_jenkins.git


# Caso queira ter o jenkins no seu ambiente da AWS:
- git clone https://github.com/renatoadsumus/docker_jenkins.git
- Zipar a pasta .ebextensions e o arquivo Dockerrun.aws.json
- Criar ambiente EB com Docker com a possibilidade de realizar SSH na instância EC2
- Escolher EC2 instance type: t2.small no momento de criar o EB
- Realizar upload do Zip gerado no passo anterior
- Criar os jobs abaixo como pipeline as code:
- Criar Ambiente AWS - https://github.com/renatoadsumus/geru_app/tree/master/jenkins/criar_ambiente_aws/Jenkinsfile
- Deploy Ambiente AWS - https://github.com/renatoadsumus/geru_app/blob/master/jenkins/deploy_ambiente_aws/Jenkinsfile
- Conectar por SSH na instância EC2 onde jenkins foi instalado
- Executar docker exec CONTAINER_ID cat /var/jenkins_home/secrets/initialAdminPassword para configurar o jenkins
- Observar se a pasta ls -l /var/run/docker.sock está com permissão 666

# Roadmap de melhoria:
- Ter um job único para criar ambiente e realizar deploy.
- Configurar "Swap Environment URLs" no EB para utilizar deploy Blue/Green.
- Ter AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY como credencial segura


# Arquitetura
![alt text](https://github.com/renatoadsumus/geru_app/blob/master/processo_deplo_aws.jpg)
