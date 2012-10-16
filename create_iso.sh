echo "Installing necesary tools on host system"
sudo apt-get install squashfs-tools genisoimage

echo "Extracting original ubuntu image..."
mkdir mnt
sudo mount -o loop ubuntu-12.04-desktop-i386.iso mnt
mkdir extract_cd
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract_cd

echo "Unsquashing original filesystem..."
sudo unsquashfs mnt/casper/filesystem.squashfs

echo "Modifying system on chroot..."
sudo mv squashfs-root edit

# necesary to have internet inside the chroot
sudo cp /etc/resolv.conf edit/etc/
sudo cp /etc/hosts edit/etc/

# sources, index and cache for apt, to avoid re-download every time we run the script
mkdir index_apt
mkdir cache_apt
sudo cp sources.list edit/etc/apt/
sudo cp index_apt/* edit/var/lib/apt/lists/
sudo cp cache_apt/* edit/var/cache/apt/archives/

# extra .deb packages to install
sudo cp manual_debs edit/root/ -r

# livecd home content
sudo mkdir -p edit/opt/asiru
sudo cp home_asiru edit/opt/asiru/ -r

# livecd post boot actions
sudo cp post_boot_actions.sh edit/opt/asiru/
# chroot actions
sudo cp modify_chroot.sh edit/opt/asiru/
sudo cp clean_chroot.sh edit/opt/asiru/

sudo mount --bind /dev/ edit/dev

# chroot modifications
sudo chroot edit /bin/sh /opt/asiru/modify_chroot.sh

# steal index and cache from chroot's apt, so we have it for the next time we 
# run the script
sudo cp edit/var/lib/apt/lists/* index_apt/ 
sudo rm index_apt/lock
sudo cp edit/var/cache/apt/archives/*.deb cache_apt/

echo "Chroot ready!"

echo "Rebuilding initrd..."
sudo chroot edit /bin/sh -c "mkinitramfs -o /initrd.gz 3.2.0-23-generic-pae"
sudo mv edit/initrd.gz extract_cd/casper/

echo "Cleaning chroot..."
sudo chroot edit /bin/sh /opt/asiru/clean_chroot.sh
sudo umount edit/dev

echo "Creating filesystem manifest..."
chmod +w extract_cd/casper/filesystem.manifest
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract_cd/casper/filesystem.manifest
sudo cp extract_cd/casper/filesystem.manifest extract_cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract_cd/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' extract_cd/casper/filesystem.manifest-desktop

echo "Creating squash of the filesystem..."
sudo rm extract_cd/casper/filesystem.squashfs
sudo mksquashfs edit extract_cd/casper/filesystem.squashfs

echo "Calculating size and checksums..."
printf $(sudo du -sx --block-size=1 edit | cut -f1) > tmp.txt
sudo mv tmp.txt extract_cd/casper/filesystem.size
cd extract_cd
sudo rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt

echo "Compiling image..."
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../asiru.iso .
cd ..

echo "Cleaning..."
sudo umount mnt
sudo rm -rf edit extract_cd mnt

echo "Asiru image ready to use!"
notify-send "Asiru image ready to use!" -i gtk-ok
