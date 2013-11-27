/* Headerfile for Omnivision OV7620 Single-Chip Cmos VGA Color Digital Camera */
/* Author : Bjorn Astrand, Halmstad University */

#ifndef _OV7620_H
#define _OV7620_H

#include "iic.h"

/* Error codes */
#define OK			 1
#define ERROR		-1 

/* Registers */
#define AGC_GAIN_CONTROL_REG						0x00
#define BLUE_GAIN_CONTROL_REG						0x01
#define RED_GAIN_CONTROL_REG						0x02
#define SATURATION_CONTROL_REG						0x03
#define BRIGHTNESS_CONTROL_REG						0x06
#define ANALOG_SHARPNESS_CONTROL_REG				0x07
#define WHITE_BALANCE_BACKGROUND_CONTROL_BLUE_REG	0x0C
#define WHITE_BALANCE_BACKGROUND_CONTROL_RED_REG	0x0D
#define AUTO_EXPOSURE_CONTROL_REG					0x10
#define CLOCK_RATE_CONTROL_REG						0x11
#define COMMON_CONTROL_A_REG						0x12
#define COMMON_CONTROL_B_REG						0x13
#define COMMON_CONTROL_C_REG						0x14
#define COMMON_CONTROL_D_REG						0x15
#define FRAME_DROP_REG								0x16
#define HORIZONTAL_WINDOW_START_REG					0x17
#define HORIZONTAL_WINDOW_END_REG					0x18
#define VERTICAL_WINDOW_START_REG					0x19
#define VERTICAL_WINDOW_END_REG						0x1A
#define PIXEL_SHIFT_REG								0x1B
#define MANUFACTURE_ID_HB_REG						0x1C
#define MANUFACTURE_ID_LB_REG						0x1D
#define COMMON_CONTROL_E_REG						0x20
#define Y_CHANNEL_OFFSET_ADJUSTMENT_REG				0x21
#define U_CHANNEL_OFFSET_ADJUSTMENT_REG				0x22
#define CRYSTAL_CURRENT_CONTROL_REG					0x23
#define AEW_AUTO_EXPOSURE_WHITE_PIXEL_RATIO_REG		0x24
#define AEC_AUTO_EXPOSURE_BLACK_PIXEL_RATIO_REG		0x25
#define COMMON_CONTROL_F_REG						0x26
#define COMMON_CONTROL_G_REG						0x27
#define COMMON_CONTROL_H_REG						0x28
#define COMMON_CONTROL_I_REG						0x29
#define FRAME_RATE_ADJUST_REG_1						0x2A
#define FRAME_RATE_ADJUST_REG_2						0x2B
#define BLACK_EXPANDING_REG							0x2C
#define COMMON_CONTROL_J_REG						0x2D
#define V_CHANNEL_OFFSET_ADJUSTMENT_REG				0x2E
#define SIGNAL_PROCESS_CONTROL_A_REG				0x60
#define SIGNAL_PROCESS_CONTROL_B_REG				0x61
#define RGB_GAMMA_CONTROL_REG						0x62
#define Y_GAMMA_CONTROL_REG							0x64
#define SIGNAL_PROCESS_CONTROL_C_REG				0x65
#define AWB_PROCESS_CONTROL_REG						0x66
#define COLOR_SPACE_SELECTION_REG					0x67
#define SIGNAL_PROCESS_CONTROL_D_REG				0x68
#define ANALOG_SHARPNESS_REG						0x69
#define VERTICAL_EDGE_ENHANCEMENT_CONTROL_REG		0x6A
#define EVEN_ODD_NOISE_COMPENSATION_CONTROL_REG		0x6F
#define COMMON_CONTROL_K_REG						0x70
#define COMMON_CONTROL_L_REG						0x71
#define HORIZONTAL_SYNC_1ST_EDGE_SHIFTING_REG		0x72
#define HORIZONTAL_SYNC_2ND_EDGE_SHIFTING_REG		0x73
#define COMMON_CONTROL_M_REG						0x74
#define COMMON_CONTROL_N_REG						0x75
#define COMMON_CONTROL_O_REG						0x76
#define FIELD_AVERAGE_LEVEL_STORAGE					0x7C

/* Register settings */
#define COMA7			0x80
#define COMA6			0x40
#define COMA5			0x20
#define COMA4			0x10
#define COMA3			0x08
#define COMA2			0x04
#define COMA1			0x02
#define COMA0			0x01

#define COMB5			0x20
#define COMB4			0x10
#define COMB3			0x08
#define COMB2			0x04
#define COMB1			0x02
#define COMB0			0x01

#define COMC5			0x20
#define COMC2			0x04 

#define COMD6			0x40

#define COME3			0x08
#define COME1			0x02 

#define COMF1 			0x02 

#define COMG2 			0x04

#define EHSH7			0x80
#define EHSH2			0x04 

#define COMH6			0x40
#define COMH5			0x20
#define COMH4			0x10
#define COMH3			0x08
#define COMH2			0x04

#define COMI7			0x80
#define COMI3			0x08

#define COMJ6			0x40
#define COMJ4			0x10
#define COMJ2			0x04 
#define COML6			0x40

#define SPCB7			0x80
#define YGM0			0x01

#define COMM7			0x80

#define AWBC_ABOWE_70	0x00 
#define AWBC_ABOWE_80	0x40 
#define AWBC_ABOWE_90	0x80 
#define AWBC_ABOWE_10	0xC0 
#define AWBC_BELOW_10	0x00 
#define AWBC_BELOW_20	0x10 
#define AWBC_BELOW_30	0x20 
#define AWBC_BELOW_40	0x30

#define YUV_YUV				0x00
#define YUV_ANALOG_YUV		0x40
#define YUV_CCIR_601_YCrCb	0x80
#define YUV_PAL_YUV			0xC0

#endif




















