echo "Installing uinput service"
gcc -o /usr/local/bin/adcjs adcjs.c

echo "Installing X11 input driver configuration"
apt-get install xserver-xorg-input-joystick
mkdir /etc/X11/xorg.conf.d
install -m 644 99-gamingcape.conf /etc/X11/xorg.conf.d/

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

echo "Symlinking AIN0, AIN2, BUTTON_A and BUTTON_B"
#config-pin overlay BEAGLEBOY
config-pin overlay BB-ADC
mkdir -p /usr/share/gamingcape
cd /usr/share/gamingcape
#rm -f AIN0
#rm -f AIN2
#rm -f BUTTON_A
#rm -f BUTTON_B
ln -sf /sys/bus/iio/devices/iio\:device0/in_voltage0_raw AIN0
ln -sf /sys/bus/iio/devices/iio\:device0/in_voltage2_raw AIN2
#ln -s /sys/class/gpio/gpio49/value BUTTON_A
#ln -s /sys/class/gpio/gpio61/value BUTTON_B

echo "Installing scons"
apt-get update
apt-get install -y scons

echo "Cloning/updating fceu"
cd
if [ -d gamingcape_fceu ]; then
  cd gamingcape_fceu
  git pull
else
  git clone "https://github.com/jadonk/gamingcape_fceu.git"
  cd gamingcape_fceu
fi

echo "Building fceu"
scons
echo "Installing fceu"
./install.sh
