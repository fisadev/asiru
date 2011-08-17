# home content
sudo chown ubuntu /root/home_asiru -R
sudo chgrp ubuntu /root/home_asiru -R
sudo rsync -a -r /root/home_asiru/ /home/ubuntu/

# finish vim-debug instalation
install-vim-debug.py

# avoid more executions of post boot actions
echo "" | sudo tee /root/post_boot_actions.sh > /dev/null
