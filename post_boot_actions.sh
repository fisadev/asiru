# home content
sudo rsync -a -r /opt/asiru/home_asiru/ /home/mint/
sudo chown mint /home/mint -R
sudo chgrp mint /home/mint -R

# finish vim-debug instalation
install-vim-debug.py

