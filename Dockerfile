FROM ubuntu:18.04

EXPOSE 8080

ARG DEBIAN_FRONTEND=noninteractive

ENV AMPPASSWORD=changeme1
ENV AMPUSER=admin


RUN useradd -d /home/AMP -m AMP -s /bin/bash
#    echo "AMP:${password}" | chpasswd

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils \
        software-properties-common \
        dirmngr \
        apt-transport-https

RUN apt-key adv --fetch-keys http://repo.cubecoders.com/archive.key

RUN apt-add-repository "deb http://repo.cubecoders.com/ debian/"

RUN apt-get update
    
RUN apt-get install -y ampinstmgr --install-suggests

RUN su -l AMP -c '(crontab -l ; echo "@reboot ampinstmgr -b")| crontab -' && \
    mkdir -p /AMP && \ 
    chown AMP:AMP /AMP && \
    ln -s /AMP /home/AMP/
    
VOLUME ["/AMP"]

ENTRYPOINT (su -l AMP -c "ampinstmgr quick ${AMPUSER} ${AMPPASSWORD} 0.0.0.0 8080"; su -l AMP "ampinstmgr view ADS true") || bash || tail -f /dev/null
