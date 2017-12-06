FROM fedora:27
MAINTAINER Billy Holmes <billy@gonoph.net>
ENV	PS1='\[\033[01;30m\](\[\033[01;32m\]container\[\033[01;30m\])\[\033[0m\] [\u@\h \[\033[01;34m\]\W\[\033[0m\]]$ ' \
	BUILD_UID=500 \
	BUILD_GID=500
RUN     yum update -y \
	&& yum install -y \
	ansible \
	git \
	origin-clients \
	sudo \
        vim \
	python2-pip \
        && rm -rf /var/cache/yum \
        && pip install -U pip \
        && pip install boto3 boto \
        && rm /root/.cache/pip/ -rf \
        && groupadd -g $BUILD_GID ansible \
        && useradd -u $BUILD_UID -g $BUILD_GID ansible -G wheel \
        && echo 'ansible  ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/ansible_conf
WORKDIR	/tmp/install
COPY	motd /etc/motd
RUN	echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' > /etc/profile.d/motd.sh
USER    ansible
CMD [ "/usr/bin/bash" ]
