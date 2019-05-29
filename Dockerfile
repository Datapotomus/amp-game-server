FROM ubuntu:18.04

EXPOSE 8080

ARG DEBIAN_FRONTEND=noninteractive

ENV password=changeme1


RUN useradd -d /home/AMP -m AMP -s /bin/bash
#    echo "AMP:${password}" | chpasswd

RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        dirmngr \
        apt-transport-https

RUN apt-key adv --fetch-keys http://repo.cubecoders.com/archive.key

RUN apt-add-repository "deb http://repo.cubecoders.com/ debian/"

RUN apt-get update
    
RUN apt-get install -y ampinstmgr --install-suggests
