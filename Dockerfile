# syntax=docker/dockerfile:1

FROM ubuntu:22.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV BUN_INSTALL=/utils/bun

# RUN echo -e 'Dir::Cache "";nDir::Cache::archives "";' | tee /etc/apt/apt.conf.d/00_disable-cache-directories

RUN apt update && \
    apt upgrade -y

# Setup folders
RUN mkdir /tools && mkdir /utils && mkdir -m 0700 -p ~/.ssh 

# Python
RUN apt install -y python3 python3-pip 

# general tools
RUN apt install -y git wget curl btop htop nano openssh-client zip unzip file binwalk gdb sudo

# build tools
RUN apt install -y build-essential gcc make openjdk-18-jdk

# net tools
RUN apt install -y dnsutils net-tools iputils-ping traceroute nmap netdiscover netcat

# libs
RUN apt install -y libcurl4-openssl-dev libssl-dev libimage-exiftool-perl

# Download public key for github.com
# ssh-keyscan -T 10 github.com >> ~/.ssh/known_hosts
COPY home/known_hosts /root/.ssh/

# setup zsh
# RUN apt install -y zsh && chsh -s $(which zsh)


# this is needed to bust the cache an re-download the dotfiles
ARG CACHEBUST=1

# setup dotfiles
RUN --mount=type=ssh,required=true,mode=0666 git clone git@github.com:Flo2410/dotfiles.git --recurse-submodules ~/dotfiles && \
    cd ~/dotfiles && \
    ./install-profile mjölnir
# COPY home/.zshrc /root/.zshrcc

# Node
RUN curl -L https://bit.ly/n-install | N_PREFIX=/utils/n bash -s -- -y latest 

# bun
# RUN curl https://bun.sh/install | bash

# conda
# RUN mkdir -p /utils/miniconda3 && \
#     wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /utils/miniconda3/miniconda.sh && \ 
#     zsh /utils/miniconda3/miniconda.sh -b -u -p /utils/miniconda3 && \
#     rm -rf /utils/miniconda3/miniconda.sh && \
#     /utils/miniconda3/bin/conda init zsh && \
#     /utils/miniconda3/bin/conda config --set auto_activate_base false

# python tools
# RUN pip install wfuzz

# setup tools
COPY ./tools /tools
RUN cd /tools && make && make install
RUN git clone https://github.com/xmendez/wfuzz.git /tools/wfuzz
# RUN git clone https://github.com/roukaour/ascii85.git /tools/ascii85 && cd /tools/ascii85 && make && ln -s /tools/ascii85/ascii85 /usr/bin

WORKDIR /pwd



