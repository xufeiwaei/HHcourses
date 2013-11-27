/* iic.h */

#ifndef __IIC_H
#define __IIC_H

extern int ReadDataIIC(unsigned char Reg, unsigned char *Value);
extern int SendDataIIC(unsigned char Reg, unsigned char Value);
extern void ResetCamera(void);

#endif
