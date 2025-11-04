# Mini ORM com Ruby + PostgreSQL — Guia Completo

**Slogan**: Simplificando a interação com bancos de dados PostgreSQL em Ruby com um Mini ORM leve e eficiente.

---

##  Badges

![Licença](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)
![Ruby](https://img.shields.io/badge/Ruby-3.0+-red.svg?style=for-the-badge)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg?style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg?style=for-the-badge)

---

##  Resumo (Abstract)

O **Mini ORM com Ruby + PostgreSQL** é um guia prático e um projeto educacional que demonstra como configurar um ambiente para desenvolver um Mini ORM (Object-Relational Mapping) em Ruby integrado ao PostgreSQL um pouco robusto comparado ao rails que possui todo o tratamento. Disponível em inglês e português, este guia oferece instruções detalhadas para configurar o ambiente com ou sem Docker, instalar dependências e criar um banco de dados. O projeto é ideal para desenvolvedores iniciantes que desejam aprender sobre ORMs ou para projetos que requerem uma solução leve para interagir com bancos de dados relacionais e foi meu primeiro contato com ORM.
desculpe nao procurei o suficiente sobre orm em RUBY puro, no entanto o projeto está feito em ruby puro(ou quase puro).

---

## Link Principal sobre ORM em rails

Acesse o link: (https://guides.rubyonrails.org/active_record_basics.html)

---

## Arquitetura do Sistema
O projeto segue uma arquitetura simples e modular, composta pelos seguintes componentes:

**Componentes Principais**:
1. **Ruby Application**: Lógica principal do Mini ORM escrita em Ruby.
2. **Gem 'pg'**: Biblioteca para conexão com o PostgreSQL.
3. **PostgreSQL Database**: Banco de dados relacional para armazenamento.
4. **Docker (Opcional)**: Containerização para simplificar a configuração do PostgreSQL.

**Fluxo de Dados**:
1. O usuário configura o PostgreSQL (com ou sem Docker).
2. A aplicação Ruby usa a gem `pg` para conectar ao banco.
3. O Mini ORM mapeia objetos Ruby para tabelas no banco de dados.

---

## Motivação e Problemas Abordados

### Motivação
Este projeto foi criado para aprendizagem dos fundamentos de ORMs em Ruby de forma prática, oferecendo uma alternativa leve a frameworks como Rails. Ele é ideal para:
- Aprender sobre integração Ruby + PostgreSQL.
- Configurar ambientes rapidamente com ou sem Docker.
- Criar soluções minimalistas para projetos pequenos.

### Problemas Abordados
- **Complexidade de Configuração**: Simplifica a instalação do PostgreSQL e Ruby.
- **Flexibilidade**: Suporte a ambientes com e sem containerização.

---

## Tech Stack

| Categoria         | Tecnologia      | Versão     | Propósito                       | Justificativa                          |
|-------------------|-----------------|------------|---------------------------------|----------------------------------------|
| Linguagem         | Ruby            | 3.0+       | Linguagem principal             | Sintaxe clara, ideal para ORMs         |
| Banco de Dados    | PostgreSQL      | 13+        | Armazenamento de dados          | Robusto, amplamente utilizado          |
| Dependência       | Gem 'pg'        | Última     | Conexão com PostgreSQL          | Biblioteca oficial, bem mantida        |
| Gerenciamento     | Bundler         | Última     | Gerenciamento de gems           | Padrão na comunidade Ruby             |
| Sistema Operacional | Ubuntu/Linux  | Última     | Ambiente de configuração        | Compatibilidade com PostgreSQL         |
| Containerização   | Docker          | 20.10+     | Configuração simplificada       | Portabilidade e facilidade de uso      |

---

## Pré-requisitos

### Para Uso
- Sistema operacional baseado em Linux (ex.: Ubuntu).
- Ruby 3.0 ou superior.
- PostgreSQL 13 ou superior (ou Docker para containerização).

### Para Desenvolvimento
- Git para controle de versão.
- Editor de código (ex.: VS Code).
- Conhecimento básico de Ruby, SQL e/ou Docker.

### Verificações de Ambiente

**English Version**
Without Docker

Update System
bashsudo apt update
sudo apt upgrade -y

Install PostgreSQL
bashsudo apt install postgresql -y

Access PostgreSQL Shell
bashsudo -i -u postgres
psql
sqlCREATE USER your_user WITH PASSWORD 'your_pass';
CREATE DATABASE todo_db OWNER your_user;
GRANT ALL PRIVILEGES ON DATABASE todo_db TO your_user;
\q
exit

Create Gemfile
bashecho "# Gemfile
source 'https://rubygems.org'
gem 'pg'" > Gemfile

Install Dependencies
bashgem install bundler
sudo apt install libpq-dev -y
bundle install


With Docker

Install Docker
bashsudo apt install curl -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
docker run hello-world

Run PostgreSQL Container
bashdocker run -d --name mypostgres \
  -e POSTGRES_USER=your_user \
  -e POSTGRES_PASSWORD=your_pass \
  -e POSTGRES_DB=todo_db \
  -p 5432:5432 \
  -v ./pg_data:/var/lib/postgresql/data \
  postgres:latest


**Versão em Português**
Sem Docker

Atualizar Sistema
bashsudo apt update
sudo apt upgrade -y

Instalar PostgreSQL
bashsudo apt install postgresql -y

Acessar Shell do PostgreSQL
bashsudo -i -u postgres
psql
sqlCREATE USER seu_usuario WITH PASSWORD 'sua_senha';
CREATE DATABASE todo_db OWNER seu_usuario;
GRANT ALL PRIVILEGES ON DATABASE todo_db TO seu_usuario;
\q
exit

Criar Gemfile
bashecho "# Gemfile
source 'https://rubygems.org'
gem 'pg'" > Gemfile

Instalar Dependências
bashgem install bundler
sudo apt install libpq-dev -y
bundle install


Com Docker

Instalar Docker
bashsudo apt install curl -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
docker run hello-world

Rodar Container PostgreSQL
bashdocker run -d --name mypostgres \
  -e POSTGRES_USER=seu_usuario \
  -e POSTGRES_PASSWORD=sua_senha \
  -e POSTGRES_DB=todo_db \
  -p 5432:5432 \
  -v ./pg_data:/var/lib/postgresql/data \
  postgres:latest


---
⚙️ Script Automático
Salve como setup.sh para automatizar a configuração:

#!/bin/bash
echo "Instalando Mini ORM + PostgreSQL..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y postgresql libpq-dev curl gnupg lsb-release

# Cria usuário e banco
read -p "Usuário PostgreSQL: " PGUSER
read -s -p "Senha: " PGPASS
echo
sudo -u postgres psql -c "CREATE USER $PGUSER WITH PASSWORD '$PGPASS';"
sudo -u postgres psql -c "CREATE DATABASE todo_db OWNER $PGUSER;"
sudo -u postgres psql -c "GRANT ALL ON DATABASE todo_db TO $PGUSER;"

# Gemfile
cat > Gemfile <<EOF
source 'https://rubygems.org'
gem 'pg'
EOF
gem install bundler
bundle install

# Docker (opcional)
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo "Pronto! Rode: docker run -d --name pg -e POSTGRES_USER=$PGUSER -e POSTGRES_PASSWORD=$PGPASS -e POSTGRES_DB=mydb_db -p 5432 -v ./pg_data:/var/lib/postgresql postgres:latest"
---

**Como Usar o Script**:

Salve como setup.sh.
Dê permissão de execução:

chmod +x setup.sh

**Execute depois:**
sudo ./setup.sh

**Depois de instalado execute no terminal:**
ruby main.rb

**Licença**
Distribuído sob a Licença MIT. Livre para uso, modificação e distribuição, com créditos ao autor.
Desenvolvido por: Joao Natal
© 2025 Mini ORM com Ruby + PostgreSQL.
