echo "Compiling dts"
dtc -O dtb -o BEAGLEBOY-0013.dtbo -b 0 -@ BEAGLEBOY-0013.dts
echo "Installing dts"
cp BEAGLEBOY-0013.dtbo /lib/firmware/
echo "Rebuilding initrd with dts"
install -m 755 dtbo /usr/share/initramfs-tools/hooks/
/opt/scripts/tools/developers/update_initrd.sh
echo "Installing systemd service"
cp gamingcape.service /etc/systemd/system/
echo "Enabling systemd service"
systemctl enable gamingcape.service
#echo "Disabling some services"
#systemctl disable mpd
#systemctl disable gdm
echo "Enabling autologin"
cp getty@tty1.service /etc/systemd/system/getty.target.wants/
#echo "Disabling git sslVerify"
#git config --global http.sslVerify false
echo "Installing scripts"
mkdir -p /usr/share/gamingcape
install -m 755 init_gamingcape.sh /usr/share/gamingcape/

echo "Symlinking AIN0 and AIN2"
#config-pin overlay BEAGLEBOY
config-pin overlay BB-ADC
mkdir -p /home/root
cd /home/root
rm -f AIN0
rm -f AIN2
ln -s `ls /sys/devices/ocp.*/helper.*/AIN0` AIN0
ln -s `ls /sys/devices/ocp.*/helper.*/AIN2` AIN2


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

# cd
# git clone "https://github.com/bear24rw/gamingcape_fceu.git"
# cd gamingcape_fceu
# scons
