BeagleBone Gamingcape
=

This project contains the necessary files to get your CircuitHub Gamingcape up and running.


Making Beaglebone Aware of Cape
-

### Method 1

This method is a hack, in order to avoid flashing the cape EEPROM. It involves disabling the HDMI driver and force loading the gaming cape driver, which is already included in the Debian image (Linux beaglebone 4.4.54-ti-r93 #1 SMP Fri Mar 17 13:08:22 UTC 2017 armv7l GNU/Linux).

Edit /boot/uEnv.txt and
1) Uncomment the line that contains 'dtb=am335x-boneblack-emmc-overlay.dtb' to disable HDMI
2) Add the following line anywhere in the file 'cape_enable=bone_capemgr.enable_partno=BEAGLEBOY:0013'

Reboot and enjoy viewing a tiny X-window session.



### Method 2

1) Clone this repository onto the Beaglebone.
2) Short WP pin (above the left, "A", button) to DGND. I used a 470R resistor.
3) Run the `write_eeprom.sh` script.
4) Verify the write by running `sudo cat /sys/class/i2c-dev/i2c-2/device/2-0054/eeprom | hexdump -C`

The output should look similar to this:
```
00000000  aa 55 33 ee 41 31 42 65  61 67 6c 65 42 6f 6e 65  |.U3.A1BeagleBone|
00000010  20 47 61 6d 69 6e 67 20  43 61 70 65 00 00 00 00  | Gaming Cape....|
00000020  00 00 00 00 00 00 30 30  31 33 43 69 72 63 75 69  |......0013Circui|
00000030  74 48 75 62 00 00 00 00  00 00 42 45 41 47 4c 45  |tHub......BEAGLE|
00000040  42 4f 59 00 00 00 00 00  00 00 30 30 31 35 30 34  |BOY.......001504|
00000050  47 41 4d 45 30 30 30 31  00 00 00 00 00 00 00 00  |GAME0001........|
00000060  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00008000
```
If so, reboot to enjoy your LCD in all its glory.


Original Documentation
-

Original cape documentation can be found at the following link:

[http://bear24rw.blogspot.com/2013/07/beaglebone-gamingcape.html](http://bear24rw.blogspot.com/2013/07/beaglebone-gamingcape.html)

License
-
Copyright Max Thrun 2013.

This repository contains the design files for the BeagleBone Gamingcape  and is
licensed under the CERN OHL v. 1.2.

You may redistribute and modify this project under the terms of the CERN
OHL v.1.2. (http://ohwr.org/cernohl). This documentation is distributed WITHOUT
ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY
QUALITY AND FITNESS FOR A PARTICULAR PURPOSE. Please see the CERN OHL v.1.2 for
applicable conditions
