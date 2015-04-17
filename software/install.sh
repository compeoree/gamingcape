echo "Compiling dts"
dtc -O dtb -o BEAGLEBOY-0013.dtbo -b 0 -@ BEAGLEBOY-0013.dts
echo "Installing dts"
cp BEAGLEBOY-0013.dtbo /lib/firmware/
echo "Installing systemd service"
cp gamingcape.service /etc/systemd/system/
echo "Enabling systemd service"
systemctl enable gamingcape.service
#echo "Mounting boot partition"
#mount /dev/mmcblk0p1 /mnt/card
#echo "Backing up uEnv.txt"
#cp /mnt/card/uEnv.txt /mnt/card/uEnv.txt.backup
#echo "Editing boot args to disable hdmi"
#echo "optargs=quiet drm.debug=7 capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN" > /mnt/card/uEnv.txt
#echo "Unmounting partition"
#umount /mnt/card/
#echo "Installing custom kernel"
#rm /boot/uImage
#cp uImage /boot/uImage-custom
#ln -s /boot/uImage-custom /boot/uImage
#echo "Disabling some services"
#systemctl disable mpd
#systemctl disable gdm
echo "Enabling autologin"
cp getty@tty1.service /etc/systemd/system/getty.target.wants/
#echo "Changing default shell to bash"
#chsh -s /bin/bash
echo "Intalling bash_profile"
cp bash_profile .bash_profile
echo "Installing xinitrc"
cp xinitrc .xinitrc
echo "Disabling git sslVerify"
git config --global http.sslVerify false
echo "Symlinking AIN0 and AIN2"
config-pin overlay BB-ADC
mkdir -p /home/root
cd /home/root
ln -s `ls /sys/devices/ocp.*/helper.*/AIN0` AIN0
ln -s `ls /sys/devices/ocp.*/helper.*/AIN2` AIN2

echo "Installing scripts"
mkdir -p /usr/share/gamingcape
install -m 755 init_gamingcape.sh /usr/share/gamingcape/

#echo "Updating opkg"
#opkg update
#echo "Installing python-distutils"
#opkg install python-distutils
#echo "Installing python-compile"
#opkg install python-compile

# wget http://prdownloads.sourceforge.net/scons/scons-2.3.0.tar.gz
# tar xvf scons-2.3.0.tar.gz
# cd scons-2.3.0
# python setup.py install

# git clone "https://github.com/bear24rw/gamingcape_fceu.git"
# cd gamingcape_fceu
# scons
