/* iic.c */

#include "iic.h"
#include "robotnic.h"
#include "timers.h"

unsigned char CameraReg = 0;


void ResetCamera(void){

	delay_msec(1);
	CAMERA = 0x02;
	delay_msec(1);
	CAMERA = 0x00;  
}

int Write8bit(unsigned char Value){

	int i;
	unsigned char Data;
	
	for(i=0;i<8;i++){
		delay_msec(1);
		Data = (Value<<i) & 0x80;
		Data = Data>>4;
 		CAMERA = CameraReg | Data | CLKLOW;  
 		delay_msec(1);
 		CAMERA = CameraReg | Data | CLKHIGH;
 		delay_msec(1);
 		CAMERA = CameraReg | Data | CLKLOW;		
	}       
	return 0;
}


int Read8bit(unsigned char *Value){

	int i;
	unsigned char Data;
	delay_msec(1);
	CAMERA = CameraReg | CLKLOW | DATAHIGH;
	*Value = 0;
	for(i=7;i>-1;i--){
		delay_msec(1);
 		CAMERA = CameraReg | CLKHIGH | DATAHIGH;
 		Data = (CAMERA & 0x02) >> 1;
		*Value |= (Data << i);  
 		delay_msec(1);
 		CAMERA = CameraReg | CLKLOW | DATAHIGH;		
	}   
	return 0;	
}

unsigned char ReadAck(void){

	unsigned char Ack = 0;
 
 	delay_msec(1);
 	CAMERA = CameraReg | DATAHIGH | CLKHIGH;
 	delay_msec(1);
 	Ack = !(CAMERA & 0x02);
 	CAMERA = CameraReg | DATAHIGH | CLKLOW;  
 	return Ack;	
}

void SendAck(void){
 
 	delay_msec(1);
 	CAMERA = CameraReg | DATALOW | CLKHIGH;
 	delay_msec(1);
 	CAMERA = CameraReg | DATALOW | CLKLOW;	   
}

void SendNAck(void){
	
	delay_msec(1);
 	CAMERA = CameraReg | DATAHIGH | CLKLOW;
 	delay_msec(1);
 	CAMERA = CameraReg | DATAHIGH | CLKHIGH;
 	delay_msec(1);
 	CAMERA = CameraReg | DATAHIGH | CLKLOW;	
 	delay_msec(1);
 	CAMERA = CameraReg | DATALOW | CLKLOW;  
}

void SendStopBit(void){
	 	
 	delay_msec(1);
 	CAMERA = CameraReg | DATALOW | CLKHIGH;
 	delay_msec(1);
 	CAMERA = CameraReg | DATAHIGH | CLKHIGH; 
}

void SendStartBit(void){
	
	delay_msec(1);
	CAMERA = CameraReg | DATAHIGH | CLKHIGH;
	delay_msec(1);
	CAMERA = CameraReg | DATALOW | CLKHIGH;
 	delay_msec(1);
 	CAMERA = CameraReg | DATALOW | CLKLOW; 
}

int SendDataIIC(unsigned char Reg, unsigned char Value){
	
	unsigned char Ack = 0;
	
   SendStartBit();
	Write8bit(0x42);									// defaultadress och skriv
	Ack |= ReadAck();
	Write8bit(Reg);									// Register
	Ack |= ReadAck();
	Write8bit(Value);									// data
	Ack |= ReadAck();
	SendStopBit();  
	return(Ack);	
}

int ReadDataIIC(unsigned char Reg, unsigned char *Value){
	
	unsigned char Ack = 0;
	
   SendStartBit();
	Write8bit(0x42);									// defaultadress och skriv
	Ack |= ReadAck();
	Write8bit(Reg);									// Register
	Ack |= ReadAck();
   SendStopBit();
   SendStartBit();
	Write8bit(0x43);									// defaultadress och läs
	Ack |= ReadAck();
	Read8bit(Value);									// läs data
	SendNAck();
	SendStopBit(); 
	return(Ack);		
}

