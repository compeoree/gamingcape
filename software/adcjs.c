/* 
 * Convert ADC input on the BBW/BBB into an event device to 
 * emulate a joy stick.
 *
 * Usage: ./adcjs pathtoXchannel pathtoYchannel
 * 
 * License: GPLv2
 * 
 * (C) 2015 HY Research LLC
 * 	hy-open2015@hy-research.com
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>
#include <linux/uinput.h>

#define VERSION	"0.1"

#define MAX_VAL 4095
int centerCaptured = 0;
int centerX = MAX_VAL/2;
int centerY = MAX_VAL/2;

void usage(char *n)
{
	fprintf(stderr, "Version "VERSION
			" Compiled on "__DATE__" at "__TIME__"\n");
	fprintf(stderr, "%s: PathToAdcX PathToAdcY\n", n);
}


/* Read the ADC channel. Parameter is the path to sysfs 
 * 
 * Expects the sysfs file to contain 1 line with the value
 * in millivolt.
 *
 * Do any scaling between joystick axis values and ADC values
 * here.
 */
int getADC(char *adc)
{
#if 1
	int fd;
	char line[80];

	fd = open(adc, O_RDONLY);
	if (fd < 0) return -1;
	read(fd, line, 79);
	line[79] = '\0';
	close(fd);
	return atoi(line);
#else
	/* Dummy value for testing w/o HW */
	static int i;
	i++;
	i %= 1800;
	return i;
#endif
}

void runJS(char *adcX, char *adcY, int fd)
{
	int x, y;
	int ret;
	struct timeval tv;
	struct input_event ev;

	while(1) {
		x = getADC(adcX);		
		y = getADC(adcY);
		if (x < 0 && y < 0) 
			continue;

		if (!centerCaptured) {
			centerX = x;
			centerY = y;
			centerCaptured = 1;
			fprintf(stderr, "Center at %d,%d\n", x, y);
		}

		/* Apply center adjustment function */
		if (centerX <= MAX_VAL/2) {
			x = x * MAX_VAL/(2*centerX);
			if (x > MAX_VAL) x = MAX_VAL;
		} else {
			x = ((x - centerX) * MAX_VAL/(2*(MAX_VAL-centerX)))
				+ MAX_VAL/2;
			if (x < 0) x = 0;
		}
		if (centerY <= MAX_VAL/2) {
			y = y * MAX_VAL/(2*centerY);
			if (y > MAX_VAL) y = MAX_VAL;
		} else {
			y = ((y - centerY) * MAX_VAL/(2*(MAX_VAL-centerY)))
				+ MAX_VAL/2;
			if (y < 0) y = 0;
		}


		/* Report */
		ev.type = EV_ABS;
		ev.code = ABS_X;
		ev.value = x;
		ret = write(fd, &ev, sizeof(ev));
		if (ret < 0) continue;
	
		ev.type = EV_ABS;
		ev.code = ABS_Y;
		ev.value = y;
		ret = write(fd, &ev, sizeof(ev));
		if (ret < 0) continue;

		ev.type = EV_SYN;
		ev.code = 0;
		ev.value = 0;
		ret = write(fd, &ev, sizeof(ev));
		if (ret < 0) continue;

		tv.tv_sec = 0;
		tv.tv_usec = 200000; /* 200mS */
		select(0, NULL, NULL, NULL, &tv);
	}
}

int main(int argc, char **argv)
{
	char *adcX, *adcY;
	int fd;
	struct uinput_user_dev uindev;
	int ret;

	if  (argc < 3) {
		usage(argv[0]);
		exit(1);
	}

	adcX = argv[1];
	adcY = argv[2];
	
	fd = open(adcX, O_RDONLY);
	if (fd < 0) {
		perror("open X");
		exit(2);
	}
	close(fd);
	fd = open(adcY, O_RDONLY);
	if (fd < 0) {
		perror("open Y");
		exit(2);
	}
	close(fd);

	/* Work around userland stupidity. Try 2 common
	 * locations.
	 */

	fd = open("/dev/input/uinput", O_WRONLY | O_NONBLOCK);
	if (fd < 0 && errno != ENOENT) {
		perror("open uinput");
		exit(3);
	} else if (fd < 0) {
		fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
		if (fd < 0) {
			perror("open uinput");
			exit(3);
		}
	}

	memset(&uindev, 0, sizeof(uindev));

	strncpy(uindev.name, "joystick", UINPUT_MAX_NAME_SIZE);
	uindev.id.bustype = BUS_HOST;
	uindev.id.vendor  = 0;
	uindev.id.product = 0;
	uindev.id.version = 1;
	uindev.absmin[ABS_X] = 0;
	uindev.absmax[ABS_X] = MAX_VAL;
	uindev.absmin[ABS_Y] = 0;
	uindev.absmax[ABS_Y] = MAX_VAL;

	ret = write(fd, &uindev, sizeof(uindev));
	if (ret < 0) {
		perror("uindev write");
	}


	ret = ioctl(fd, UI_SET_EVBIT, EV_ABS);
	if (ret < 0) {
		perror("ioctl EV_ABS EVBIT");
		exit(4);
	}
	ret = ioctl(fd, UI_SET_EVBIT, EV_SYN);
	if (ret < 0) {
		perror("ioctl EV_SYN EVBIT");
		exit(4);
	}
	ret = ioctl(fd, UI_SET_ABSBIT, ABS_X);
	if (ret < 0) {
		perror("ioctl ABS_X ABSBIT");
		exit(4);
	}
	ret = ioctl(fd, UI_SET_ABSBIT, ABS_Y);
	if (ret < 0) {
		perror("ioctl ABS_Y ABSBIT");
		exit(4);
	}
	
	ret = ioctl(fd, UI_DEV_CREATE);
	if (ret < 0) {
		perror("ioctl CREATE");
		exit(4);
	}

	runJS(adcX, adcY, fd);
	return 0;
}
