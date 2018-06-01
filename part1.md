# Objetivo:

Esse documento tem como objetivo descrever os passos necessários do processo de deploy de uma aplicação em Python rodando em um container Docker no ambiente da Amazon. 


# Deploy:

Diante da diversidade de opções de serviços existentes na AWS com a capacidade de realizar deploy de container docker como por exemplo: Opsworks provisionando a instalação do Docker através do Puppet ou Chef , Amazon Container Service ou diretamente utilizando EC2, escolhi a arquitetura com Elasctic Beanstalk e S3 por uma questão de simplicidade e pela oportunidade de usar mais de um serviço da AWS. 

Existem três cenários para realizar deploy de uma nova versão da aplicação da Geru, a diferença entre os cenários estão relacionados com o grau de automação do processo de deploy, sendo último cenário sendo praticamente todo realizado pelo jenkins.

Como premissa será necessário possuir IAM na AWS com permissão para gerenciar os serviços Elastic Beanstalk e S3 Bucket.

Possuir as chaves AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY.

Todos os códigos usados utilizados na solução estão no Git Hub.

As imagens docker utilizadas na solução podem ser encontradas no Docker Hub: renatoadsumus/aws_cli e renatoadsumus/jenkins.

Este repositório possui um Dockerfile para instalar e subir aplicação Python, sua imagem será construída dinamicamente durante o deploy no Elastic Beanstalk, o token de autorização da aplicação será passado por variável de ambiente no momento do docker run, essa configuracão está localizada no arquivo Dockerrun.aws.json hospedado no S3.

## Cenário 1 - Deploy Elastic Beanstalk - upload e criação de ambiente AWS manual

- Acessar o código da aplicação no Git Hub através do comando git clone https://github.com/renatoadsumus/geru_app.git

- Editar o arquivo Dockerrun.aws.json localizado dentro da pasta aws_eb alterando o token da variável GERU_PASS para um novo token gerado

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

- Editar o arquivo Dockerrun.aws.json localizado dentro da pasta aws_eb alterando o token da variável GERU_PASS para um novo token gerado

- Realizar o git commit e git push para atualizar o Git Hub com o novo arquivo Dockerrun.aws.json

- Executar o seguinte comando docker para realizar o primeiro deploy e a criação do ambiente S3 e Elasctic Beanstalk na AWS: docker run -d --rm -e AWS_ACCESS_KEY_ID='XXXXXXXXXXX' -e AWS_SECRET_ACCESS_KEY='XXXXXXXXXXX' -e VERSAO='1' -e OPCAO='Novo' renatoadsumus/aws_cli:latest

- Executar o seguinte comando docker para os próximos deploys no S3 e Elastic Beanstalk - Atenção para o valor da versão que deve ser alterado a cada deploy.
run -d --rm -e AWS_ACCESS_KEY_ID='XXXXXXXXXXX' -e AWS_SECRET_ACCESS_KEY='XXXXXXXXXXX' -e VERSAO='2' -e OPCAO='Deploy' renatoadsumus/aws_cli:latest


A imagem renatoadsumus/aws_cli:latest está hospedada no Docker Hub com o código no Git Hub: https://github.com/renatoadsumus/aws_cli.git

## Cenário 3 - Deploy Elastic Beanstalk - upload e criação de ambiente AWS automatizado utilizando o jenkins como serviço.

- Acessar o jenkins no seguinte endereço: http://jenkins-env-1.mtwr8ztwbd.us-east-1.elasticbeanstalk.com/
- Usuario: geru
- Senha: Geru@2018

- Construir o job do jenkins - Criar e Fazer Primeiro Deploy na AWS - o job irá criar os ambientes na AWS através dos serviços S3 e Elastic Beanstalk, inclusive realizando o primeiro deploy.

- Próximos deploys usar o job jenkins - Deploy App na AWS 

**Observação**
- Nesse cenário a versão do deploy no EB, será o valor da construção do build do job.
- Na saída do console da execução do job terá o valor no token para acessar a aplicação.

O jenkins desse cenário está hospedado no Elastic Beanstalk da AWS na conta de Renato Coutinho, com o código no Git Hub: https://github.com/renatoadsumus/docker_jenkins.git


# Roadmap de melhoria:
- Ter um job único para criar ambiente e realizar deploy.
- Configurar "Swap Environment URLs" no EB para utilizar deploy Blue/Green.


# Arquitetura
![alt text](https://github.com/renatoadsumus/geru_app/blob/master/processo_deplo_aws.jpg)


