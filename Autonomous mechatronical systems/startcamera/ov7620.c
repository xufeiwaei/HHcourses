/* Interface routines for Omnivision OV7620 Single-Chip Cmos VGA Color Digital Camera */
/* Author : Bjorn Astrand, Halmstad University */
#include "ov7620.h"
#include "iic.h"
#include "c:\\ti\\c6000\\imglib\\include\\pix_sat.h"
#include "camera.h"
#include "robotnic.h"

/* Chip ID set by pin CS<2:0> page 26 section 1.13 */
#define CHIP_ID_WRITE			0x42
#define CHIP_ID_READ			0x43

/* Declaration of functions *************************************/ 

/* Reads a register */
int OV7620_ReadRegister(unsigned char reg, unsigned char *value);

/* Write to a register */
int OV7620_WriteRegister(unsigned char reg, unsigned char value); 

/* Set saturation Control for UV channel */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_SaturationControl(signed char scGain);  

/* White balance background control -- Blue channel */
/* <4:0> value <5> Sign bit 0 = "increase", 1 = decrease  */
/* range -31:+31 */
int OV7620_WhiteBalanceBackgrdCtrlBlueCh(signed char scGain); 

/* White balance background control -- Red channel */
/* <4:0> value <5> Sign bit 0 = "increase", 1 = decrease  */
/* range -31:+31 */
int OV7620_WhiteBalanceBackgrdCtrlRedCh(signed char scGain);

/* Enable testpattern 1 = enable */
int OV7620_TestPattern(int iOn); 

/* "1" Raw data video output. "0" selects YCrCb */
int OV7620_SetDataModeA(int iOn);

/* Enables eight bit output */ 
int OV7620_EightBitOutput(int iOn); 

/* Enables CCIR656 */
int OV7620_EnableCCIR656(int iOn); 

/* QVGA format selection. "1" 320x240, "0" 640x480 */
int OV7620_QVGA(int iOn);

/* RGB gamma selection. "1" gamma on - value reg[62]. "0" gamma = 1 linear */
int OV7620_Gamma(int iOn);

/* PCLK polarity selection  */ 
int OV7620_PCLKPolaritySelection(int iOn); 

/* Check Manufacture ID */
int OV7620_CheckManufactureID(void); 

/* AWB smart mode enable. Valid only if [13,0]=2 and[12,2]=1*/
int OV7620_AWBSmartModeEnable(int iOn); 

/* "1" AWB fast mode */
int OV7620_AWBFastModeEnable(int iOn);  

/* Y channel offset Adjustment */
int OV7620_YChannelOffsetAdjustment(signed char scGain);

/* "1" AD blacl level calibration */
int OV7620_ADBlackLevelCalibrationEnable(int iOn);

/* "1" Enables manual adjustment of A/D */ 
int OV7620_ManualAdjustmentADOffset(int iOn);

/* Adjust frame rate */
/* Frame rate adjustment resolution is 0.12% The control word is 10 bit */
/* Every count decreases frame rate by 0.12% Range is 0.12% - 112 % */
/* [2A]<6:5> High bits and [2B]<7:0> low bits */
/* Range 0 - 1023 (0-0x3FF) */
int OV7620_AdjustFrameRate(int iEnable, int iFrameRate); 

/* Enable progresive scan */
int OV7620_ProgresiveScanMode(int iOn);

/* "1" Y=GGGG, UV=BRBR, "0" Y=GRGR, UV=BGBG */
int OV7620_RawDataOutputFormat(int iOn);

/* "1" Freeze AEG/AGC value. Effektive only if [13,0]=1 */
int OV7620_FreezeAEGandAGCValue(int iOn);   

/* "1" Disable AGC */
int OV7620_AGCDisable(int iOn);

/* "1" AEC Disable if [13,0]=1 and [10] value is held, else update internaly*/ 
int OV7620_AECDisable(int iOn); 

/* Central weighted exposure control */
int OV7620_CentralWeightedExposureControl(int iOn);

/* "1" QVGA 60 frames/s Odd field only. "0" QVGA 30 frames/s Odd/Even field	*/
int OV7620_QVGAFrameSelection(int iOn);  

/* Gated PCLK by Href */
int OV7620_GatedPCLKWithHREF(int iOn);

/* Returns 0 for B/W camera and 7 for color */
int OV7620_CheckCameraChipType(unsigned char *temp); 

/* Set Raw data mode 0 = raw data 1 = YUV */
int OV7620_SetDataModeB(int iOn); 

/* RGB Gamma Control */
/* RGM<7:1> raw data or UV gamma curve selection */
/* Gamma value set to 0 - 127 */
int OV7620_RGBGammaControl(int iOn, int value); 

/* Y Gamma control */ 
/* YGM<7:1> Gamma curve selection */
/* "1" = enable. "0" = disable(linear) */
int OV7620_YGammaControl(int iOn, int value);

/* AWB Process control */
/* White balance function - YUV matrix control */
/* Register [74]<7> must be enabled */
/* Smart AWB ignores RGB raw data abowe or below treshold */
/* AWBC_ABOWE_70	0x00 */
/* AWBC_ABOWE_80	0x40 */
/* AWBC_ABOWE_90	0x80 */
/* AWBC_ABOWE_10	0xC0 */
/* AWBC_BELOW_10	0x00 */
/* AWBC_BELOW_20	0x10 */
/* AWBC_BELOW_30	0x20 */
/* AWBC_BELOW_40	0x30 */
/* Example call OV7620_WhiteBalanceLimitingRGB(1, AWBC_ABOWE_90 | AWBC_BELOW_10)*/
int OV7620_WhiteBalanceLimitingRGB(int iOn, int value); 

/* Color Space selection */
/* YUV_YUV				0x00 */
/* YUV_ANALOG_YUV		0x40 */
/* YUV_CCIR_601_YCrCb	0x80 */
/* YUV_PAL_YUV			0xC0 */
int OV7620_ColorSpaceSelection(int value); 

/* Specific camera grabbing funktions */ 
int yuv2rgb_2(int uy, int vy, unsigned char *pixlar);

/* Grabb an image, synk. with camera */
int GrabbImageRGBviaYUV(ImageType Pict, int nValue);  

/* Converts an YUV-Image to a RGB-image    */
/* Format(unsigned int) : [xVUY] -> [xBGR] */ 
int yuv2rgb(ImageType Pict);

/* Converts an RGB-Image to a YUV-image */
/* Format(unsigned int) : [xBGR] -> [xVUY] */ 
int rgb2yuv(ImageType Pict);


/* Functions *****************************************************/

/* Reads a register */
int OV7620_ReadRegister(unsigned char reg, unsigned char *value){
	/* Read reg data via I2C-bus */
	ReadDataIIC(reg, value);
	return OK;
}  

/* Write to a register */
int OV7620_WriteRegister(unsigned char reg, unsigned char value){
	/* write reg data via I2C-bus */
	SendDataIIC(reg, value);
	return OK;
}

/* Set AGC gain control */
/* Gain formula is Gain = (<3:0>/16+1)*(<4>+1)*(<5>+1); */
/* Range (1x-7.75x), <4>, <5> control SA2 */
int OV7620_AGCGainControl(unsigned char ucGain){
	OV7620_WriteRegister(AGC_GAIN_CONTROL_REG, ucGain);  
	return OK;
}

/* Read AGC gain control */
int OV7620_AGCGainControlRead(unsigned char *ucGain){
	unsigned char temp;
	OV7620_ReadRegister(AGC_GAIN_CONTROL_REG, &temp);
	*ucGain = temp & 0x3F;  
	return OK;
}

/* Set Blue Gain Control for white balanse */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_BlueGainControl(signed char scGain){
	unsigned char temp;
	if (scGain<0)  temp = (scGain & 0x7F);//0xFF - scGain + 1;
	else temp = (scGain & 0x7F) + 0x80;
	OV7620_WriteRegister(BLUE_GAIN_CONTROL_REG, temp); 
	return OK;
} 

/* Read Blue Gain Control for white balanse */
int OV7620_BlueGainControlRead(signed char *scGain){
	unsigned char temp; 
	OV7620_ReadRegister(BLUE_GAIN_CONTROL_REG, &temp); 
	*scGain = (temp+0x80)&0xFF; 
	return OK;
}

/* Set Red Gain Control for white balanse */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_RedGainControl(signed char scGain){
	unsigned char temp;
	if (scGain<0)  temp = (scGain & 0x7F);//0xFF - scGain + 1;
	else temp = (scGain & 0x7F) + 0x80;
	OV7620_WriteRegister(RED_GAIN_CONTROL_REG, temp);
	return OK;
} 

/* Read Red Gain Control for white balanse */
int OV7620_RedGainControlRead(signed char *scGain){
	unsigned char temp;
	OV7620_ReadRegister(RED_GAIN_CONTROL_REG, &temp);
	*scGain = (temp+0x80)&0xFF;
	return OK;
}

/* Set saturation Control for UV channel */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_SaturationControl(signed char scGain){
	unsigned char temp;
	if (scGain<0)  temp = (scGain & 0x7F);//0xFF - scGain + 1;
	else temp = (scGain & 0x7F) + 0x80; 
	OV7620_WriteRegister(SATURATION_CONTROL_REG, temp); 
	return OK;
}

/* Set brightness Control for Y/RGB channel */
/* <6:0> value <7> Sign bit 1 = "increase", 0 = decrease  */
/* range -127:+127 */
int OV7620_BrightnessControl(signed char scGain){
	unsigned char temp;
	if (scGain<0)  temp = (scGain & 0x7F);//0xFF - scGain + 1;
	else temp = (scGain & 0x7F) + 0x80; 
	OV7620_WriteRegister(BRIGHTNESS_CONTROL_REG, temp);   
	return OK;
} 

/* Read brightness Control for Y/RGB channel */
int OV7620_BrightnessControlRead(signed char *scGain){
	unsigned char temp;
	OV7620_ReadRegister(BRIGHTNESS_CONTROL_REG, &temp);   
	*scGain = (temp+0x80)&0xFF;
	return OK;	
}
 
/* White balance background control -- Blue channel */
/* <4:0> value <5> Sign bit 0 = "increase", 1 = decrease  */
/* range -31:+31 */
int OV7620_WhiteBalanceBackgrdCtrlBlueCh(signed char scGain){
	unsigned char temp;
	if (scGain<0)  temp = (scGain & 0x1F) + 0x20;
	else temp = (scGain & 0x1F); 
	OV7620_WriteRegister(WHITE_BALANCE_BACKGROUND_CONTROL_BLUE_REG, temp);   
	return OK;
}

/* White balance background control -- Red channel */
/* <4:0> value <5> Sign bit 0 = "increase", 1 = decrease  */
/* range -31:+31 */
int OV7620_WhiteBalanceBackgrdCtrlRedCh(signed char scGain){
	unsigned char temp;
	if (scGain<0)  temp = (scGain & 0x1F) + 0x20;
	else temp = (scGain & 0x1F); 
	OV7620_WriteRegister(WHITE_BALANCE_BACKGROUND_CONTROL_RED_REG, temp);   
	return OK;
}

/* Set Auto Epposure control register */
int OV7620_AutoExposureControlRegister(unsigned char temp){
	OV7620_WriteRegister(AUTO_EXPOSURE_CONTROL_REG, temp);   
	return OK;
}
/* Read Auto Epposure control register */
int OV7620_AutoExposureControlRegisterRead(unsigned char *temp){
	OV7620_ReadRegister(AUTO_EXPOSURE_CONTROL_REG, temp);   
	return OK;
} 

/* Common control A register */
/* COMA7	0x80 - initiate soft reset */
/* COMA6	0x40 - Mirror image */
/* COMA5    0x20 - Enables AGC */
/* COMA4    0x10 - 8 bit digital output format is YUYVYUYV...*/
/* COMA3    0x08 - Raw data video output. "0" selects YCrCb */
/* COMA2    0x04 - Enables auto white balance. "0" AWB stop and reg [01] [02] values is held */
/* COMA1    0x02 - Seclects testpattern */
/* COMA0    0x01 - Selects precice A/B black level compensation */
/* Defalut COMA5, COMA2 */
int OV7620_ResetChip(void){
	unsigned char temp;
	temp = COMA7;
	OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp);
	return OK;
}

int OV7620_MirrorImage(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_A_REG, &temp);
		temp = temp | COMA6;
		OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_A_REG, &temp);
		temp = temp & ~COMA6;
		OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp); 
	}
	return OK;
}

/* Enable testpattern 1 = enable */
int OV7620_TestPattern(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_A_REG, &temp);
		temp = temp | COMA1;
		OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_A_REG, &temp);
		temp = temp & ~COMA1;
		OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp);
	}
	return OK;
}  
 
/* "1" Raw data video output. "0" selects YCrCb */
int OV7620_SetDataModeA(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_A_REG, &temp);
		temp = temp | COMA3;
		OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_A_REG, &temp);
		temp = temp & ~COMA3;
		OV7620_WriteRegister(COMMON_CONTROL_A_REG, temp);
	}
	return OK;
}

/* Common control B register */
/* COMB0	0x01 - "1" enables auto adjust mode. Overwrites register [00]~[02]. "0" manual */
/* COMB4	0x10 - "1" enables CCIR656, "0" enables CCIR601. */
/* COMB5    0x20 - "1" eight bit output */ 
/* default enabled */

/* "1" enables auto adjust mode. "0" manual mode */
int OV7620_AutoAdjustMode(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_B_REG, &temp);
		temp = temp | COMB0;
		OV7620_WriteRegister(COMMON_CONTROL_B_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_B_REG, &temp);
		temp = temp & ~COMB0;
		OV7620_WriteRegister(COMMON_CONTROL_B_REG, temp);
	} 
	return OK;
}                             

/* Enables eight bit output */
int OV7620_EightBitOutput(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_B_REG, &temp);
		temp = temp | COMB5;
		OV7620_WriteRegister(COMMON_CONTROL_B_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_B_REG, &temp);
		temp = temp & ~COMB5;
		OV7620_WriteRegister(COMMON_CONTROL_B_REG, temp);
	} 
	return OK;
}

/* Enables CCIR656 */
int OV7620_EnableCCIR656(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_B_REG, &temp);
		temp = temp | COMB4;
		OV7620_WriteRegister(COMMON_CONTROL_B_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_B_REG, &temp);
		temp = temp & ~COMB4;
		OV7620_WriteRegister(COMMON_CONTROL_B_REG, temp);
	} 
	return OK;
}


/* Common control C register */
/* COMC5	0x20 - QVGA format selection. "1" 320x240, "0" 640x480 */
/* COMC2    0x04 - RGB gamma selection. "1" gamma on - value reg[62]. "0" gamma = 1 linear */
/* dafault COMC2*/ 

/* QVGA format selection. "1" 320x240, "0" 640x480 */
int OV7620_QVGA(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
		temp = temp | COMC5;
		OV7620_WriteRegister(COMMON_CONTROL_C_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
		temp = temp & ~COMC5;
		OV7620_WriteRegister(COMMON_CONTROL_C_REG, temp);
	} 
	return OK;
}
/* RGB gamma selection. "1" gamma on - value reg[62]. "0" gamma = 1 linear */
int OV7620_Gamma(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
		temp = temp | COMC2;
		OV7620_WriteRegister(COMMON_CONTROL_C_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
		temp = temp & ~COMC2;
		OV7620_WriteRegister(COMMON_CONTROL_C_REG, temp);
	}  
	return OK;
} 

/* Common Control D register */
/* COMD6	0x40 - PCLK polarity selection  */ 
int OV7620_PCLKPolaritySelection(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_D_REG, &temp);
		temp = temp | COMD6;
		OV7620_WriteRegister(COMMON_CONTROL_D_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_D_REG, &temp);
		temp = temp & ~COMD6;
		OV7620_WriteRegister(COMMON_CONTROL_D_REG, temp);
	}  
	return OK;
}

/* Window sizing. Register [17]~[1A] */
/* Calculation of image size as folllows */
/* 1. Horizontal size : VGA mode Horizontal window size = ([18]-[17])*4 */
/*					QVGA mode Horizontal window size = ([18]-[17])*2 */
/* 2. Vertical size : VGA mode Vertical window size = ([1A]-[19] + 1) */
/*					QVGA mode Horizontal window size = ([1A]-[19] + 1) */
/* Use : All values for Horizontal position should be devided by 4 for VGA resolution */
/* for QVGA values for Horizontal position should be devided by 2 */ 
/* OV7620_SetActiveWindow(47, (207-47),6,(245-6));  is defaut values */
/* Range VGA 1-640;1-480 (resolution 4 pixels horizontal and 2 pixel vertical )*/
/* Range QVGA 1-320;1-240 (resolution 2 pixels horizontal and 1 pixel vertical )*/
/*int OV7620_SetActiveWindow(unsigned int unStartH, unsigned int unSizeH,
					   unsigned int unStartV,unsigned int unSizeV){*/
/* Range VGA 1-640;1-480 : Progresive scan */
/* Range VGA 1-640;1-240 : Interlaced scan */
/* Range QVGA 1-320;1-240 : Interlaced/Progresive scan */    
int OV7620_SetActiveWindow(ImageType Pict){
	unsigned char temp;
	unsigned int unStartH,unSizeH,unStartV,unSizeV;
	/* Set values */
	unSizeV = Pict.Hight;
	unSizeH = Pict.Width;
	unStartV = Pict.StartVertical; 
	unStartH = Pict.StartHorizontal;
	/* Check if not out of valid range 	VGA		QVGA  */
	/* [17] range 2C-D2 = 44 - 210 		1-664	1-332 */
	/* [18] range 2D-D2 = 45 - 210 */
	/* [19] range 05-F6 =  5 - 246 		1-242	1-242 */
	/* [20] range 05-F6 =  5 - 246 */    	
	
	/* Check if QVGA */
	OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
	if ((temp&COMC5)==COMC5){
		/* QVGA */
		if (unStartH<1) return ERROR;
		if (unStartV<1) return ERROR;
		if ((unStartH+unSizeH)>332) return ERROR;
		if ((unStartV+unSizeV)>242) return ERROR;  
		/* Convert valus to Reg values*/
		unStartV = unStartV-1+6;      /* min value is 5 default 6 */
		unStartH = (unStartH-1)/2+47; /* /2 for QVGA  min value is 44 default 47 */
		unSizeH = unSizeH/2;  		  /* /2 for QVGA */
		unSizeV = unSizeV-1;  
	}
	else {
		if (unStartH<1) return ERROR;
		if (unStartV<1) return ERROR;
		if ((unStartH+unSizeH)>644) return ERROR;
		/* Convert valus to reg values */
		unStartH = unStartH/4+47; /* /4 for VGA */
		unSizeH = unSizeH/4;   /* /4 for VGA */	
		/* Check reg if Progresive scan mode */
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		if ((temp&COMH5)==COMH5){		
			/* Progresive Scan mode */
 			if ((unStartV+unSizeV)>484) return ERROR;
 			unStartV = (unStartV-1)/2+6;
			unSizeV = unSizeV/2; 
		}
		else{
			/* Interlaced Mode */ 
			if ((unStartV+unSizeV)>242) return ERROR;
			unStartV = unStartV-1+6; 
		} 
	}
	/* Set values */
	OV7620_WriteRegister(HORIZONTAL_WINDOW_START_REG, unStartH);
	temp = unStartH + unSizeH;
	OV7620_WriteRegister(HORIZONTAL_WINDOW_END_REG, temp);
	OV7620_WriteRegister(VERTICAL_WINDOW_START_REG, unStartV);
	temp = unStartV + unSizeV;
	OV7620_WriteRegister(VERTICAL_WINDOW_END_REG, temp);
	return OK;
}

/* Check Manufacture ID */
int OV7620_CheckManufactureID(void){
	unsigned char temp;
	OV7620_ReadRegister(MANUFACTURE_ID_HB_REG, &temp);
	if (temp==0x7F){
		OV7620_ReadRegister(MANUFACTURE_ID_HB_REG, &temp);
		if (temp==0xA2) return OK;
		else return 3;
	}
	return ERROR;
}
/* Common Control E Rrgister */
/* COME3	0x04 - "1" AWB smart mode enable. Valid only if [13,0]=2 and[12,2]=1*/
/* COME1 	0x02 . "1" AWB fast mode */
/* AWB smart mode enable. Valid only if [13,0]=2 and[12,2]=1*/
int OV7620_AWBSmartModeEnable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_E_REG, &temp);
		temp = temp | COME3;
		OV7620_WriteRegister(COMMON_CONTROL_E_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_E_REG, &temp);
		temp = temp & ~COME3;
		OV7620_WriteRegister(COMMON_CONTROL_E_REG, temp);
	}  
	return OK;
}  

/* "1" AWB fast mode */
int OV7620_AWBFastModeEnable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_E_REG, &temp);
		temp = temp | COME1;
		OV7620_WriteRegister(COMMON_CONTROL_E_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_E_REG, &temp);
		temp = temp & ~COME1;
		OV7620_WriteRegister(COMMON_CONTROL_E_REG, temp);
	}  
	return OK;
}

/* Y channel offset Adjustment */
int OV7620_YChannelOffsetAdjustment(signed char scGain){
	unsigned char temp;
	/* <6:0> value <7> Sign bit 1 = add, 0 = sub  +127mV:-127mV*/
	/* range -127:+127 */
	if (scGain<0)  temp = (scGain & 0x7F);//0xFF - scGain + 1;
	else temp = (scGain & 0x7F) + 0x80; 
	OV7620_WriteRegister(Y_CHANNEL_OFFSET_ADJUSTMENT_REG, temp);   
	return OK;
}

/* Common Control F Rrgister */
/* COMF1 	0x02 . "1" AD blacl level calibration */
int OV7620_ADBlackLevelCalibrationEnable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_F_REG, &temp);
		temp = temp | COMF1;
		OV7620_WriteRegister(COMMON_CONTROL_F_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_F_REG, &temp);
		temp = temp & ~COMF1;
		OV7620_WriteRegister(COMMON_CONTROL_F_REG, temp);
	}  
	return OK;
}
/* Common Control G Rrgister */
/* COMG2 	0x04 . "1" Enables manual adjustment of A/D */ 
int OV7620_ManualAdjustmentADOffset(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_F_REG, &temp);
		temp = temp | COMG2;
		OV7620_WriteRegister(COMMON_CONTROL_F_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_F_REG, &temp);
		temp = temp & ~COMG2;
		OV7620_WriteRegister(COMMON_CONTROL_F_REG, temp);
	}  
	return OK;
}

/* Adjust frame rate */
/* Frame rate adjustment resolution is 0.12% The control word is 10 bit */
/* Every count decreases frame rate by 0.12% Range is 0.12% - 112 % */
/* EHSH7	0x80 - Frame rate adjustment enable */
/* EHSH2	0x04 - QVGA raw data format. */
/* [2A]<6:5> High bits and [2B]<7:0> low bits */
/* Range 0 - 1023 (0-0x3FF) */
int OV7620_AdjustFrameRate(int iEnable, int iFrameRate){
	unsigned char temp;
	if(iEnable==1){
		/* Enable frame rate adjustment */
		OV7620_ReadRegister(FRAME_RATE_ADJUST_REG_1, &temp);
		temp = temp | EHSH7;
		OV7620_WriteRegister(FRAME_RATE_ADJUST_REG_1, temp);
		/* Set frame rate High bits */
		temp = (iFrameRate & 0x300)>>3;
		OV7620_WriteRegister(FRAME_RATE_ADJUST_REG_1, temp);
		/* Set frame rate Low bits */
		temp = (iFrameRate & 0xFF);
		OV7620_WriteRegister(FRAME_RATE_ADJUST_REG_2, temp);
	}
	else{
		/* Disable frame rate adjustment */
		OV7620_ReadRegister(FRAME_RATE_ADJUST_REG_1, &temp);
		temp = temp & ~EHSH7;
		OV7620_WriteRegister(FRAME_RATE_ADJUST_REG_1, temp);
	}
	return OK;
}
/* Common control H register */
/* COMH6	0x40 - "1" enable B/W mode */ 
/* COMH5	0x20 - "1" enable Progresive Scan mode */ 
/* COMH4	0x10 - "1" Freeze AEG/AGC value. Effektive only if [13,0]=1 */
/* COMH3	0x08 - "1" Disable AGC */
/* COMH2	0x04 - "1" Y=GGGG, UV=BRBR, "0" Y=GRGR, UV=BGBG */

/* Enable progresive scan */
int OV7620_ProgresiveScanMode(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp | COMH5;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp & ~COMH5;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	return OK;
}

/* "1" Y=GGGG, UV=BRBR, "0" Y=GRGR, UV=BGBG */
int OV7620_RawDataOutputFormat(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp | COMH2;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp & ~COMH2;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	return OK;
} 

/* "1" Freeze AEG/AGC value. Effektive only if [13,0]=1 */
int OV7620_FreezeAEGandAGCValue(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp | COMH4;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp & ~COMH4;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	return OK;
}

/* "1" Disable AGC */
int OV7620_AGCDisable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp | COMH3;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_H_REG, &temp);
		temp = temp & ~COMH3;
		OV7620_WriteRegister(COMMON_CONTROL_H_REG, temp);
	}
	return OK;
} 

/* Common control I register */
/* COMI7	0x80 - "1" AEC Disable if [13,0]=1 and [10] value is held, else update internaly*/
/* COMI3	0x08 - Central weighted exposure control */
/* "1" AEC Disable if [13,0]=1 and [10] value is held, else update internaly*/ 
int OV7620_AECDisable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_I_REG, &temp);
		temp = temp | COMI7;
		OV7620_WriteRegister(COMMON_CONTROL_I_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_I_REG, &temp);
		temp = temp & ~COMI7;
		OV7620_WriteRegister(COMMON_CONTROL_I_REG, temp);
	}
	return OK;
}

/* Central weighted exposure control */
int OV7620_CentralWeightedExposureControl(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_I_REG, &temp);
		temp = temp | COMI3;
		OV7620_WriteRegister(COMMON_CONTROL_I_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_I_REG, &temp);
		temp = temp & ~COMI3;
		OV7620_WriteRegister(COMMON_CONTROL_I_REG, temp);
	}
	return OK;
}  

/* Common control J register */
/* COMJ6	0x40 - "1" QVGA 60 frames/s Odd field only. "0" QVGA 30 frames/s Odd/Even field	*/
/* COMJ4	0x10 - Auto brighness enabled */
/* COMJ2	0x04 - Banding filter enabled. After adjust frame rate to match indoor frequency */
/*					this enables a different exposure algorithm to cut light band introduced */
/*					by flouresent light */
/* "1" set field selection 60 f/s and "0" set frame selection 30 f/s */
/* "1" QVGA 60 frames/s Odd field only. "0" QVGA 30 frames/s Odd/Even field	*/
int OV7620_QVGAFrameSelection(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_J_REG, &temp);
		temp = temp | COMJ6;
		OV7620_WriteRegister(COMMON_CONTROL_J_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_J_REG, &temp);
		temp = temp & ~COMJ6;
		OV7620_WriteRegister(COMMON_CONTROL_J_REG, temp);
	}
	return OK;
}

/* Auto brighness enabled */
int OV7620_AutoBrightnessEnable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_J_REG, &temp);
		temp = temp | COMJ4;
		OV7620_WriteRegister(COMMON_CONTROL_J_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_J_REG, &temp);
		temp = temp & ~COMJ4;
		OV7620_WriteRegister(COMMON_CONTROL_J_REG, temp);
	}
	return OK;
}

/* Banding filter enabled. After adjust frame rate to match indoor frequency */
/* this enables a different exposure algorithm to cut light band introduced */
/* by flouresent light */
int OV7620_BandFilterEnable(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_J_REG, &temp);
		temp = temp | COMJ2;
		OV7620_WriteRegister(COMMON_CONTROL_J_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_J_REG, &temp);
		temp = temp & ~COMJ2;
		OV7620_WriteRegister(COMMON_CONTROL_J_REG, temp);
	}
	return OK;
} 

/* Common control L */
/* COML6	0x40 - Gated PCLK by Href */ 
/* Gated PCLK by Href */
int OV7620_GatedPCLKWithHREF(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(COMMON_CONTROL_L_REG, &temp);
		temp = temp | COML6;
		OV7620_WriteRegister(COMMON_CONTROL_L_REG, temp);
	}
	else{
		OV7620_ReadRegister(COMMON_CONTROL_L_REG, &temp);
		temp = temp & ~COML6;
		OV7620_WriteRegister(COMMON_CONTROL_L_REG, temp);
	}
	return OK;
}


/* Signal Process control A */
/* SPCA7	0x80 - 1.5 gain boost */
/* SPCA5	0x20 - disables green averaging for UV Channel, default enabled */
/* SPCA4	0x10 - disables green average for lumniance channel*/
/* SPCA<3:0> Color = 0111 B&W = 0000 */
/* Returns 0 for B/W camera and 7 for color */
int OV7620_CheckCameraChipType(unsigned char *temp){
	OV7620_ReadRegister(SIGNAL_PROCESS_CONTROL_A_REG, temp);
	*temp = *temp & 0x0F;
	return OK;
}
/* Signal Process control B */
/* SPCB7	0x80 - "1" YUV mode; "0" raw data mode. default YUV */
/* SPCB2    0x02 - limits [6] to half value (brightness)*/
/* Set Raw data mode 0 = raw data 1 = YUV */
int OV7620_SetDataModeB(int iOn){
	unsigned char temp;
	if (iOn==1){
		OV7620_ReadRegister(SIGNAL_PROCESS_CONTROL_B_REG, &temp);
		temp = temp | SPCB7;
		OV7620_WriteRegister(SIGNAL_PROCESS_CONTROL_B_REG, temp);
	}
	else{
		OV7620_ReadRegister(SIGNAL_PROCESS_CONTROL_B_REG, &temp);
		temp = temp & ~SPCB7;
		OV7620_WriteRegister(SIGNAL_PROCESS_CONTROL_B_REG, temp);
	}
	return OK;
}

/* RGB Gamma Control */
/* RGM<7:1> raw data or UV gamma curve selection */
/* Gamma value set to 0 - 127 */
int OV7620_RGBGammaControl(int iOn, int value){
	unsigned char temp;
	if (iOn==1){
		/* Enable gamma control */
		OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
		temp = temp | COMC2;
		OV7620_WriteRegister(COMMON_CONTROL_C_REG, temp);
		/* Set gamma value */
		temp = (value & 0x7F)<<1;
		OV7620_WriteRegister(RGB_GAMMA_CONTROL_REG, temp);
	}
	else{
		/* Disable gamma control */
		OV7620_ReadRegister(COMMON_CONTROL_C_REG, &temp);
		temp = temp & ~COMC2;
		OV7620_WriteRegister(COMMON_CONTROL_C_REG, temp);
	}
	return OK;
}

/* Y Gamma control */ 
/* YGM<7:1> Gamma curve selection */
/* YGM0		0x01 - "1" = enable. "0" = disable(linear) */
/* Default 0x59 enable, value 44 (0x2C) */
int OV7620_YGammaControl(int iOn, int value){
	unsigned char temp;
	if (iOn==1){
		/* Enable gamma control */
		OV7620_ReadRegister(Y_GAMMA_CONTROL_REG, &temp);
		temp = temp | YGM0;
		OV7620_WriteRegister(Y_GAMMA_CONTROL_REG, temp);
		/* Set gamma value */
		temp = (value & 0x7F)<<1;
		OV7620_WriteRegister(Y_GAMMA_CONTROL_REG, temp);
	}
	else{
		/* Disable gamma control */
		OV7620_ReadRegister(Y_GAMMA_CONTROL_REG, &temp);
		temp = temp & ~YGM0;
		OV7620_WriteRegister(Y_GAMMA_CONTROL_REG, temp);
	}
	return OK;
}

/* AWB Process control */
/* White balance function - YUV matrix control */
/* Register [74]<7> must be enabled */
/* Smart AWB ignores RGB raw data abowe or below treshold */
/* AWBC_ABOWE_70	0x00 */
/* AWBC_ABOWE_80	0x40 */
/* AWBC_ABOWE_90	0x80 */
/* AWBC_ABOWE_10	0xC0 */
/* AWBC_BELOW_10	0x00 */
/* AWBC_BELOW_20	0x10 */
/* AWBC_BELOW_30	0x20 */
/* AWBC_BELOW_40	0x30 */
/* Example call OV7620_WhiteBalanceLimitingRGB(1, AWBC_ABOWE_90 | AWBC_BELOW_10)*/

int OV7620_WhiteBalanceLimitingRGB(int iOn, int value){
	unsigned char temp;
	if (iOn==1){
		/* Enable smart AWB threshold control */
		OV7620_ReadRegister(COMMON_CONTROL_M_REG, &temp);
		temp = temp | COMM7;
		OV7620_WriteRegister(COMMON_CONTROL_M_REG, temp);
		/* Set treshold values for RGB values */
		OV7620_ReadRegister(AWB_PROCESS_CONTROL_REG, &temp);
		temp = temp & 0x0F;
		temp = temp | value;
		OV7620_WriteRegister(AWB_PROCESS_CONTROL_REG, temp);
	}
	else{
		/* Disable gamma control */
		OV7620_ReadRegister(COMMON_CONTROL_M_REG, &temp);
		temp = temp & ~COMM7;
		OV7620_WriteRegister(COMMON_CONTROL_M_REG, temp);
	}
	return OK;
}

/* Color Space selection */
/* YUV_YUV				0x00 */
/* YUV_ANALOG_YUV		0x40 */
/* YUV_CCIR_601_YCrCb	0x80 */
/* YUV_PAL_YUV			0xC0 */

int OV7620_ColorSpaceSelection(int value){
	unsigned char temp;
	/* Set treshold values for RGB values */
	OV7620_ReadRegister(COLOR_SPACE_SELECTION_REG, &temp);
	temp = temp & 0x3F;
	temp = temp | value;
	OV7620_WriteRegister(COLOR_SPACE_SELECTION_REG, temp);
	return OK;
}


/* Specific camera grabbing funktions */ 
int yuv2rgb_2(int uy, int vy, unsigned char *pixlar)
{
   short rgb[8];
   register int t1, t2, t3;
   register int y,u,v,y2;
   
   /*
     Another formula I found:  (seems to work)
     
     R = Y + 1.370705 (V-128)
     G = Y - 0.698001 (V-128) - 0.337633 (U-128)
     B = Y + 1.732446 (U-128)
   */ 
   y = uy&0xff;
   u = (uy&0xff00)>>8;
   v = (vy&0xff00)>>8;
   y2 = vy&0xff; 
   
   v = v - 128;
   u = u - 128;  
   /* Replace div with shifts */
   /* 2^14 16384 *
   t1 = (13707 * v);//10000;
   t2 = (6980 * v - 3376 * u);//10000;
   t3 = (17324 * u);//10000;*/
   
   /* OLD */
   t1 = (22457 * v)>>14;
   /* t2 = (11436 * v - 5532 * u)>>14;  BUGG Sign 020312 */ 
   t2 = (11436 * v + 5532 * u)>>14; 
   t3 = (28384 * u)>>14;   
   
   /* Definition from "Video Demystified" */
   //t1 = (22459 * v)>>14;
   //t2 = (11449 * v + 5510 * u)>>14;
   //t3 = (28400 * u)>>14; 
   /* New */
   //t3 = (16384*u)>>14;
   //t2 = (3055*u + 8609*v)>>14;
   //t1 = (16384*v)>>14; 
       
   /* YCrCb(YVU) -> RGB : OV7620 */
   //t1 = (22979*v)>>14;
   //t2 = (12074*v + 5406*u)>>14;
   //t3 = (28998*u)>>14;
   
   /* pixel A */
   rgb[0] = y + t1;
   rgb[1] = y - t2; //((y*16106)>>14) - t2;
   rgb[2] = y + t3;
   /* pixel B */
   rgb[4] = y2 + t1;
   rgb[5] = y2 - t2; //((y2*16106)>>14) - t2;
   rgb[6] = y2 + t3;  
   
   /* Even with proper conversion, some values still need clipping.*/
   pix_sat(8,rgb,pixlar);
   
   return OK;
}

/* Grabb an image, synk. with camera */
int GrabbImageRGBviaYUV(ImageType Pict, int nValue){ 
	unsigned int uiTimeOut=0,j,i,k; 
	unsigned int uiExtPict;   
   unsigned int uy,vy; 
   unsigned char pixlar[8];
   unsigned int *pixel32 = (unsigned int *)pixlar;
     	
    /* Wait until a image is grabbed */
    if (nValue){
    	if (!(CAMERA&0x01)){
    		while(!(CAMERA&0x01)){
				uiTimeOut++;
				if (uiTimeOut>30000) return ERROR;
			}
		}
	}
	/* Stop writing data to Sram and enabling reading */
	CAMERA = 0x04;		  	
    /* Convert from YUV to RGB */
    uiExtPict = EXT_RAM_START;
    j=0; 
    /* Check if decimation */
    switch(Pict.Decimation){
    	case 8:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+8){             // every 8 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*28;  	   // step 7 rows 7*4
    			for(i=0; i < Pict.Width;i=i+8){		// Decimation every 8 pixel
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 28;	       // Decimation  4 + 6*4;
   	 				yuv2rgb_2(uy, vy, pixlar);	 		
            		Pict.Image[j++] = pixel32[0];
    			}
    		}
    		break;
    	case 4:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+4){          // every 4 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*12;  	 // step 3 rows 3*4
    			for(i=0; i < Pict.Width;i=i+4){     	// Decimation every 4 pixel
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 12;				// Decimation  4 + 2*4;
   	 				yuv2rgb_2(uy, vy, pixlar);	 		
            		Pict.Image[j++] = pixel32[0];
    			}
    		}
    		break;
    	case 2:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+2){        // every 2 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*4;  	  // step one row 1*4
    			for(i=0; i < Pict.Width;i=i+2){
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 4;
   	 				yuv2rgb_2(uy, vy, pixlar);	 		
            		Pict.Image[j++] = pixel32[0];
    			}
    		}
    		break;
    	default:
    		/* i = row, k = col */
    		for(k=0; k <Pict.Hight;k++){
    			uiExtPict += 4; //Get rid of first byte
    			for(i=0; i < Pict.Width;i=i+2){    
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 4;
   	 				yuv2rgb_2(uy, vy, pixlar);	 		
            		Pict.Image[j++] = pixel32[0];
            		Pict.Image[j++] = pixel32[1];
    			}
    		}
    		break;
    } 
    /* Enabling writing to Sram */ 
    CAMERA = 0x00;
    return OK;
}

/* Grabb an image, synk. with camera */
int GrabbImageYUV(ImageType Pict, int nValue){ 
	unsigned int uiTimeOut=0,j,i,k;
	//unsigned int uiStopAdress; 
	unsigned int uiExtPict;   
   	unsigned int uy,vy,vuy; 
   	/* Lite Nytt - varning */
   	//unsigned char pixlar[8];
   	//unsigned int *pixel32 = (unsigned int *)pixlar;
     	
    /* Wait until a image is grabbed */
    if (nValue){
    	if (!(CAMERA&0x01)){
    		while(!(CAMERA&0x01)){
				uiTimeOut++;
				if (uiTimeOut>30000) return ERROR;
			}
		}
	}
	/* Stop writing data to Sram and enabling reading */
	CAMERA = 0x04;	 // 4=enable + 1=PWD	  	
    /* Convert from YUV to RGB */
    uiExtPict = EXT_RAM_START;
    j=0; 
    /* Check if decimation */
    switch(Pict.Decimation){
    	case 8:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+8){             // every 8 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*28;  	   // step 7 rows 7*4
    			for(i=0; i < Pict.Width;i=i+8){		// Decimation every 8 pixel
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 28;	       // Decimation  4 + 6*4;
   	 				vuy = uy & 0xFF00;
   	 				vuy = vuy + ((vy & 0xFF00)<<8);			
            		Pict.Image[j++] = vuy + (uy & 0xFF);
            		//Pict.Image[j++] = vuy + (vy & 0xFF);
    			}
    		}
    		break;
    	case 4:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+4){          // every 4 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*12;  	 // step 3 rows 3*4
    			for(i=0; i < Pict.Width;i=i+4){     	// Decimation every 4 pixel
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 12;				// Decimation  4 + 2*4;
   	 				vuy = uy & 0xFF00;
   	 				vuy = vuy + ((vy & 0xFF00)<<8);			
            		Pict.Image[j++] = vuy + (uy & 0xFF);
            		//Pict.Image[j++] = vuy + (vy & 0xFF);
    			}
    		}
    		break;
    	case 2:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+2){        // every 2 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*4;  	  // step one row 1*4
    			for(i=0; i < Pict.Width;i=i+2){
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 4;
   	 				vuy = uy & 0xFF00;
   	 				vuy = vuy + ((vy & 0xFF00)<<8);			
            		Pict.Image[j++] = vuy + (uy & 0xFF);
            		//Pict.Image[j++] = vuy + (vy & 0xFF);  // every 2 pixel
    			}
    		}
    		break;
    	default:
    		/* i = row, k = col */
    		for(k=0; k <Pict.Hight;k++){
    			uiExtPict += 4; //Get rid of first byte
    			for(i=0; i < Pict.Width;i=i+2){    
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 4;
   	 				/* Save Format YUV */ 
   	 				/* [xVUY] 32bit */
   	 				vuy = uy & 0xFF00;
   	 				vuy = vuy + ((vy & 0xFF00)<<8);			
            		Pict.Image[j++] = vuy + (uy & 0xFF);
            		Pict.Image[j++] = vuy + (vy & 0xFF);          	
    			} 

    		}
    		break;
    } 
    /* Enabling writing to Sram */ 
    CAMERA = 0x00;
    return OK;
} 

/* Grabb an image, synk. with camera */
int GrabbImageRGB(ImageType Pict, int nValue){ 
	unsigned int uiTimeOut=0,j,i,k; 
	unsigned int uiExtPict;   
   unsigned int uy,vy,vuy; 
     	
    /* Wait until a image is grabbed */
   if (nValue){
   	if (!(CAMERA&0x01)){
    		while(!(CAMERA&0x01)){
				uiTimeOut++;
				if (uiTimeOut>30000) return ERROR;
			}
		}
	}
	/* Stop writing data to Sram and enabling reading */
	CAMERA = 0x04;	 // 4=enable + 1=PWD	  	
    /* Convert from YUV to RGB */
    uiExtPict = EXT_RAM_START;
    j=0; 
    /* Check if decimation */
    switch(Pict.Decimation){
    	case 8:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+8){             // every 8 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*28;  	   // step 7 rows 7*4
    			for(i=0; i < Pict.Width;i=i+8){		// Decimation every 8 pixel
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 28;	       // Decimation  4 + 6*4;
   	 				/* THIS IS FOR YG-MODE */
            		vuy = (uy & 0xFF00)<<8;
   	 				vuy = vuy + ((vy & 0xFF00)>>8);			
            		Pict.Image[j++] = vuy + ((uy & 0xFF)<<8);
            		//Pict.Image[j++] = vuy + ((vy & 0xFF)<<8);;
    			}
    		}
    		break;
    	case 4:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+4){          // every 4 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*12;  	 // step 3 rows 3*4
    			for(i=0; i < Pict.Width;i=i+4){     	// Decimation every 4 pixel
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 12;				// Decimation  4 + 2*4;
   	 				/* THIS IS FOR YG-MODE */
            		vuy = (uy & 0xFF00)<<8;
   	 				vuy = vuy + ((vy & 0xFF00)>>8);			
            		Pict.Image[j++] = vuy + ((uy & 0xFF)<<8);
            		//Pict.Image[j++] = vuy + ((vy & 0xFF)<<8);
    			}
    		}
    		break;
    	case 2:
    		/* i = row, k = col */
    		for(k=0; k < Pict.Hight;k=k+2){        // every 2 row
    			uiExtPict += 4; //Get rid of first byte
    			uiExtPict += (Pict.Width+1)*4;  	  // step one row 1*4
    			for(i=0; i < Pict.Width;i=i+2){
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 4;
   	 				/* THIS IS FOR YG-MODE */
            		vuy = (uy & 0xFF00)<<8;
   	 				vuy = vuy + ((vy & 0xFF00)>>8);			
            		Pict.Image[j++] = vuy + ((uy & 0xFF)<<8);
            		//Pict.Image[j++] = vuy + ((vy & 0xFF)<<8); // every 2 pixel
    			}
    		}
    		break;
    	default:
    		/* i = row, k = col */
    		for(k=0; k <Pict.Hight;k++){
    			uiExtPict += 4; //Get rid of first byte   			
    			for(i=0; i < Pict.Width;i=i+2){    
    	    		/* Read data from sram */
    				uy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
					uiExtPict += 4;
					vy = *(unsigned volatile int *)(uiExtPict) & 0xffff;
   	 				uiExtPict += 4;  	 			
            		/* THIS IS FOR YG-MODE */
            		vuy = (uy & 0xFF00)<<8;
   	 				vuy = vuy + ((vy & 0xFF00)>>8);			
            		Pict.Image[j++] = vuy + ((uy & 0xFF)<<8);
            		Pict.Image[j++] = vuy + ((vy & 0xFF)<<8);   	 				           		                       	           		            		       	
    			} 

    		}
    		break;
    } 
    /* Enabling writing to Sram */ 
    CAMERA = 0x00;
    return OK;
}


/* Converts an YUV-Image to a RGB-image    */
/* Format(unsigned int) : [xVUY] -> [xBGR] */ 
int yuv2rgb(ImageType Pict)
{
   short rgb[8];
   int t1, t2, t3;
   int y,u,v;
   unsigned int ImageSize, i;
   unsigned char pixlar[8];
   unsigned int *pixel32 = (unsigned int *)pixlar;
   
   /* Loop through hole image */
   ImageSize = Pict.Hight * Pict.Width; 
   for(i=0;i<ImageSize;i++){
   	/* */
   	*pixel32 = Pict.Image[i];
    y = pixlar[0];
    u = pixlar[1];
   	v = pixlar[2];
   	/* */
  	v = v - 128;
   	u = u - 128;  
    /* */
   	t1 = (22457 * v)>>14;
   	t2 = (11436 * v + 5532 * u)>>14;
   	t3 = (28384 * u)>>14; 
   	/* Definition from "Video Demystified" *
   	t1 = (22459 * v)>>14;
   	t2 = (11449 * v + 5510 * u)>>14;
   	t3 = (28400 * u)>>14;
    *  */
    rgb[0] = y + t1 - 16;
    rgb[1] = y - t2 - 16;
    rgb[2] = y + t3 - 16;
    /* Even with proper conversion, some values still need clipping.*/
    pix_sat(8,rgb,pixlar);
    Pict.Image[i] = *pixel32;
   } 
   return OK;
} 

/* Converts an RGB-Image to a YUV-image */
/* Format(unsigned int) : [xBGR] -> [xVUY] */ 
int rgb2yuv(ImageType Pict)
{
   short yuv[8];
   int t1, t2, t3;
   int r,g,b;
   unsigned int ImageSize, i;
   unsigned char pixlar[8];
   unsigned int *pixel32 = (unsigned int *)pixlar;
   
   /* Loop through hole image */
   ImageSize = Pict.Hight * Pict.Width; 
   for(i=0;i<ImageSize;i++){
   	/* */
   	*pixel32 = Pict.Image[i];
    r = pixlar[0];
    g = pixlar[1];
   	b = pixlar[2];
   	/* Formula for Conversion */
   	/* Y =  0.257*R + 0.504*G + 0.098 *B */
   	/* V =  0.493*R - 0.368*G - 0.071 *B */
   	/* U = -0.148*R - 0.291*G + 0.439 *B */  
   	/*  0.2988    0.5868    0.1144
    	0.5115   -0.4281   -0.0834
   		-0.1725   -0.3387    0.5112 */
   	/* 	4896    9614    1874
    	8381   -7014   -1367
   		-2826   -5550    8376 */	
    t1 =  4896*r + 9614*g + 1874*b;
    t3 =  8381*r - 7014*g - 1367*b;
   	t2 = -2826*r - 5550*g + 8376*b;
   	
   	/* Definition from "Video Demystified" *
	t1 =  4211*r + 8258*g + 1606*b;
	t3 =  7193*r - 6029*g - 1163*b; 
	t2 = -2425*r - 4768*g + 7193*b;
    *  */
    yuv[0] = (t1>>14) + 16;
    yuv[1] = (t2>>14) + 128;
    yuv[2] = (t3>>14) + 128;
    /* Even with proper conversion, some values still need clipping.*/
    pix_sat(8,yuv,pixlar);
    Pict.Image[i] = *pixel32;
   } 
   return OK;
}

/* Init Camera */
int InitCamera(ImageType Pict){
	/* Software Reset */
   	OV7620_ResetChip();
   	/* Set Qvga mode - 320x240 */
   	if(Pict.Resolution==QVGA){	
   		OV7620_QVGA(1);
   	}
   	/* Set Grabb Mode */
   	if(Pict.GrabbMode==GRABB_RGB){
   		OV7620_SetDataModeA(1);
   		/* Set YG-mode */
   		OV7620_RawDataOutputFormat(1);
   	}
    /* Set Window */
    OV7620_SetActiveWindow(Pict);
   	return OK;	
}


 







 



