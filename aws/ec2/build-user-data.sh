#!/bin/bash
key=$(cat ~/.ssh/id_rsa.pub | xargs)

echo '#!/bin/bash' > raw.txt

raw='echo "'$key'" > /home/idearobin/.ssh/authorized_keys'
echo $raw >> raw.txt

raw='echo "%cardinals ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-cloud-init-users'
echo $raw >> raw.txt

raw='curl ifconfig.co | tr "." "-" > /etc/hostname'
echo $raw >> raw.txt

raw='adduser --disabled-password --gecos "" '`whoami`
echo $raw >> raw.txt

raw='usermod -aG docker '`whoami`
echo $raw >> raw.txt
raw='usermod -aG cardinals '`whoami`
echo $raw >> raw.txt
raw='usermod -aG sudo '`whoami`
echo $raw >> raw.txt

raw='mkdir /usr/local/etc/nginx && chgrp docker /usr/local/etc/nginx && chmod g+wsxr /usr/local/etc/nginx'
echo $raw >> raw.txt
raw='mkdir /usr/local/etc/sockets && chgrp docker /usr/local/etc/sockets && chmod g+wsxr /usr/local/etc/sockets'
echo $raw >> raw.txt

raw='mkdir /home/'`whoami`'/.ssh'
echo $raw >> raw.txt

raw='echo "'$key'" >> /home/'`whoami`'/.ssh/authorized_keys'
echo $raw >> raw.txt

raw='chown -R '`whoami`':'`whoami`' /home/'`whoami`'/.ssh'
echo $raw >> raw.txt

raw='chmod 600 /home/'`whoami`'/.ssh/authorized_keys'
echo $raw >> raw.txt

raw='cp /home/idearobin/.vimrc /home/'`whoami`'/.vimrc'
echo $raw >> raw.txt

raw='chown '`whoami`':'`whoami`' /home/'`whoami`'/.vimrc'
echo $raw >> raw.txt

raw='runuser -l '`whoami`' -c "pip3 install awscli --upgrade --user"'
echo $raw >> raw.txt

raw='echo "export PATH=/home/'`whoami`'/.local/bin:$PATH" >> /home/'`whoami`'/.profile'
echo $raw >> raw.txt

raw='echo "complete -C /home/'`whoami`'/.local/bin/aws_completer aws" > /home/'`whoami`'/.bash_completion'
echo $raw >> raw.txt

raw='chown '`whoami`':'`whoami`' /home/'`whoami`'/.bash_completion'
echo $raw >> raw.txt

echo 'sleep 3' >> raw.txt
echo 'sudo reboot' >> raw.txt
