#!/bin/bash
export HOSTNAME=$(curl ifconfig.co)
curl -X POST -H 'Content-type: application/json' --data '{"text":"'$HOSTNAME' says: Hello, World!"}' https://hooks.slack.com/services/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
apt -y update
apt -y upgrade
apt -y install apt-transport-https ca-certificates curl software-properties-common python3-pip gnupg2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt -y update
apt-cache policy docker-ce
apt -y install docker-ce
systemctl status docker
curl -X POST -H 'Content-type: application/json' --data '{"text":"Docker installed in: '$HOSTNAME'"}' https://hooks.slack.com/services/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
usermod -aG docker ubuntu
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -X POST -H 'Content-type: application/json' --data '{"text":"Docker Compose installed in: '$HOSTNAME'"}' https://hooks.slack.com/services/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
docker network create ksl-network
curl -X POST -H 'Content-type: application/json' --data '{"text":"Docker ksl-network up for: '$HOSTNAME'"}' https://hooks.slack.com/services/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
add-apt-repository ppa:git-core/ppa -y
apt-get -y update
apt-get install git -y
curl -X POST -H 'Content-type: application/json' --data '{"text":"Installing JDK into: '$HOSTNAME'"}' https://hooks.slack.com/services/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
apt-get -y install openjdk-8-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get -y update
curl -X POST -H 'Content-type: application/json' --data '{"text":"Installing Jenkins into: '$HOSTNAME'"}' https://hooks.slack.com/services/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
apt-get install -y jenkins
systemctl start jenkins
curl -X POST -H 'Content-type: application/json' --data '{"text":"'$HOSTNAME' all peachy!"}' https://hooks.slack.com/services/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
reboot
