# syntax=docker/dockerfile:1

FROM ubuntu:22.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV BUN_INSTALL=/utils/bun

#RUN echo -e 'Dir::Cache "";nDir::Cache::archives "";' | tee /etc/apt/apt.conf.d/00_disable-cache-directories

RUN apt update && \
    apt upgrade -y

# Setup folders
RUN mkdir /tools && mkdir /utils && mkdir -m 0700 -p ~/.ssh 

# Python
RUN apt install -y python3 python3-pip 

# general tools
RUN apt install -y git wget curl btop htop nano openssh-client zip unzip libimage-exiftool-perl 

# net tools
RUN apt install -y dnsutils net-tools iputils-ping traceroute nmap netdiscover netcat

# libs
RUN apt install -y libcurl4-openssl-dev libssl-dev

# Download public key for github.com
# && ssh-keyscan -T 10 github.com >> ~/.ssh/known_hosts
COPY home/known_hosts /root/.ssh/

# setup zsh
RUN apt install -y zsh && chsh -s $(which zsh)

# setup dotfiles
RUN --mount=type=ssh,required=true git clone git@github.com:Flo2410/dotfiles.git ~/dotfiles && \
    zsh ~/dotfiles/zsh/install-zsh.sh 
COPY home/.zshrc /root/.zshrc

# Node
RUN curl -L https://bit.ly/n-install | N_PREFIX=/utils/n bash -s -- -y latest 

# bun
RUN curl https://bun.sh/install | bash

# python tools
RUN pip install wfuzz

# setup tools
COPY ./tools /tools
RUN cd /tools && make && make install
RUN git clone https://github.com/xmendez/wfuzz.git /tools/wfuzz
#RUN git clone https://github.com/roukaour/ascii85.git /tools/ascii85 && cd /tools/ascii85 && make && ln -s /tools/ascii85/ascii85 /usr/bin

WORKDIR /pwd



