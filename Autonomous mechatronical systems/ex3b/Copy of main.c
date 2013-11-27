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
int powerOn = 0;
int counter = 0;
int encoderLeft = 0;
unsigned char previousMove = 'X';
int endoderPrevious = 0;

ImageType PictRGB;

void init(void){
	x_first = 0;
	y_first = 0;
	x_last  = 0;
	y_last  = 0;
	x_cen   = 0;
	y_cen   = 0;
	flagtest= 0;
}

void hisclr(){
	int i;
	for(i=0;i<239;i++){
		row[i]=0;
	}
	for(i=0;i<319;i++){
		column[i]=0;
	}

}

void Led1(void){

	//unsigned int temp;
	
	//temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  *(unsigned volatile int *)IO_PORT = 0x0e000000; /* Display 1 on LEDs */
  //	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led2(void){

	//unsigned int temp;
	
	//temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  	    *(unsigned volatile int *)IO_PORT = 0x0D000000; /* Display 2 on LEDs */
 // 	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led3(void){

	//unsigned int temp;
	
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
					
					if(Dist<7000){
						pek[r_index*PictRGB.Width+c_index] = 0x00ffffff;
						row[r_index]++;
						column[c_index]++;
					}
					else
						pek[r_index*PictRGB.Width+c_index] = 0;
					
			}//for2
	}//for1
	}// Function


/*void GetHis(ImageType PictRGB){
	unsigned int r_index,c_index, iRows, iCol;
	unsigned int *pek = (unsigned int *)0x80000000;
  	rh_index = 0;
  	ch_index = 0;
  	iRows = 0;
  	iCol = 0;

  	for(r_index = 0;r_index<PictRGB.Hight;r_index++)
	{
		for(c_index = 0;c_index<PictRGB.Width;c_index++)
		{
		    if(pek[r_index*PictRGB.Width+c_index] == 0x00ffffff){
				rowHis[rh_index]++;
				colHis[ch_index]++;
			}
			ch_index++;
		}//for2
		rh_index++;
		ch_index = 0;
	}//for1
	
	unsigned int x_ant, y_ant;
	for(iRows = 0;iRows<PictRGB.Hight;iRows++)
	{		
		if(rowHis[iRows]>20)
		{
			y_last = iRows;
			if(y_first <= 1)
				y_first = iRows;
		}			
	}
	
	for(iCol = 0;iCol<PictRGB.Width;iCol++)
	{		
		if(rowHis[iCol]>20)
		{
			x_last = iCol;
			if(x_first <= 1)
				x_first = iCol;
		}			
	}
}*/


void GetCen(ImageType PictRGB){
	
	int i,j;
	
	for(i=0;i<=239;i++){
		if((row[i]>10) && (row[i+1]>10) && (row[i+2]>10)){
		   x_first = i;
		   break;
		}	
	}
	for(j=0;j<=319;j++){
		if((column[j]>20) && (column[j+1]>20) && (column[j+2]>20)){
		   y_first = j;
		   break;
		}	
	}
	
	for(i=x_first;i<=239;i++){
		if((row[i]==0) && (row[i+1]==0) && (row[i+1]==0)){
		   x_last = i;
		   break;
		}	
	}
	for(j=y_first;j<=319;j++){
		if((column[j]==0) && (column[j+1]==0) && (column[j+1]==0)){
		   y_last = j;
		   break;
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

void stopMotors(){
    Motor_3(0);
    Motor_4(0);
}

void test(){
	flagtest ++ ;
}

void turn90RightMotor(int sign)
{
	Motor_4(sign*-140);
	delay_msec(900);
	stopMotors();
}

void turn90LeftMotor(int sign)
{
	Motor_3(sign*-140);
	delay_msec(900);
	stopMotors();
}

void moved(){
	
	if((y_cen<=100)&&(y_cen>0)){
		move='R';
	}else if((y_cen>=201)&& (y_cen<=320)){
		move='L';
	} else if((y_cen>=101) && (y_cen<=200)){
		move='M';
	} 
	//move = 'M';

	switch (move)
	{
    	case 'R':  
    		Led1();
		break;
    	case 'L' :  
    		Led3();
        break;
    	default:  
    		Led2();
	}//switch
}

void pushBar()
{
	Motor_0(250);		    
    delay_msec(300);
    Motor_0(-250);
    delay_msec(300);    
    Motor_0(0);
    delay_msec(700);    
}

int analyzePicture()//int push)
{
	int i = 0;
	int itsOne = 0;
	int w = 0;
	int h= 0;
	float ratiowh=0;
	for(i=0;i<3;i++)
	{			
		hisclr();
	//	delay_msec(50);
    	GrabbImageRGB(PictRGB,GRABB_SYNCHRONOUS);  
    //	delay_msec(50);
    	ColorSegment(PictRGB,row,column,60,75,190);
    	GetCen(PictRGB);
    	w = y_last-y_first;
    	h = x_last-x_first;
    	ratiowh = h/w;
    	if(w > 0)
    	{
    		if(ratiowh>2)
    		{	
    			itsOne++;
    			Led2();
    		}	
		}
	}
	//if(push==1)
        if(itsOne>1)
		{
			Led2();
		}
		else
		{
			Led1();
			pushBar();
		}
	
	return itsOne;
}

void moveRobot(int time, int speed1, int speed2)
{	
	Motor_4(speed1);
	Motor_3(speed2);
	delay_msec(time);
	Motor_4(0);
	Motor_3(0);
}

void startingMove(int speed1, int speed2)
{
	Motor_3(speed1+20);
	Motor_4(speed1+20);
	delay_msec(500);
	while(Dig_In_9()==1 || Dig_In_8()==1)
	{
		if(Dig_In_9()==1)
			Motor_3(speed1);
		else
		{			
			Motor_3(0);
			Motor_4(200);
		}
			
		if(Dig_In_8()==1)
			Motor_4(speed1);
		else
		{
			Motor_4(0);
			Motor_3(200);	
		}	
	}
	stopMotors();	
}

void callibrateAgainstWall(int speed1, int speed2)
{
	Motor_3(speed1+20);
	Motor_4(speed1+20);
	delay_msec(500);
	while(Dig_In_9()==1 || Dig_In_8()==1)
	{
		if(Dig_In_9()==1)
			Motor_3(speed1);
		else
		{			
			Motor_3(0);
			Motor_4(200);
		}
			
		if(Dig_In_8()==1)
			Motor_4(speed1);
		else
		{
			Motor_4(0);
			Motor_3(200);	
		}
	}
	stopMotors();		
}

void main(void){

	unsigned char AGC_Control = 150;
	signed char BlueGain = 20; 
	signed char RedGain = -80;
	
	
	int speed1 = 100;//200;
	int speed2 = 100;//180;
	int direction = 1;
	int thisIsOne = 0;
	
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
	
	All_DC_Motor_Off();
	
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
   
   	
  
   	OV7620_AGCGainControl(AGC_Control); // range [0 255] 
	OV7620_BlueGainControl(BlueGain);// range [-127 127]
   	OV7620_RedGainControl(RedGain);// range [-127 127]
	endoderPrevious == 1;
	while(1)
	{
		while(Dig_In_0()==1)
		{}
		Motor_3(250);
		delay_msec(800);
		Motor_3(0);
		while(Dig_In_0()==1)
		{}
		Motor_3(-1250);
		delay_msec(800);
		Motor_3(0);
		/*while(Dig_In_0()==1)
		{}
		Motor_1(100);
		delay_msec(800);
		Motor_1(0);
		while(Dig_In_0()==1)
		{}
		Motor_1(-80);
		delay_msec(500);
		Motor_1(0);*/
		
		
		/*Led1();
		while(Dig_In_0()==1)
		{}
		Servo_0(250);
		Led2();
		while(Dig_In_0()==1)
		Servo_0(0);*/
		/*
		Led2();
		while(encoderLeft<3000)
		{
			Motor_1(250);	
			if(Dig_In_3()==0 && endoderPrevious == 1)
			{	
				endoderPrevious = 0;
				encoderLeft++;
			}
			if(Dig_In_3()==1 && endoderPrevious == 0)
			{	
				endoderPrevious = 1;
				//encoderLeft++;
			}			
		}
		Motor_1(0);	
		encoderLeft=0;*/
	}
	
	while(1)
	{
		stopMotors();		
		while(Dig_In_0()==1)
		{}
		startingMove(speed1, speed2);
		while(Dig_In_0()==1)
		{}
		turn90LeftMotor(1);	
		while(Dig_In_0()==1)
		{}
		callibrateAgainstWall(speed1, speed2);
	}
	
   	while(1){
   		thisIsOne = analyzePicture();
		//if(Dig_In_0()==0)
    	//{
    	//	powerOn = !powerOn;		
		//	delay_msec(500);
		//}
		
		
		
		
		if(thisIsOne > 1)
		{
			y_cen = 0;
			thisIsOne = 0;
		}
		if(y_cen < 10)
		{
			//continueToTheNextBox
			moveRobot(500, direction*speed1,direction*speed2);
		}
		else if(y_cen<120)
		{
			moveRobot(100, direction*speed1,direction*speed2);
			//goLeft
		}
		else if(y_cen>200)
		{
			moveRobot(100, -1*direction*speed1,-1*direction*speed2);
			//goRight
		}
		else
		{
			thisIsOne = analyzePicture();
		}
		
		
		
		//delay_msec(1000);
    	
    	
		
        /*if(Dig_In_0()==0)		
		{
			int i = 0;
			for(i = 0; i<1; i++)
			{	
				hisclr();
				delay_msec(50);
	        	GrabbImageRGB(PictRGB,GRABB_SYNCHRONOUS);  
	        	delay_msec(50);
        	}
	   		//ColorSegment(PictRGB,row,column,38,45,134); //225,157,44
	   		//|51    51   164| 157   126   176 | 40    43    73 | 45 40 50
	   		//GetCen();
	   		//moved();
   		}*/
   		
   		/*if(move == previousMove)
   			counter++;
   		else
   		{
   			counter = 1;
   			previousMove = move;
   		}
   		
   		if(counter>=3)
   		{
   			switch (move)
			{
		    	case 'R':  
		    		turnRight();
				break;
		    	case 'L' :  
		    		turnLeft();
		        break;
		    	default:  
		    		Led2();
			}//switch
   			counter = 0;
   		}*/

    	/*if(Dig_In_0()==0)
    	{
    		Motor_0(200);		    
		    delay_msec(280);
		    Motor_0(-200);
		    delay_msec(280);
		    Motor_0(0);
		}
		
		
		if(powerOn == 0)
		{
			
		}
		
        if(powerOn == 1)
		{
			//Servo_0(150);
			//Servo_0(0);
			//delay_msec(1500);
		    
		    
    		//powerOn = 0;
		   
			//Turning 360
    		//Motor_5(180);
	    	//Motor_4(-150);
	    	////////////
	    	
    		//delay_msec(1400);
    		//All_DC_Motor_Off();
    		//powerOn = 0;
		}*/
		
		/*
		  while(Dig_In_0()==1) {}
		  Motor_5(120);
		  Motor_4(120);
		  delay_msec(500);
		  
		  while(Dig_In_0()==1) {}
		  All_DC_Motor_Off();
		  delay_msec(500);
		  
		  while(Dig_In_0()==1) {}
		  Motor_5(-120);
		  Motor_4(-120);
		  delay_msec(500);
		  
		  while(Dig_In_0()==1) {}
		  All_DC_Motor_Off();
		  delay_msec(500);
		  */
		  
		  
		  /*TURN 360
		  while(Dig_In_0()==1) {}
		  Motor_5(150);
		  Motor_4(-150);
		  delay_msec(2700);
		  All_DC_Motor_Off();*/
    
    
   }// while

} 


