mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

# modified apt index and cache
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
apt-get install -y vim vim-gtk editra ctags
apt-get install -y mercurial subversion git tk8.5 tortoisehg tortoisehg-nautilus meld
apt-get install -y chromium-browser vncviewer
# sudo apt-get install -y wine

# python packages
sudo pip install django
sudo pip install dbgp
sudo pip install vim-debug
sudo pip install virtualenv
sudo pip install pylint

# make post_boot_actions.sh to be executed on after livecd boot
grep '#' /etc/rc.local > /etc/rc.local
echo "sudo sh /opt/asiru/post_boot_actions.sh" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
