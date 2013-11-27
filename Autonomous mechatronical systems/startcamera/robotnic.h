/* robotnic.h */

#ifndef _ROBOTNIC_H
#define _ROBOTNIC_H



#define EXTSRAM 			*(unsigned volatile int *)0xB0080000  // Extern minnesbuffer
#define SDRAM				*(unsigned volatile int *)0x80000000  //	Dynamiskt ram
#define SERVO_0			*(unsigned volatile int *)0xB0000000
#define SERVO_1			*(unsigned volatile int *)0xB0008000
#define DCMOTOR			*(unsigned volatile int *)0xB0030000
#define CAMERA				*(unsigned volatile int *)0xB0028000	// CAMERA Address
#define DIG_IO				*(unsigned volatile int *)0xB0020000	// Digitalt IO
#define DRAM_START 		0x80000000
#define EXT_RAM_START 	0xB0080000

#define MOTORFRAM	0x100
#define MOTORBACK	0x200
#define MOTOR_0	0x400
#define MOTOR_1	0x800
#define MOTOR_2	0x1000
#define MOTOR_3	0x2000
#define MOTOR_4	0x4000
#define MOTOR_5	0x8000

#define CLKLOW		0x00
#define CLKHIGH	0x10
#define DATAHIGH	0x08
#define DATALOW	0x00

#define IMAGEWIDH	320
#define IMAGEHIGH	240

extern unsigned int DC_Motors;
extern unsigned char CameraReg;

#endif
