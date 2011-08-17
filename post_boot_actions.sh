# home content
sudo rsync -a -r /root/home_asiru/ /home/mint/
sudo chown mint /home/mint -R
sudo chgrp mint /home/mint -R

# finish vim-debug instalation
install-vim-debug.py

# avoid more executions of post boot actions
echo "" | sudo tee /root/post_boot_actions.sh > /dev/null
