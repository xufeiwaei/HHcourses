/* main.c */
                
#include <c6x.h>
#include "c6211dsk.h"
#include "robotnic.h"
#include "timers.h" 
#include "camera.h" 

unsigned int x_first,y_first,x_last,y_last,x_cen,y_cen;
unsigned int row[240];
unsigned int column[320];
unsigned char rh_index,ch_index,move;
int flagtest;

void init(void){
	x_first = 0;
	y_first = 0;
	x_last  = 0;
	y_last  = 0;
	x_cen   = 0;
	y_cen   = 0;
	flagtest= 0;
}

void hisclr(void){
	int i;
	for(i=0;i<239;i++){
		row[i]=0;
	}
	for(i=0;i<319;i++){
		column[i]=0;
	}
}

void Led1(void){

	unsigned int temp;
	
	//temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  *(unsigned volatile int *)IO_PORT = 0x0e000000; /* Display 1 on LEDs */
  //	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led2(void){

	unsigned int temp;
	
	//temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  	    *(unsigned volatile int *)IO_PORT = 0x0D000000; /* Display 2 on LEDs */
 // 	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led3(void){

	unsigned int temp;
	
	//temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
 *(unsigned volatile int *)IO_PORT = 0x0B000000; /* Display 4 on LEDs */
  //	*(unsigned volatile int *)EMIF_CE1 = temp;
}


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


void ColorSegment(ImageType PictRGB,unsigned int *row,unsigned int *column,unsigned char R0,unsigned char G0,unsigned char B0)
{
	unsigned char red,green,blue;
	unsigned int r_index,c_index,Pixel,Dist;
	unsigned int *pek = (unsigned int *)0x80000000;
	
	for(r_index = 0;r_index<PictRGB.Hight;r_index++)
	{
		for(c_index = 0;c_index<PictRGB.Width;c_index++)
			{
				Pixel = PictRGB.Image[r_index*PictRGB.Width+c_index];
				blue = Pixel>>16;
				green = Pixel>>8;
				red = Pixel;
				Dist = (red-R0)*(red-R0)+(green-G0)*(green-G0)+(blue-B0)*(blue-B0);
					
					if(Dist<500){
						pek[r_index*PictRGB.Width+c_index] = 0x00ffffff;
						row[r_index]++;
						column[c_index]++;
						}else
							pek[r_index*PictRGB.Width+c_index] = 0;
					
			}//for2
	}//for1
}// Function

void GetCen(){
	
	int i,j;
	//here, I think the value to decide we have found the color we want is too small, we should increase the value
	for(i=0;i<=239;i++){
		if((row[i]>2) && (row[i+1]>2) && (row[i+2]>2)){
		   x_first = i;
		   i = 250;   // here why?
		}	
	}
	for(j=0;j<=319;j++){
		if((column[j]>2) && (column[j+1]>2) && (column[j+2]>2)){
		   y_first = j;
		   j = 370;
		}	
	}
	//here, I don't think the value 0 can judge the object is finish exactly, 
	//because there will be some error just like the shadow of the margin of the box, we can see it
	//when the light is dark, the camera will regard the blue as the similar value as the margin of the box
	for(i=x_first;i<=239;i++){
		if((row[i]==0) && (row[i+1]==0) && (row[i+1]==0)){
		   x_last = i;
		   i = 250;
		}	
	}
		for(j=y_first;j<=319;j++){
		if((column[j]==0) && (column[j+1]==0) && (column[j+1]==0)){
		   y_last = j;
		   j = 370;
		}	
	}
	
	if (x_last<x_first){
		x_last=x_first;
	}
		if (y_last<y_first){
		y_last=y_first;
	}
	
	x_cen = (x_first + x_last)/2;
	y_cen = (y_first + y_last)/2;	
}

void moved(){
	
	if(y_cen<=120){
		move='R'; 
	}else if(y_cen>=200){
		move='L';
	} else if((y_cen>=121) && (y_cen<=199)){
		move='M';
	} 
	//move = 'M';

	switch (move)
	{
    	case 'R':  Led1();
		break;
    	case 'L' :  Led3();
        break;
    	default:  Led2();
	}//switch
}

void wheel_left(){
	Motor_0(-95);
    Motor_1(87);
}
void wheel_right(){
    Motor_0(68);
    Motor_1(-73);
}
void wheel_stop(){
    Motor_0(0);
    Motor_1(0);
}

void wheel(){

	switch (move)
	{
    	case 'R':  wheel_left();
    	break;
    	case 'L' : wheel_right();
        break;
    	default:  wheel_stop();
	}//switch
    delay_msec(150);
    wheel_stop();
    delay_msec(275);
}

void main(void){

	unsigned char AGC_Control = 150;
	signed char BlueGain = 20;  
	signed char RedGain = -80;
	ImageType PictRGB;
	
	init();
	
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
   
   All_DC_Motor_Off();
  
	
	   	
   while(1){
    
	   while(Dig_In_0()==0) {}
	   Motor_5(150);
	   Motor_4(150);
	   delay_msec(1000);
	   
	   while(Dig_In_0()==0) {}
	   All_DC_Motor_Off();
	   delay_msec(1000);
	   
	   while(Dig_In_0()==0) {}
	   Motor_5(-150);
	   Motor_4(-150);
	   delay_msec(1000);
	   
	   while(Dig_In_0()==0) {}
	   All_DC_Motor_Off();
	   delay_msec(1000);
	   
	   while(Dig_In_0()==0) {}
	   Motor_5(150);
	   Motor_4(-150);
	   delay_msec(1000);
    
	   while(Dig_In_0()==0) {}
	   All_DC_Motor_Off();
	   delay_msec(1000);
   }// while
      
	while(0){   
		hisclr();
		/* Set Registers */
	
		delay_msec(500);
		OV7620_AGCGainControl(AGC_Control); // range [0 255] 
	    OV7620_BlueGainControl(BlueGain);// range [-127 127]
	    OV7620_RedGainControl(RedGain);// range [-127 127]

	   /* Choose grabbing format, GRABB_SYNCHRONOUS, GRABB_ASYNCHRONOUS*/   
	   	GrabbImageRGB(PictRGB,GRABB_SYNCHRONOUS);   
	   	ColorSegment(PictRGB,row,column,36,44,63); //|51    51   164| 157   126   176 | 40    43    73 | 45 40 50
	   	GetCen();
	   	moved();
	   	wheel();
	   	test();
	   /* Read registers */
		//OV7620_AGCGainControlRead(&AGC_Control);
		//OV7620_BlueGainControlRead(&BlueGain); 
		//OV7620_RedGainControlRead(&RedGain);		                                             		                                               
	}
} 
