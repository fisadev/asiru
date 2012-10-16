# home content
sudo rsync -a -r /opt/asiru/home_asiru/ /home/ubuntu/
sudo chown ubuntu /home/ubuntu -R
sudo chgrp ubuntu /home/ubuntu -R

# gnome terminal colors
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#111111111111"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/foreground_color" --type string "#FFFFFFFFFFFF"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
