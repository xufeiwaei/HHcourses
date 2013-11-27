/* iic.h */

#ifndef __IIC_H
#define __IIC_H

#define CLKLOW		0x00
#define CLKHIGH	0x10
#define DATAHIGH	0x08
#define DATALOW	0x00

/*--------------------ReadDataIIC---------------------------*/
/* Läser Kameraregistrerna via det seriella gränsnittet IIC */
/*	Använder TIMER1														*/
/*	Parametrar: 															*/
/*		unsigned char Reg - vilket register som skall läsas 	*/
/*		unsigned char *Value - det returnerade värdet			*/
/* Returnerar:																*/
/*		0 om Ok																*/
/*		!0 om läsningen inte lyckades									*/
/*----------------------------------------------------------*/
extern int ReadDataIIC(unsigned char Reg, unsigned char *Value);


/*--------------------SendDataIIC---------------------------*/
/* Skriver till kameraregistrerna via det seriella 			*/
/* gränsnittet IIC 														*/			
/*	Använder TIMER1														*/
/*	Parametrar: 															*/
/*		unsigned char Reg - vilket register som skall sättas 	*/
/*		unsigned char Value - värdet									*/
/* Returnerar:																*/
/*		0 om Ok																*/
/*		!0 om skrivningen inte lyckades								*/
/*----------------------------------------------------------*/ 
extern int SendDataIIC(unsigned char Reg, unsigned char Value);


/*--------------------ResetCamera---------------------------*/
/* Hårdvaruresetar kameran												*/
/* Parametrar:																*/
/*		inga																	*/
/* Returnerar:																*/
/*		void																	*/
/*----------------------------------------------------------*/
extern void ResetCamera(void);

#endif
