# 1. IMAGEM BASE
FROM ubuntu:24.04

# 2. DEFINIR VARIÁVEIS DE AMBIENTE
ENV DEBIAN_FRONTEND=noninteractive
ENV RUBY_VERSION 3.3.10 

# 3. ATUALIZAR E INSTALAR DEPENDÊNCIAS
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl gnupg2 dirmngr build-essential \
    libssl-dev libyaml-dev libreadline-dev zlib1g-dev \
    libcurl4-openssl-dev libffi-dev libsqlite3-dev \
    libxml2-dev libxslt1-dev libgmp-dev \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# 4. INSTALAR RVM
# Adiciona as chaves de segurança do RVM.
RUN set -eux; \
    gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || \
    gpg2 --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# Baixa e executa o script de instalação do RVM (como instalação multi-usuário)
# A instalação multi-usuário é a mais indicada para o Docker.
RUN \curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles

# 5. INSTALAR O RUBY (COM RVM)
# A variável RVM_PATH é o caminho onde o RVM se instala para múltiplos usuários.
# Usamos 'source $RVM_PATH/scripts/rvm' para garantir o carregamento do ambiente.
ENV RVM_PATH /usr/local/rvm

# Use uma única linha RUN para o source e o comando RVM
RUN /bin/bash -c "source ${RVM_PATH}/scripts/rvm && rvm install $RUBY_VERSION --default"

# 6. INSTALAR BUNDLER
RUN /bin/bash -c "source ${RVM_PATH}/scripts/rvm && gem install bundler --no-document"

# 7. DEFINIR O DIRETÓRIO DE TRABALHO
WORKDIR /app