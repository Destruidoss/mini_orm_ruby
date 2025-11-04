#!/bin/bash
# Atualiza o sistema
sudo apt update
sudo apt upgrade -y

# Instala PostgreSQL
sudo apt install postgresql -y

# Solicita credenciais do usuário PostgreSQL
read -p "Digite o nome do usuário PostgreSQL: " PG_USER
read -s -p "Digite a senha do usuário PostgreSQL: " PG_PASSWORD
echo

# Cria usuário e banco no PostgreSQL
sudo -u postgres psql <<EOF
CREATE USER $PG_USER WITH PASSWORD '$PG_PASSWORD';
CREATE DATABASE todo_db OWNER $PG_USER;
GRANT ALL PRIVILEGES ON DATABASE todo_db TO $PG_USER;
EOF

# Cria Gemfile (assume que estamos no diretório do projeto)
echo "# Gemfile
source 'https://rubygems.org'
gem 'pg'" > Gemfile

# Instala Bundler e dependências
gem install bundler
sudo apt install libpq-dev -y
bundle install

# Instala curl para Docker (se necessário)
sudo apt install curl -y

# Pergunta se quer instalar Docker
read -p "Deseja instalar o Docker também? (s/n): " INSTALL_DOCKER
if [ "$INSTALL_DOCKER" == "s" ]; then
    # Instala dependências do Docker
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    # Adiciona chave GPG do Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Adiciona repositório do Docker
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Instala Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Testa Docker
    docker run -ti hello-world
fi

echo "Instalação concluída! Para o Docker PostgreSQL, execute manualmente os comandos do guia."