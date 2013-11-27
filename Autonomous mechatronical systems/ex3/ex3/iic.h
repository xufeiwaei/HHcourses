/* iic.h */

#ifndef __IIC_H
#define __IIC_H

#define CLKLOW		0x00
#define CLKHIGH	0x10
#define DATAHIGH	0x08
#define DATALOW	0x00

/*--------------------ReadDataIIC---------------------------*/
/* L�ser Kameraregistrerna via det seriella gr�nsnittet IIC */
/*	Anv�nder TIMER1														*/
/*	Parametrar: 															*/
/*		unsigned char Reg - vilket register som skall l�sas 	*/
/*		unsigned char *Value - det returnerade v�rdet			*/
/* Returnerar:																*/
/*		0 om Ok																*/
/*		!0 om l�sningen inte lyckades									*/
/*----------------------------------------------------------*/
extern int ReadDataIIC(unsigned char Reg, unsigned char *Value);


/*--------------------SendDataIIC---------------------------*/
/* Skriver till kameraregistrerna via det seriella 			*/
/* gr�nsnittet IIC 														*/			
/*	Anv�nder TIMER1														*/
/*	Parametrar: 															*/
/*		unsigned char Reg - vilket register som skall s�ttas 	*/
/*		unsigned char Value - v�rdet									*/
/* Returnerar:																*/
/*		0 om Ok																*/
/*		!0 om skrivningen inte lyckades								*/
/*----------------------------------------------------------*/ 
extern int SendDataIIC(unsigned char Reg, unsigned char Value);


/*--------------------ResetCamera---------------------------*/
/* H�rdvaruresetar kameran												*/
/* Parametrar:																*/
/*		inga																	*/
/* Returnerar:																*/
/*		void																	*/
/*----------------------------------------------------------*/
extern void ResetCamera(void);

#endif
