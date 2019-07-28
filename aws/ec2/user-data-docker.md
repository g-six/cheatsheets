```bash
#!/bin/bash
apt -y update
apt -y upgrade
apt -y install apt-transport-https ca-certificates curl software-properties-common python3-pip gnupg2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt -y update
apt-cache policy docker-ce
apt -y install docker-ce
systemctl status docker
usermod -aG docker ubuntu
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
reboot
```
