/* robotnic.h */

#ifndef _ROBOTNIC_H
#define _ROBOTNIC_H

/*-------------------definitioner----------------------------*/
#define EXTSRAM 			*(unsigned volatile int *)0xB0080000  // Extern minnesbuffer
#define SERVO_0			*(unsigned volatile int *)0xB0000000
#define SERVO_1			*(unsigned volatile int *)0xB0008000
#define SERVO_2			*(unsigned volatile int *)0xB0010000
#define DCMOTOR			*(unsigned volatile int *)0xB0030000
#define CAMERA				*(unsigned volatile int *)0xB0028000	// CAMERA Address
#define DIG_IO				*(unsigned volatile int *)0xB0020000	// Digitalt IO
#define ADC_CHIP0			*(unsigned volatile int *)0xB0038000
#define ADC_CHIP1			*(unsigned volatile int *)0xB0040000
#define READ_AD_STATUS	*(unsigned volatile int *)0xB0028000

#define DRAM_START 		0x80000000
#define EXT_RAM_START 	0xB0080000

#define MOTORFRAM	0x100
#define MOTORBACK	0x200
#define MOTOR_0	0x1000
#define MOTOR_1	0x2000
#define MOTOR_2	0x400
#define MOTOR_3	0x800
#define MOTOR_4	0x4000
#define MOTOR_5	0x8000

#define START_ADC			0x40
#define ADC_CH_0			0x05
#define ADC_CH_1			0x04
#define ADC_CH_2			0x03
#define ADC_CH_3			0x02
#define ADC_CH_4			0x01
#define ADC_CH_5			0x00
#define ADC_CH_6			0x05
#define ADC_CH_7			0x04
#define ADC_CH_8			0x03
#define ADC_CH_9			0x02
#define ADC_CH_10			0x01
#define ADC_CH_11			0x00

#define ADC_CHIP0_NOT_FINISH 0x04
#define ADC_CHIP1_NOT_FINISH 0x08

#define DIGIN0 0x200
#define DIGIN1 0x100
#define DIGIN2 0x080
#define DIGIN3 0x040
#define DIGIN4 0x020
#define DIGIN5 0x010
#define DIGIN6 0x008
#define DIGIN7 0x004
#define DIGIN8 0x002
#define DIGIN9 0x001

#define DIGOUT0 0x01
#define DIGOUT1 0x02
#define DIGOUT2 0x04
#define DIGOUT3 0x08
#define DIGOUT4 0x10
#define DIGOUT5 0x20
#define DIGOUT6 0x40
#define DIGOUT7 0x80

/*------------------Globala Funktioner-------------------------*/

/*--------------------Dig_In_X---------------------------------*/
/* Läser digitala ingångarna 												*/
/*	Parametrar: 																*/
/*		Inga 																		*/
/* Returnerar:																	*/
/*		0 om TTL nivå 0														*/
/*		1 om TTL nivå 1														*/
/*-------------------------------------------------------------*/
int Dig_In_0(void);
int Dig_In_1(void);
int Dig_In_2(void);
int Dig_In_3(void);
int Dig_In_4(void);
int Dig_In_5(void);
int Dig_In_6(void);
int Dig_In_7(void);
int Dig_In_8(void);
int Dig_In_9(void);

/*--------------------Dig_Out_X--------------------------------*/
/* Skriver till de digitala utgångarna 								*/
/* Använder den globala variabeln DigOut								*/ 
/*	Parametrar: 																*/
/*		int Value - Aktiv spänningsnivå ut om Value != 0			*/
/* Returnerar:																	*/
/*		void																		*/
/*-------------------------------------------------------------*/
void Dig_Out_0(int Value);
void Dig_Out_1(int Value);
void Dig_Out_2(int Value);
void Dig_Out_3(int Value);
void Dig_Out_4(int Value);
void Dig_Out_5(int Value);
void Dig_Out_6(int Value);
void Dig_Out_7(int Value);

/*--------------------Analog_X---------------------------------*/
/* Startar en A/D-omvandling och returnerar det analoga			*/
/* värdet mellan 0.0 och 5.0												*/ 
/*	Parametrar: 																*/
/*		inga																		*/
/* Returnerar:																	*/
/*		float																		*/
/*-------------------------------------------------------------*/
float Analog_0(void);
float Analog_1(void);
float Analog_2(void);
float Analog_3(void);
float Analog_4(void);
float Analog_5(void);
float Analog_6(void);
float Analog_7(void);
float Analog_8(void);
float Analog_9(void);
float Analog_10(void);
float Analog_11(void);

/*--------------------Servo_X----------------------------------*/
/* Skriver till ett 8-bitars register i en PLD vilken 			*/
/* skapar en PWM-signal till servoutgången							*/ 
/*	Parametrar: 																*/
/*		unsigned char Value - Styrvärde skall ligga mellan 0-255	*/
/* Returnerar:																	*/
/*		void																		*/
/*-------------------------------------------------------------*/
void Servo_0(unsigned char Value);
void Servo_1(unsigned char Value);
void Servo_2(unsigned char Value);

/*--------------------Motor_X----------------------------------*/
/* Skriver till ett 8-bitars register i en PLD vilken styr 		*/
/* motorströmmen																*/ 
/*	Parametrar: 																*/
/*		int Value - Styrvärdet skall ligga mellan -255 och 255	*/
/* Returnerar:																	*/
/*		void																		*/
/*-------------------------------------------------------------*/
void Motor_0(int Value);
void Motor_1(int Value);
void Motor_2(int Value);
void Motor_3(int Value);
void Motor_4(int Value);
void Motor_5(int Value);

/*--------------------All_DC_Motor_Off-------------------------*/
/* Nollställer de register i PLD:en vilken styr						*/
/* motorströmmarna															*/ 
/*	Parametrar: 																*/
/*		inga																		*/
/* Returnerar:																	*/
/*		void																		*/
/*-------------------------------------------------------------*/
void All_DC_Motor_Off(void);

/*--------------------Led_X------------------------------------*/
/* Aktiverar lysdioderna på starter-kittet							*/ 
/*	Parametrar: 																*/
/*		inga																		*/
/* Returnerar:																	*/
/*		void																		*/
/*-------------------------------------------------------------*/
void Led_0(void);
void Led_1(void);
void Led_2(void);
void Led_3(void);
void Led_4(void);
void Led_5(void);
void Led_6(void);
void Led_7(void);

/*--------------------Switch2----------------------------------*/
/* Läser mikroströmställarna på starter-kittet						*/
/*	Parametrar: 																*/
/*		Inga 																		*/
/* Returnerar:																	*/
/*		unsigned int - det digital värdet på strömställarna		*/
/*-------------------------------------------------------------*/
unsigned int Switch2(void);

/*------------------Globala Variabler--------------------------*/

/*--------------------DigOut-----------------------------------*/
/* Håller värdet till de digitala utgångarna							*/
/*-------------------------------------------------------------*/
extern unsigned int DigOut;

/*--------------------CameraReg--------------------------------*/
/* Håller värdet till kamera registret									*/
/*-------------------------------------------------------------*/
extern unsigned char CameraReg;

#endif
