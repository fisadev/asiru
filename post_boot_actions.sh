# home content
sudo rsync -a -r /opt/asiru/home_asiru/ /home/ubuntu/
sudo chown ubuntu /home/ubuntu -R
sudo chgrp ubuntu /home/ubuntu -R

# finish vim-debug instalation
install-vim-debug.py

