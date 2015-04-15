#!/bin/sh
xset s off
xset s noblank
#config-pin overlay BEAGLEBOY
sleep 2
echo 61 > /sys/class/gpio/export
echo 49 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio49/direction
echo in > /sys/class/gpio/gpio61/direction
#fceux --sound 1  --fullscreen 1 --xres 320 --yres 240 /root/ROMS/ROM.nes |tee /root/log.file
