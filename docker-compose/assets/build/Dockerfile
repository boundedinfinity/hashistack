FROM ubuntu:22.10

###########################################
#   Install Utilities
###########################################

RUN apt-get update && apt-get install --yes \
    less fish pass gnupg pinentry-curses pwgen bash-completion \
    vim gettext iputils-ping jq dotenv sudo curl wget zip

###########################################
#   Provision Docker
###########################################

# https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository
RUN apt-get update \
    &&  apt-get install --yes ca-certificates curl gnupg lsb-release \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --output /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install --yes docker-ce-cli

# # https://docs.docker.com/engine/install/linux-postinstall/
# RUN groupadd docker \
#     && usermod --append --group docker ${NB_USER} \
#     && newgrp docker


###########################################
#   Provision Hashicorp Repository
###########################################

# https://www.hashicorp.com/official-packaging-guide
RUN apt-get update \
    &&  apt-get install --yes gpg lsb-release zip wget \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | gpg --dearmor --output /etc/apt/keyrings/hashicorp.gpg \
    && chmod a+r /etc/apt/keyrings/hashicorp.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update

###########################################
#   Provision Vault
###########################################

# https://www.hashicorp.com/official-packaging-guide
# NOTE: The binary from the APT repository doesn't seem to work.  So I install the package
#       to initialize the configuration files and directories, and manually provision the 
#       binary.
RUN apt-get install --yes vault \
    && wget https://releases.hashicorp.com/vault/1.13.1/vault_1.13.1_linux_amd64.zip -O /tmp/vault_1.13.1_linux_amd64.zip \
    && rm -rf /usr/bin/vault \
    && unzip /tmp/vault_1.13.1_linux_amd64.zip -d /usr/bin \
    && chmod 755 /usr/bin/vault \
    && rm -rf /tmp/vault_1.13.1_linux_amd64.zip

###########################################
#   Provision Consul
###########################################

# https://developer.hashicorp.com/consul/tutorials/production-deploy/deployment-guide#install-consul
RUN apt-get install --yes consul

###########################################
#   Provision Nomad
###########################################

# https://developer.hashicorp.com/consul/tutorials/production-deploy/deployment-guide#install-consul
RUN apt-get install --yes nomad 

###########################################
#   Common
###########################################

ENV HOST_RUNTIME_DIR=/you-forgot-to-set-this

ENV XDG_CONFIG_HOME=$HOME/.config
ENV XDG_DATA_HOME=$HOME/.local/share
ENV XDG_STATE_HOME=$HOME/.local/state
ENV XDG_CACHE_HOME=$HOME/.cache

COPY ./etc/profile.d /etc/profile.d
RUN chmod 0644 /etc/profile.d/*

COPY ./etc/fish/conf.d /etc/fish/conf.d
RUN chmod 0644 /etc/fish/conf.d/*

WORKDIR /workspace