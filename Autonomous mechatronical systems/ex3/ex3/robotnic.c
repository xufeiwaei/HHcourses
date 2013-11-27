/*--------------Robotnic.c---------------------*/

#include "robotnic.h"
#include "c6211dsk.h"

unsigned int DigOut = 0;

int Dig_In_0(void){
	if(DIG_IO & DIGIN0) return(1);
	else return(0);
}
int Dig_In_1(void){
	if(DIG_IO & DIGIN1) return(1);
	else return(0);
}
int Dig_In_2(void){
	if(DIG_IO & DIGIN2) return(1);
	else return(0);
}
int Dig_In_3(void){
	if(DIG_IO & DIGIN3) return(1);
	else return(0);
}
int Dig_In_4(void){
	if(DIG_IO & DIGIN4) return(1);
	else return(0);
}
int Dig_In_5(void){
	if(DIG_IO & DIGIN5) return(1);
	else return(0);
}
int Dig_In_6(void){
	if(DIG_IO & DIGIN6) return(1);
	else return(0);
}
int Dig_In_7(void){
	if(DIG_IO & DIGIN7) return(1);
	else return(0);
}
int Dig_In_8(void){
	if(DIG_IO & DIGIN8) return(1);
	else return(0);
}
int Dig_In_9(void){
	if(DIG_IO & DIGIN9) return(1);
	else return(0);
}

void Dig_Out_0(int Value){
	if(Value){ 
		DigOut |= DIGOUT0;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT0;
		DIG_IO = DigOut;
	}
}

void Dig_Out_1(int Value){

	if(Value){
		DigOut |= DIGOUT1;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT1;
		DIG_IO = DigOut;
	}
}

void Dig_Out_2(int Value){
	if(Value){ 
		DigOut |= DIGOUT2;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT2;
		DIG_IO = DigOut;
	}
}

void Dig_Out_3(int Value){

	if(Value){
		DigOut |= DIGOUT3;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT3;
		DIG_IO = DigOut;
	}
}

void Dig_Out_4(int Value){
	if(Value){ 
		DigOut |= DIGOUT4;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT4;
		DIG_IO = DigOut;
	}
}

void Dig_Out_5(int Value){

	if(Value){
		DigOut |= DIGOUT5;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT5;
		DIG_IO = DigOut;
	}
}

void Dig_Out_6(int Value){
	if(Value){ 
		DigOut |= DIGOUT6;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT6;
		DIG_IO = DigOut;
	}
}

void Dig_Out_7(int Value){

	if(Value){
		DigOut |= DIGOUT7;
		DIG_IO = DigOut;
	}
	else{
		DigOut &= ~DIGOUT7;
		DIG_IO = DigOut;
	}
}

float Analog_0(void){

	ADC_CHIP0 = START_ADC | ADC_CH_0;
   while(READ_AD_STATUS & ADC_CHIP0_NOT_FINISH);
	return (float)(ADC_CHIP0 & 0xFFF) * 5.0/4096.0;
}

float Analog_1(void){

	ADC_CHIP0 = START_ADC | ADC_CH_1;
   while(READ_AD_STATUS & ADC_CHIP0_NOT_FINISH);
	return (float)(ADC_CHIP0 & 0xFFF) * 5.0/4096.0;
}

float Analog_2(void){

	ADC_CHIP0 = START_ADC | ADC_CH_2;
   while(READ_AD_STATUS & ADC_CHIP0_NOT_FINISH);
	return (float)(ADC_CHIP0 & 0xFFF) * 5.0/4096.0;
}

float Analog_3(void){

	ADC_CHIP0 = START_ADC | ADC_CH_3;
   while(READ_AD_STATUS & ADC_CHIP0_NOT_FINISH);
	return (float)(ADC_CHIP0 & 0xFFF) * 5.0/4096.0;
}

float Analog_4(void){

	ADC_CHIP0 = START_ADC | ADC_CH_4;
   while(READ_AD_STATUS & ADC_CHIP0_NOT_FINISH);
	return (float)(ADC_CHIP0 & 0xFFF) * 5.0/4096.0;
}

float Analog_5(void){

	ADC_CHIP0 = START_ADC | ADC_CH_5;
   while(READ_AD_STATUS & ADC_CHIP0_NOT_FINISH);
	return (float)(ADC_CHIP0 & 0xFFF) * 5.0/4096.0;
}

float Analog_6(void){

	ADC_CHIP1 = START_ADC | ADC_CH_6;
   while(READ_AD_STATUS & ADC_CHIP1_NOT_FINISH);
	return (float)(ADC_CHIP1 & 0xFFF) * 5.0/4096.0;
}

float Analog_7(void){

	ADC_CHIP1 = START_ADC | ADC_CH_7;
   while(READ_AD_STATUS & ADC_CHIP1_NOT_FINISH);
	return (float)(ADC_CHIP1 & 0xFFF) * 5.0/4096.0;
}

float Analog_8(void){

	ADC_CHIP1 = START_ADC | ADC_CH_1;
   while(READ_AD_STATUS & ADC_CHIP1_NOT_FINISH);
	return (float)(ADC_CHIP1 & 0xFFF) * 5.0/4096.0;
}

float Analog_9(void){

	ADC_CHIP1 = START_ADC | ADC_CH_9;
   while(READ_AD_STATUS & ADC_CHIP1_NOT_FINISH);
	return (float)(ADC_CHIP1 & 0xFFF) * 5.0/4096.0;
}

float Analog_10(void){

	ADC_CHIP1 = START_ADC | ADC_CH_10;
   while(READ_AD_STATUS & ADC_CHIP1_NOT_FINISH);
	return (float)(ADC_CHIP1 & 0xFFF) * 5.0/4096.0;
}

float Analog_11(void){

	ADC_CHIP1 = START_ADC | ADC_CH_11;
   while(READ_AD_STATUS & ADC_CHIP1_NOT_FINISH);
	return (float)(ADC_CHIP1 & 0xFFF) * 5.0/4096.0;
}

void Servo_0(unsigned char Value){

	SERVO_0 = Value;
}

void Servo_1(unsigned char Value){

	SERVO_1 = Value;
}

void Servo_2(unsigned char Value){

	SERVO_2 = Value;
}

void Motor_0(int Value){

	if(Value > 255)
		Value = 255;
	if(Value < -255)
		Value = -255;
	if(Value >= 0)
		DCMOTOR = Value | MOTOR_0 | MOTORFRAM;
	else
		DCMOTOR = -Value | MOTOR_0 | MOTORBACK; 
}

void Motor_1(int Value){

	if(Value > 255)
		Value = 255;
	if(Value < -255)
		Value = -255;
	if(Value >= 0)
		DCMOTOR = Value | MOTOR_1 | MOTORFRAM;
	else
		DCMOTOR = -Value | MOTOR_1 | MOTORBACK; 
}

void Motor_2(int Value){

	if(Value > 255)
		Value = 255;
	if(Value < -255)
		Value = -255;
	if(Value >= 0)
		DCMOTOR = Value | MOTOR_2 | MOTORFRAM;
	else
		DCMOTOR = -Value | MOTOR_2 | MOTORBACK; 
}

void Motor_3(int Value){

	if(Value > 255)
		Value = 255;
	if(Value < -255)
		Value = -255;
	if(Value >= 0)
		DCMOTOR = Value | MOTOR_3 | MOTORFRAM;
	else
		DCMOTOR = -Value | MOTOR_3 | MOTORBACK; 
}

void Motor_4(int Value){

	if(Value > 255)
		Value = 255;
	if(Value < -255)
		Value = -255;
	if(Value >= 0)
		DCMOTOR = Value | MOTOR_4 | MOTORFRAM;
	else
		DCMOTOR = -Value | MOTOR_4 | MOTORBACK; 
}

void Motor_5(int Value){

	if(Value > 255)
		Value = 255;
	if(Value < -255)
		Value = -255;
	if(Value >= 0)
		DCMOTOR = Value | MOTOR_5 | MOTORFRAM;
	else
		DCMOTOR = -Value | MOTOR_5 | MOTORBACK; 
}

void All_DC_Motor_Off(void){

   DCMOTOR = MOTOR_0 | MOTOR_1 | MOTOR_2 | MOTOR_3 | MOTOR_4 | MOTOR_5;
}

void Led_0(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  	*(unsigned volatile int *)IO_PORT = 0x07000000; /* Turn off all user LEDs*/
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_1(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  *(unsigned volatile int *)IO_PORT = 0x0e000000; /* Display 1 on LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_2(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  	*(unsigned volatile int *)IO_PORT = 0x0D000000; /* Display 2 on LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_3(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
   *(unsigned volatile int *)IO_PORT = 0x0C000000; /* Display 3 on LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_4(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
   *(unsigned volatile int *)IO_PORT = 0x0B000000; /* Display 4 on LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_5(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
   *(unsigned volatile int *)IO_PORT = 0x0A000000; /* Display 5 on LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_6(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
   *(unsigned volatile int *)IO_PORT = 0x09000000; /* Display 6 on LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

void Led_7(void){

	unsigned int temp;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  	*(unsigned volatile int *)IO_PORT = 0x0;        /* Turn on all user LEDs */
  	*(unsigned volatile int *)EMIF_CE1 = temp;
}

unsigned int Switch2(void){

	unsigned int temp, Switch_Value;
	
	temp = *(unsigned volatile int *)EMIF_CE1;
  	*(unsigned volatile int *)EMIF_CE1 = CE1_32;    /* EMIF CE1 control, 32bit  */
  	Switch_Value = *(unsigned volatile int *)IO_PORT;
  	*(unsigned volatile int *)EMIF_CE1 = temp;
  	return((Switch_Value & 0x7000000)>>24);
}
