/* main.c */
                
#include <c6x.h>
#include "c6211dsk.h"
#include "robotnic.h"
#include "timers.h" 
#include "camera.h" 
 

void ConfigImageType(ImageType *Config){  	/* Configure Image */

   Config->Image = (unsigned int *)0x80050000; 
   Config->Hight = 240;	 
	Config->Width = 320;
	Config->StartVertical = 1;
	Config->StartHorizontal = 1;
	Config->Decimation = 0;         /* 0,2,4,8 */
	Config->Resolution = QVGA;      /* VGA, QVGA*/
	Config->ScanMode = INTERLACED;  /* INTERLACED */
	Config->GrabbMode = GRABB_RGB;  /* GRABB_RGB, GRABB_YUV */
}

void main(void){

	unsigned char AGC_Control;
	signed char BlueGain, RedGain; 
	ImageType PictRGB;

   CSR=0x100;			             /* disable all interrupts            */
   IER=1;                           /* disable all interrupts except NMI */
   ICR=0xffff;                      /* clear all pending interrupts      */
   *(unsigned volatile int *)EMIF_GCR = 0x3300; /* EMIF global control   */
   *(unsigned volatile int *)EMIF_CE0 = 0x30;   /* EMIF CE0 control       */
   *(unsigned volatile int *)EMIF_CE3 = 0x7771c323;   /* EMIF CE3 control*/
   *(unsigned volatile int *)EMIF_CE1 = 0xffffff03; /* EMIF CE1 control, 8bit async */
   *(unsigned volatile int *)EMIF_SDCTRL = 0x07117000; /* EMIF SDRAM control     */
   *(unsigned volatile int *)EMIF_SDRP = 0x61a;       /* EMIF SDRM refresh period */
	*(unsigned volatile int *)EMIF_SDEXT = 0x54519; /* EMIF SDRAM extension    */
	
	/* Hardware Reset */
   ResetCamera();
   
   /* Software Reset */ 
  	OV7620_ResetChip();
  		
	ConfigImageType(&PictRGB);
	/* Init Camera */
	InitCamera(PictRGB);
   
   /* Using Bandfilter for indoor  */	
//    OV7620_BandFilterEnable(1); 
   
   /* Auto Adjust - to use the manual settings this has to be turned off. 
    The camera is by default enabled, 1 = enable, 0 = disable */
   OV7620_AutoAdjustMode(0);   
       
	while(1){    
	/* Set Registers */
   	OV7620_AGCGainControl(AGC_Control); // range [0 255] 
   	OV7620_BlueGainControl(BlueGain);// range [-127 127]
   	OV7620_RedGainControl(RedGain);// range [-127 127]
   /* Choose grabbing format, GRABB_SYNCHRONOUS, GRABB_ASYNCHRONOUS*/   
   	GrabbImageRGB(PictRGB,GRABB_SYNCHRONOUS);    
   /* Read registers */
//  	OV7620_AGCGainControlRead(&AGC_Control);
//  	OV7620_BlueGainControlRead(&BlueGain); 
//  	OV7620_RedGainControlRead(&RedGain);		                                             		                                               
	}
} 
