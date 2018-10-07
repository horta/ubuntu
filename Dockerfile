FROM ubuntu:latest
LABEL name="dhorta/ubuntu"

ARG DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y cmake vim wget curl build-essential
RUN apt-get install -y bzip2 ca-certificates mercurial git tmux

RUN mkdir /run/uuidd
RUN apt-get install -y ruby locales make uuid-runtime sudo
RUN useradd -m -s /bin/bash horta \
	&& echo 'horta ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
        && localedef -i en_US -f UTF-8 en_US.UTF-8

RUN apt-get install -y w3m htop zlib1g zlib1g-dev libzstd1 libzstd1-dev \
        npm
ENV TERM=xterm-256color

USER horta
WORKDIR /home/horta
ENV PATH=/home/horta/.linuxbrew/bin:/home/horta/.linuxbrew/sbin:$PATH \
	USER=horta \
    HOME=/home/horta

RUN git clone https://github.com/Linuxbrew/brew.git /home/horta/.linuxbrew/Homebrew \
	&& mkdir /home/horta/.linuxbrew/bin \
	&& ln -s ../Homebrew/bin/brew /home/horta/.linuxbrew/bin/ \
	&& brew config

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh \
    -O ~/anaconda.sh && /bin/bash ~/anaconda.sh -b -p ~/anaconda && \
    rm ~/anaconda.sh && \
    echo ". ~/anaconda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc 

RUN . ~/anaconda/etc/profile.d/conda.sh && \
    conda activate base && \
    conda update --all -y

ADD .bash_profile /home/horta/.bash_profile
ADD t2.sh /home/horta/t2.sh
ADD t3.sh /home/horta/t3.sh

CMD [ "bash" ]
