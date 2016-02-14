FROM centos:centos5

MAINTAINER Eugene Zamriy <eugene@zamriy.info>

ENV LANG en_US.UTF-8

RUN rpm -ivh --nosignature http://ftp.colocall.net/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm && \
    rpm -ivh --nosignature http://sigmarepo.zamriy.info/repo/EL/5/x86_64/sigma-release-5-1.el5.sigma.noarch.rpm && \
    yum -y update && \
    yum -y install curl.x86_64 openssh-clients openssh-server python-simplejson sudo supervisor && \
    yum clean all && \
    sed -i -e '/\[epel\]/,/^\[/s/enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo && \
    sed -i -e '/\[sigma\]/,/^\[/s/enabled=1/enabled=0/' /etc/yum.repos.d/sigma.repo && \
    ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_key && \
    ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -b 1024 -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    sed -i -e 's/^\(AcceptEnv LANG.*\)/\#\1/' -e 's/^\(AcceptEnv LC_.*\)/\#\1/' -e 's/^\(AcceptEnv XMODIFIERS.*\)/\#\1/' /etc/ssh/sshd_config && \
    groupadd -g 1666 vagrant && \
    useradd -g vagrant -u 1666 -d /home/vagrant -m vagrant && \
    echo vagrant | passwd --stdin vagrant && \
    mkdir -m 0700 -p /home/vagrant/.ssh && \
    curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys && \
    chmod 600 /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    sed -i 's/^\(Defaults.*requiretty\)/#\1/' /etc/sudoers && \
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


COPY supervisord.conf /etc/supervisord.conf

EXPOSE 22 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
