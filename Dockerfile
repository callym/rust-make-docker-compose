FROM rust:latest

RUN apt-get update
RUN apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common python3-pip -y

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install docker-ce -y

RUN pip3 install docker-compose

# https://askubuntu.com/questions/870889/cant-start-docker-on-ubuntu-16-04-with-driver-not-supported-error/870890
RUN apt-get install linux-image-extra-virtual -y
RUN modprobe aufs
RUN mkdir -p /etc/docker
RUN echo '{ "storage-driver": "aufs" }' > /etc/docker/daemon.json

RUN cargo install cargo-make

COPY dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]

CMD ["/bin/bash"]
