#!/bin/sh
dd if=BEAGLEBOY-EEPROM.dump of=/sys/class/i2c-dev/i2c-2/device/2-0054/eeprom bs=1 count=96
