```bash
#!/bin/bash
apt-get -y update
apt-get -y upgrade
apt-get -y install apt-transport-https ca-certificates curl software-properties-common python3-pip gnupg2 nodejs
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
apt-get -y update
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install ruby-2.3.3
apt-get -y install nginx
```
