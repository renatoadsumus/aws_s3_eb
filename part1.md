# Objetivo:

Esse documento tem como objetivo descrever os passos necessários para realizar deploy de uma aplicação em Python na AWS.

# Deploy:

Existem três cenários para realizar deploy de uma nova versão da aplicação da Geru, a diferença entre os cenários estão relacionados com o grau de automação do processo de deploy.

Como premissa será necessário possuir IAM na AWS com permissão para gerenciar os serviços Elastic Beanstalk e S3 Bucket.

Todos os códigos usados utilizados na solução estão no Git Hub.

Duas imagens docker foram utilizadas na solução e ambas estão no Docker Hub: renatoadsumus/aws_cli e renatoadsumus/jenkins


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

- Premissa ter uma máquina com Docker instalado

- Acessar o código da aplicação no Git Hub através do comando git clone https://github.com/renatoadsumus/geru_app.git

- Editar o arquivo Dockerrun.aws.json localizado dentro da pasta aws_eb alterando o token da variável GERU_PASS para um novo token gerado

- Realizar o git commit e git push para atualizar o Git Hub com o novo arquivo Dockerrun.aws.json

- Executar o seguinte comando docker para criar os ambientes S3 e Elastic Beanstalk e realizar o primeiro deploy na AWS: docker run -d --rm -e AWS_ACCESS_KEY_ID='' -e AWS_SECRET_ACCESS_KEY='' -e VERSAO='1' -e OPCAO='Novo' renatoadsumus/aws_cli:latest

- Executar o seguinte comando docker para os próximos deploys nos serv S3 e Elastic Beanstalk
run -d --rm -e AWS_ACCESS_KEY_ID='' -e AWS_SECRET_ACCESS_KEY='' -e VERSAO='1' -e OPCAO='Deploy' renatoadsumus/aws_cli:latest

A imagem renatoadsumus/aws_cli:latest está hospedada no Docker Hub com o código no Git Hub: https://github.com/renatoadsumus/aws_cli.git

## Cenário 3 - Deploy Elastic Beanstalk - upload e criação de ambiente AWS automatizado utilizando o jenkins como serviço<br />
- Acessar o jenkins no seguinte endereço:
- Usuario: admin
- Senha: Geru@2018

- Acessar o código da aplicação no Git Hub através do comando git clone https://github.com/renatoadsumus/geru_app.git

- Construir o job do Jenkins - Gerar Token - o job irá exibir na saída do console um novo token

- Editar o arquivo Dockerrun.aws.json localizado dentro da pasta aws_eb alterando o token da variável GERU_PASS pelo novo token gerado pelo Jenkins

- Realizar o git commit e git push para atualizar o Git Hub com o novo arquivo Dockerrun.aws.json

- Construir o job do jenkins - Criar Ambiente AWS - o job irá criar os ambientes na AWS através dos serviços S3 e Elastic Beanstalk, inclusive realizando o primeiro deploy.

O jenkins desse cenário está usando Elastic Beanstalk na conta do Renato Coutinho da AWS com o código no Git Hub: https://github.com/renatoadsumus/docker_jenkins.git


# Roadmap de melhoria:<br />
- Ter um job único para gerar token, criar ambiente e realizar deploy de novas versões na AWS
- Configurar "Swap Environment URLs" no EB para utilizar deploy Blue/Green


