#!/bin/sh
dd if=BEAGLEBOY-EEPROM.dump of=/sys/class/i2c-dev/i2c-1/device/1-0054/eeprom bs=1 count=96
