/* Interface routines for Omnivision OV7620 Single-Chip Cmos VGA Color Digital Camera */
/* Author : Bjorn Astrand, Halmstad University */
#ifndef _CAMERA_H
#define _CAMERA_H
 
/* Image struct */
typedef struct {
		unsigned int Hight;
		unsigned int Width;
		unsigned int StartVertical;
		unsigned int StartHorizontal;
		unsigned int Decimation;
		unsigned int ScanMode;
		unsigned int Resolution;
		unsigned int GrabbMode;
		unsigned int *Image;
	} ImageType;

/* Function Variables */
#define	GRABB_SYNCHRONOUS		1
#define	GRABB_ASYNCHRONOUS		0
#define PROGRESIVE				1
#define INTERLACED				0
#define VGA						1
#define QVGA					0 
#define GRABB_YUV				0
#define GRABB_RGB				1
#define GRABB_RGB_VIA_YUV		2 


/* Set AGC gain control */
/* Gain formula is Gain = (<3:0>/16+1)*(<4>+1)*(<5>+1); */
/* Range (1x-7.75x), <4>, <5> control SA2 */
int OV7620_AGCGainControl(unsigned char ucGain);

/* Read AGC gain control */
int OV7620_AGCGainControlRead(unsigned char *ucGain); 

/* Set Blue Gain Control for white balance */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_BlueGainControl(signed char scGain); 

/* Read Blue Gain Control for white balanse */
int OV7620_BlueGainControlRead(signed char *scGain);

/* Set Red Gain Control for white balance */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_RedGainControl(signed char scGain); 

/* Read Red Gain Control for white balanse */
int OV7620_RedGainControlRead(signed char *scGain);

/* Set brightness Control for Y/RGB channel */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_BrightnessControl(signed char scGain);

/* Read brightness Control for Y/RGB channel */
int OV7620_BrightnessControlRead(signed char *scGain);

/* Set Auto Exposure control register */
int OV7620_AutoExposureControlRegister(unsigned char temp);

/* Read Auto Exposure control register */
int OV7620_AutoExposureControlRegisterRead(unsigned char *temp);

/* Software restet of chip */
int OV7620_ResetChip(void);

/* Mirror image 1 = Mirrir */
int OV7620_MirrorImage(int iOn);

/* "1" Raw data video output. "0" selects YCrCb */
int OV7620_SetDataModeA(int iOn);

/* "1" enables auto adjust mode. "0" manual mode */
int OV7620_AutoAdjustMode(int iOn);
  

/* Range VGA 1-640;1-480 : Progresive scan */
/* Range VGA 1-640;1-240 : Interlaced scan */
/* Range QVGA 1-320;1-240 : Interlaced/Progresive scan */    
int OV7620_SetActiveWindow(ImageType Pict); 

/* Auto brighness enabled */
int OV7620_AutoBrightnessEnable(int iOn);

/* Banding filter enabled. After adjust frame rate to match indoor frequency */
/* this enables a different exposure algorithm to cut light band introduced */
/* by flouresent light */
int OV7620_BandFilterEnable(int iOn); 

/* Grabb an YUV image, synk. with camera */
/* nValue = GRABB_SYNCHRONOUS, GRABB_ASYNCHRONOUS */
int GrabbImageYUV(ImageType Pict, int nValue); 

/* Grabb an RGB image, synk. with camera */
/* nValue = GRABB_SYNCHRONOUS, GRABB_ASYNCHRONOUS */
int GrabbImageRGB(ImageType Pict, int nValue); 

/* Init Camera - configure camera registers */
int InitCamera(ImageType Pict);

#endif


