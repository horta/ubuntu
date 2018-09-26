FROM ubuntu:latest
LABEL name="dhorta/ubuntu"

ARG DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y cmake vim wget curl build-essential
RUN apt-get install -y bzip2 ca-certificates mercurial git tmux

RUN mkdir /run/uuidd
RUN apt-get install -y fish ruby locales make uuid-runtime sudo
RUN apt-get install firefox
RUN echo "/usr/bin/fish >> /etc/shells"
RUN useradd -m -s /usr/bin/fish horta \
	&& echo 'horta ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
        && localedef -i en_US -f UTF-8 en_US.UTF-8

USER horta
WORKDIR /home/horta
ENV PATH=/home/horta/.linuxbrew/bin:/home/horta/.linuxbrew/sbin:$PATH \
	SHELL=/usr/bin/fish \
	USER=horta

RUN git clone https://github.com/Linuxbrew/brew.git /home/horta/.linuxbrew/Homebrew \
	&& mkdir /home/horta/.linuxbrew/bin \
	&& ln -s ../Homebrew/bin/brew /home/horta/.linuxbrew/bin/ \
	&& brew config

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p ~/anaconda && \                                                       
    rm ~/anaconda.sh && \                                                                               
    echo ". ~/anaconda/etc/profile.d/conda.sh" >> ~/.bashrc && \                                        
    echo "conda activate base" >> ~/.bashrc 

CMD [ "/usr/bin/fish" ]
