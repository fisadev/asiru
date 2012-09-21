mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

# modified apt sources, index and cache
chown root /etc/apt/sources.list
chgrp root /etc/apt/sources.list
chmod 644 /etc/apt/sources.list
chown root /var/lib/apt/lists/*
chgrp root /var/lib/apt/lists/*
chmod 644 /var/lib/apt/lists/*
chown root /var/cache/apt/archives/*.deb
chgrp root /var/cache/apt/archives/*.deb
chmod 644 /var/cache/apt/archives/*.deb

# packages
apt-get update
apt-get upgrade -y
apt-get install -y ipython bpython python-pip python-imaging winpdb gunicorn
apt-get install -y vim vim-gtk exuberant-ctags
apt-get install -y mercurial subversion git tk8.5 meld
apt-get install -y chromium-browser tmux
# sudo apt-get install -y wine

# python packages
sudo pip install django
sudo pip install dbgp
sudo pip install vim-debug
sudo pip install virtualenv
sudo pip install bottle
sudo pip install pep8
sudo pip install flake8
sudo pip install pyflakes
sudo pip install requests
sudo pip install fabric

# finish fisa-vim-config installation
cp /opt/asiru/home_asiru/.vimrc /root/
vim +BundleInstall +qall
sudo rm /opt/asiru/home_asiru/.vim -rf
mv /root/.vim /opt/asiru/home_asiru/

# ninja ide
sudo dpkg -i /root/ninja-ide_2.0-all.deb
sudo apt-get install -f

# make post_boot_actions.sh to be executed on after livecd boot
grep '#' /etc/rc.local > /etc/rc.local
echo "sudo sh /opt/asiru/post_boot_actions.sh" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
