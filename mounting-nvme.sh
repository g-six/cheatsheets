#!/bin/bash 
sudo mkdir /mnt/nvme
sudo chgrp docker /mnt/nvme
sudo chmod g+wsxr /mtn/nvme
sudo file -s /dev/nvme0n1
sudo mkfs -t xfs /dev/nvme0n1
sudo mount /dev/nvme0n1 /mnt/nvme
df -h
