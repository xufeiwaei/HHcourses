/* main.c */
                
#include <c6x.h>
#include "c6211dsk.h"
#include "robotnic.h"
#include "timers.h" 
#include "camera.h" 

unsigned int x_first,y_first,x_last,y_last,x_cen,y_cen;
unsigned int rx_first,ry_first,rx_last,ry_last,rx_cen,ry_cen;
unsigned int row[240];
unsigned int column[320];
unsigned int redrow[240];
unsigned int redcolumn[320];
unsigned int totalBlues;
unsigned char rh_index,ch_index,move;
int direction = 0;
int flagtest;
int powerOn = 0;
int counter = 0;
int encoderLeft = 0;
unsigned char previousMove = 'X';
int endoderPrevious = 0;
int barOut=0;
unsigned int prd = 0x400000;

ImageType PictRGB;

/////////////////////////

void Init_Timer0(unsigned int Period){
	prd = Period;
}

void Stop_Timer0(void)
{
	*(unsigned volatile int *)TIMER0_CTRL &= 0xff3f;/* hold the timer        */
}

void Start_Timer0(void)
{
	*(unsigned volatile int *)TIMER0_CTRL &= 0xff3f;/* hold the timer        */
	*(unsigned volatile int *)TIMER0_CTRL |= 0x200; /* use CPU CLK/4         */   
	*(unsigned volatile int *)TIMER0_PRD   = prd; /* set for a period*/
	*(unsigned volatile int *)TIMER0_CTRL |= 0x3C0; /* start the timer       */

	ICR = IFR | 0x4000;
    IER |= 0x4002;             // enable int 14 (timer0) 
    CSR |= 1;
	
	/* enable timer0 int     */
}


interrupt void timer0_isr(void)
{
	barOut = 1;
}

/////////////////////////
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
	totalBlues = 0;
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


void ColorSegment(ImageType PictRGB,unsigned int *row,unsigned int *column, unsigned char R0,unsigned char G0,unsigned char B0)
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
					
					if(Dist<6000){
						pek[r_index*PictRGB.Width+c_index] = 0x00ffffff;
						row[r_index]++;
						column[c_index]++;
						totalBlues++;
					}
					else
						pek[r_index*PictRGB.Width+c_index] = 0;
					
			}//for2
	}//for1
}// Function

void ColorSegmentRed(ImageType PictRGB,unsigned int *row,unsigned int *column, unsigned char R0,unsigned char G0,unsigned char B0)
{
	unsigned char red1,green1,blue1;
	unsigned int r_index1,c_index1,Pixel1,Dist1;
	unsigned int *pek1 = (unsigned int *)0x80010000;
	
	for(r_index1 = 0;r_index1<PictRGB.Hight;r_index1++)
	{
		for(c_index1 = 0;c_index1<PictRGB.Width;c_index1++)
			{
				Pixel1 = PictRGB.Image[r_index1*PictRGB.Width+c_index1];
				blue1 = Pixel1>>16;
				green1 = Pixel1>>8;
				red1 = Pixel1;
				Dist1 = (red1-R0)*(red1-R0)+(green1-G0)*(green1-G0)+(blue1-B0)*(blue1-B0);
					
					if(Dist1<6000){
						pek1[r_index1*PictRGB.Width+c_index1] = 0x00ffffff;
						redrow[r_index1]++;
						redcolumn[c_index1]++;
					}
					else
						pek1[r_index1*PictRGB.Width+c_index1] = 0;
					
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

void GetRedCen(ImageType PictRGB){
	
	int i,j;
	
	for(i=0;i<=239;i++){
		if((redrow[i]>50) && (redrow[i+1]>50) && (redrow[i+2]>50)){
		   rx_first = i;
		   break;
		}	
	}
	for(j=0;j<=319;j++){
		if((redcolumn[j]>50) && (redcolumn[j+1]>50) && (redcolumn[j+2]>50)){
		   y_first = j;
		   break;
		}	
	}
	
	for(i=rx_first;i<=239;i++){
		if((redrow[i]==0) && (redrow[i+1]==0) && (redrow[i+1]==0)){
		   rx_last = i;
		   break;
		}	
	}
	for(j=ry_first;j<=319;j++){
		if((redcolumn[j]>20) && (redcolumn[j+1]>20) && (redcolumn[j+2]>20)){
			y_last = j;
		}
		/*if((column[j]==0) && (column[j+1]==0) && (column[j+1]==0)){
		   y_last = j;
		   break;
		}*/	
	}
	
	if (rx_last<rx_first){
		rx_last=rx_first;
	}
	if (ry_last<ry_first){
		ry_last=ry_first;
	}
	
	rx_cen = (rx_first + rx_last)/2;
	ry_cen = (ry_first + ry_last)/2;	
}

void GetCen(ImageType PictRGB){
	
	int i,j;
	
	for(i=rx_first;i<=rx_last;i++){
		if((row[i]>15) && (row[i+1]>15) && (row[i+2]>15)){
		   x_first = i;
		   break;
		}	
	}
	for(j=ry_first;j<=ry_last;j++){
		if((column[j]>30) && (column[j+1]>30) && (column[j+2]>30)){
		   y_first = j;
		   break;
		}	
	}
	
	for(i=x_first;i<=rx_last;i++){
		if((row[i]==0) && (row[i+1]==0) && (row[i+1]==0)){
		   x_last = i;
		   break;
		}	
	}
	for(j=y_first;j<=ry_last;j++){
		if((column[j]>20) && (column[j+1]>20) && (column[j+2]>20)){
			y_last = j;
		}
		/*if((column[j]==0) && (column[j+1]==0) && (column[j+1]==0)){
		   y_last = j;
		   break;
		}*/	
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
    Motor_0(0);
    Motor_1(0);
    Motor_2(0);
    Motor_3(0);
    Motor_4(0);
    Motor_5(0);
}

void test(){
	flagtest ++ ;
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

void takePushbarIn()
{
	Motor_0(-250);
	while(Dig_In_4()==1)
	{}   
    Motor_0(0); 		        
}
void pushbar()
{		
	Init_Timer0(0x400000);
	barOut = 0;
	Start_Timer0();
	Motor_0(250);
	while(Dig_In_1()==1 && barOut==0)
	{}  
	Stop_Timer0();		    
    delay_msec(75);
    //while(Dig_In_3()==1)
	//{} 
    takePushbarIn();	        
}

void takePushbarOut()
{
	Motor_0(250);
	//while(Dig_In_2()==1)
	//{}  
	delay_msec(190);
	stopMotors();
	delay_msec(50);	    	        
}

void takePushbarOutALittle()
{
	Motor_0(250);
	//while(Dig_In_2()==1)
	//{}  
	delay_msec(50);
	stopMotors();
	delay_msec(50);	    	        
}

int checkDistance(int close, int far)
{
	int haveToFixDistance = 0;
	takePushbarOutALittle();
	if(Dig_In_1()==1 && close)
		haveToFixDistance = 1;
	else if(far)
	{
		takePushbarIn();
		takePushbarOut();
		if(Dig_In_1()==1)
			haveToFixDistance = 1;			
	}
	takePushbarIn();
	
	return haveToFixDistance;
}

void analyzeRed()
{
	int i = 0;
	//	delay_msec(50);
    	GrabbImageRGB(PictRGB,GRABB_SYNCHRONOUS);  
    //	delay_msec(50);
    	//ColorSegment(PictRGB,row,column,60,75,190);

}

int analyzePicture(int color)
{
	int i = 0;
	int itsOne = 0;
	int w = 0;
	int h= 0;
	float ratiowh=0;
	for(i=0;i<4;i++)
	{			
		hisclr();
	//	delay_msec(50);
    	GrabbImageRGB(PictRGB,GRABB_SYNCHRONOUS);  
    //	delay_msec(50);
    	//ColorSegment(PictRGB,row,column,60,75,190);
    	if(color==0)
    	 	ColorSegment(PictRGB,row,column,70,100,180);
    		ColorSegmentRed(PictRGB,row,column,70,100,180);
    	else
    		ColorSegment(PictRGB,row,column,55,60,140);
    	    ColorSegmentRed(PictRGB,row,column,70,100,180);//need change to red RGB value

    	//ColorSegment(PictRGB,row,column,45,50,100);
        GetRedCen(PictRGB);
    	GetCen(PictRGB);
    	w = y_last-y_first;
    	h = x_last-x_first;
    	ratiowh = (1.0*h)/(1.0*w);
    	if(w > 0)
    	{
    		if(ratiowh>1.9)
    		{	
    			itsOne++;
    			Led2();
    		}	
		}
	}	
	
	if(itsOne>2)
		itsOne=1;
	else
		itsOne=0;
	return itsOne;
}

void liftBigCar()
{
	Motor_1(237);
	while(Dig_In_9()==0)
	{}
	delay_msec(100);
	Motor_1(30);
}

void putDownBigCar()
{
	Motor_1(-80);
	//while(Dig_In_8()==1)
	//{}
	delay_msec(700);
	Motor_1(0);
}

void moveForward(int speed)
{
	Motor_3(-1*speed);
}

void moveBackwards(int speed)
{
	Motor_3(speed);
}

void moveLeft(int speed)
{
	Motor_2(-1*speed);
}

void moveRight(int speed)
{
	Motor_2(speed);
}

void checkDirection()
{
	if(Dig_In_7()==0)
		direction=-1;
	else if(Dig_In_2()==0)
		direction=1;
}

void continueMoving(int speed)
{
	if(direction==1)
	{
		moveRight(speed);
	}
	else if(direction==-1)
	{
		moveLeft(speed);
	}
	checkDirection();
}

void fixDistance(int goBackwards)
{
	int notCentered = 1;
	
	if(goBackwards)
	{
		liftBigCar();
		delay_msec(200);
		moveBackwards(200);
		delay_msec(500);
		stopMotors();		
		delay_msec(50);
		putDownBigCar();
	}
	
	while(notCentered)
	{
		analyzePicture(0);
		if(y_cen<140)
		{
			moveLeft(100);
			delay_msec(150);
			stopMotors();
			//goLeft a little bit
		}
		else if(y_cen>180)
		{
			moveRight(100);
			delay_msec(150);
			stopMotors();
			//goRight  a little bit
		}
		else
		{
			notCentered = 0;
		}
	}
	delay_msec(500);
	takePushbarOut();
	liftBigCar();
	delay_msec(500);
	moveForward(200);
	while(Dig_In_1()==1)
	{}
	delay_msec(50);
	stopMotors();
	delay_msec(500);
	takePushbarIn();
	delay_msec(500);
	putDownBigCar();
		
}

void main(void){

	unsigned char AGC_Control = 150;
	signed char BlueGain = 20; 
	signed char RedGain = -80;
	
	
	int speed = 100;//200;	
	int thisIsOne = 0;
	
	init();
	
   CSR=0x100;			             /* disable all interrupts            */
   IER=1;                           /* disable all interrupts except NMI */
   ICR=0xffff;                      /* clear all pending interrupts      */
   *(unsigned volatile int *)EMIF_GCR = 0x3300; /* EMIF global control   */
   *(unsigned volatile int *)EMIF_CE0 = 0x30;   /* EMIF CE0 control       */
   *(unsigned volatile int *)EMIF_CE3 = 0x77f3c523;//0x7771c323;   /* EMIF CE3 control*/
   *(unsigned volatile int *)EMIF_CE1 = CE1_32;//0xffffff03; /* EMIF CE1 control, 8bit async */
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

	direction = 1;	
	
	while(1)
	{
		while(Dig_In_0()==1)
		{}	
		Led_1();
		fixDistance(0);	
		while(1)
		{
		
			thisIsOne = analyzePicture(1);
			delay_msec(200);
			if(totalBlues < 1500)
			{
				continueMoving(speed);
				delay_msec(400);
				stopMotors();
				Led_3();
			}
			else if(y_cen<120 && Dig_In_7()==1)
			{
				moveLeft(100);
				delay_msec(150);
				stopMotors();
				//goLeft a little bit
			}
			else if(y_cen>200  && Dig_In_7()==1)
			{
				moveRight(100);
				delay_msec(150);
				stopMotors();
				//goRight  a little bit
			}
			else
			{
				thisIsOne = analyzePicture(1);
				if(thisIsOne == 1)
				{
					continueMoving(speed);
					delay_msec(800);
					stopMotors();
				}
				else
				{
					Led1();
					pushbar();
					delay_msec(500);
				}
					
			}
			checkDirection();
		}
	}
} 


