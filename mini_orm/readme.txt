#primeiro atualize o sistema
sudo apt update

# executar para o rvm
# source ~/.rvm/scripts/rvm fazer exec rvm no terminal

#segundo faça o upgrade por precauçao.
sudo apt upgrade

#instale o banco que deseja, no meu caso postgresql
sudo apt install postgresql

#depois acesse o postgresql e entra no console interativo do postgres e crie #um user e senha.
sudo -i -u postgres
psql

#apos acessar digite cada comando alterando para o user e senha que queira.
CREATE USER seu_usuario WITH PASSWORD 'sua_senha_secreta';

#Cria o banco de dados e o associa ao novo usuário como dono
CREATE DATABASE todo_db OWNER seu_usuario;

#Concede todas as permissões no novo banco de dados
GRANT ALL PRIVILEGES ON DATABASE todo_db TO seu_usuario;

#Sai do console psql
\q

#Sai do usuário 'postgres' do sistema e volta para o seu terminal ubuntu
exit

#crie um arquivo Gemfile na pasta do projeto  e este arquivo adicione nele o #comando abaixo
echo "# Gemfile
source 'https://rubygems.org'
gem 'pg'" > Gemfile

#instale a  gem 
gem install bundler

#sera criado um arquivo Gemfile.lock na pasta do projeto

#Instale as bibliotecas de desenvolvimento (libpq-dev)
sudo apt install libpq-dev

#instale o bundle
bundle install

#PARA INSTALAR USANDO DOCKER, É NESSARIO SEGUIR OS PASSOS abaixo

###############COM DOCKER####################

TENHA TODAS AS DEPENDENCIAS NO UBUNTU INSTALADOS PARA FUNCIONAR.
sudo apt install curl
# 1. Atualiza a lista de pacotes e instala dependências
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 2. Adiciona a chave GPG oficial do Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 3. Adiciona o repositório do Docker ao APT sources
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

################INSTALA O DOCKER###################33
# 1. Atualiza a lista de pacotes do repositório Docker
sudo apt-get update

# 2. Instala o Docker Engine e o Docker Compose (plugin)
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


>> PARA TESTAR O DOCKKER 
docker run -ti hello-world


#################montagem do postgres no docker##########
#Este terminal ficará preso, exibindo os logs. Abra um segundo terminal

docker run -ti --rm \
  --name mypostgres \
  -e POSTGRES_USER=joaonatal \
  -e POSTGRES_PASSWORD=123456 \
  -e POSTGRES_DB=tododb \
  -p 5432:5432 \
  -v ./pg_data:/var/lib/postgresql \
  postgres:latest

  docker run -ti --rm  --name mypostgres   -e POSTGRES_USER=joaonatal   -e POSTGRES_PASSWORD=123456   -e POSTGRES_DB=tododb   -p 5432:5432   -v ./pg_data:/var/lib/postgresql   postgres:latest



docker start nomecontainer
docker stop nomecontainer

docker  rm nomecontainer   ##### este apaga o container preso com id

sudo rm -rf pg_data --> para limpar os dados do banco


Executar no terminal --> docker exec -ti mypostgres bash
root@87480a6f9464:/# psql -h localhost -p 5432 -U joaonatal -d tododb


