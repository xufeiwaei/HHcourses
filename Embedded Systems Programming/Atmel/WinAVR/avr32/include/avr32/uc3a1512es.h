/*****************************************************************************
 *
 * Copyright (C) 2006-2009 Atmel Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in
 *   the documentation and/or other materials provided with the
 *   distribution.
 *
 * * Neither the name of the copyright holders nor the names of
 *   contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Model        : UC3A1512ES
 * Revision     : $Revision: 62595 $
 * Checkin Date : $Date: 2009-10-21 04:31:31 -0700 (Wed, 21 Oct 2009) $
 *
 ****************************************************************************/
#ifndef AVR32_UC3A1512ES_H_INCLUDED
#define AVR32_UC3A1512ES_H_INCLUDED


/* Core */
#include "avr32/core_sc0_100.h"
/* OCD */
#include "avr32/ocd_s0_100.h"

/* CORE */ 
#define AVR32_CORE_COMPARE_IRQ             0
#define AVR32_CORE_SCAN_CHAIN_MSB          19
#define AVR32_CORE_SCAN_CLOCK_MSB          12


/* OCD */ 
#define AVR32_OCD_CLK_CPU                  1

/* Memories */
#define AVR32_FLASH_ADDRESS                0x80000000
#define AVR32_FLASH_SIZE                   0x00080000
#define AVR32_FLASH                        ((unsigned char *)AVR32_FLASH_ADDRESS)
#define AVR32_SRAM_ADDRESS                 0x00000000
#define AVR32_SRAM_SIZE                    0x00010000
#define AVR32_SRAM                         ((unsigned char *)AVR32_SRAM_ADDRESS)
#define AVR32_USBB_SLAVE_ADDRESS           0xE0000000
#define AVR32_USBB_SLAVE_SIZE              0x00800000
#define AVR32_USBB_SLAVE                   ((unsigned char *)AVR32_USBB_SLAVE_ADDRESS)

/* Interrupt Controller */
#define AVR32_INTC_NUM                     1
#define AVR32_INTC_ADDRESS                 0xFFFF0800
#define AVR32_INTC                         (*((volatile avr32_intc_t*)AVR32_INTC_ADDRESS))
#define AVR32_INTC_CLK_PBA                 64
#define AVR32_INTC_NUM_INT_GRPS            19
#define AVR32_INTC_NUM_IRQS_PER_GRP0       1
#define AVR32_INTC_NUM_IRQS_PER_GRP1       11
#define AVR32_INTC_NUM_IRQS_PER_GRP10      1
#define AVR32_INTC_NUM_IRQS_PER_GRP11      1
#define AVR32_INTC_NUM_IRQS_PER_GRP12      1
#define AVR32_INTC_NUM_IRQS_PER_GRP13      1
#define AVR32_INTC_NUM_IRQS_PER_GRP14      3
#define AVR32_INTC_NUM_IRQS_PER_GRP15      1
#define AVR32_INTC_NUM_IRQS_PER_GRP16      1
#define AVR32_INTC_NUM_IRQS_PER_GRP17      1
#define AVR32_INTC_NUM_IRQS_PER_GRP18      1
#define AVR32_INTC_NUM_IRQS_PER_GRP2       9
#define AVR32_INTC_NUM_IRQS_PER_GRP3       15
#define AVR32_INTC_NUM_IRQS_PER_GRP4       1
#define AVR32_INTC_NUM_IRQS_PER_GRP5       1
#define AVR32_INTC_NUM_IRQS_PER_GRP6       1
#define AVR32_INTC_NUM_IRQS_PER_GRP7       1
#define AVR32_INTC_NUM_IRQS_PER_GRP8       1
#define AVR32_INTC_NUM_IRQS_PER_GRP9       1
#define AVR32_INTC_NUM_NMI                 1

#include "avr32/intc_101.h"


/* ADC */
#define AVR32_ADC_NUM                      1

/* ADC */ 
#define AVR32_ADC_ADDRESS                  0xFFFF3C00
#define AVR32_ADC                          (*((volatile avr32_adc_t*)AVR32_ADC_ADDRESS))
#define AVR32_ADC_CLK_PBA                  68
#define AVR32_ADC_IRQ                      480
#define AVR32_ADC_CHANNELS_MSB             7
#define AVR32_ADC_DATA_MSB                 9
#define AVR32_ADC_AD_0_PIN                 21
#define AVR32_ADC_AD_0_FUNCTION            0
#define AVR32_ADC_AD_1_PIN                 22
#define AVR32_ADC_AD_1_FUNCTION            0
#define AVR32_ADC_AD_2_PIN                 23
#define AVR32_ADC_AD_2_FUNCTION            0
#define AVR32_ADC_AD_3_PIN                 24
#define AVR32_ADC_AD_3_FUNCTION            0
#define AVR32_ADC_AD_4_PIN                 25
#define AVR32_ADC_AD_4_FUNCTION            0
#define AVR32_ADC_AD_5_PIN                 26
#define AVR32_ADC_AD_5_FUNCTION            0
#define AVR32_ADC_AD_6_PIN                 27
#define AVR32_ADC_AD_6_FUNCTION            0
#define AVR32_ADC_AD_7_PIN                 28
#define AVR32_ADC_AD_7_FUNCTION            0
#define AVR32_ADC_TEST_CLK_0_PIN           3
#define AVR32_ADC_TEST_DATA_0_PIN          8
#define AVR32_ADC_TEST_DATA_1_PIN          9
#define AVR32_ADC_TEST_DATA_2_PIN          10
#define AVR32_ADC_TEST_DATA_3_PIN          11
#define AVR32_ADC_TEST_DATA_4_PIN          12
#define AVR32_ADC_TEST_DATA_5_PIN          13
#define AVR32_ADC_TEST_DATA_6_PIN          14
#define AVR32_ADC_TEST_DATA_7_PIN          15
#define AVR32_ADC_TEST_DATA_8_PIN          16
#define AVR32_ADC_TEST_DATA_9_PIN          17
#define AVR32_ADC_TEST_EOC_0_PIN           7
#define AVR32_ADC_TEST_ONAD_0_PIN          1
#define AVR32_ADC_TEST_ONSAR_0_PIN         2
#define AVR32_ADC_TEST_SEL_0_PIN           4
#define AVR32_ADC_TEST_SEL_1_PIN           5
#define AVR32_ADC_TEST_SEL_2_PIN           6
#define AVR32_ADC_TEST_START_0_PIN         0
#define AVR32_ADC_TRIGGER_0_PIN            50
#define AVR32_ADC_TRIGGER_0_FUNCTION       1

#include "avr32/adc_102.h"


/* EIC */

/* EIC */ 
#define AVR32_EIC_ADDRESS                  0xFFFF0D80
#define AVR32_EIC                          (*((volatile avr32_eic_t*)AVR32_EIC_ADDRESS))
#define AVR32_EIC_CLK_PBA                  67
#define AVR32_EIC_IRQ_0                   32
#define AVR32_EIC_IRQ_1                   33
#define AVR32_EIC_IRQ_2                   34
#define AVR32_EIC_IRQ_3                   35
#define AVR32_EIC_IRQ_4                   36
#define AVR32_EIC_IRQ_5                   37
#define AVR32_EIC_IRQ_6                   38
#define AVR32_EIC_IRQ_7                   39
#define AVR32_EIC_INT_MSB                  8
#define AVR32_EIC_SCAN_MSB                 7
#define AVR32_EIC_STD_NUM                  8
#define AVR32_EIC_EXTINT_8_PIN             20
#define AVR32_EIC_EXTINT_8_FUNCTION        0
#define AVR32_EIC_EXTINT_4_PIN             3
#define AVR32_EIC_EXTINT_4_FUNCTION        1
#define AVR32_EIC_EXTINT_5_PIN             4
#define AVR32_EIC_EXTINT_5_FUNCTION        1
#define AVR32_EIC_EXTINT_6_PIN             10
#define AVR32_EIC_EXTINT_6_FUNCTION        1
#define AVR32_EIC_EXTINT_0_PIN             21
#define AVR32_EIC_EXTINT_0_FUNCTION        1
#define AVR32_EIC_EXTINT_1_PIN             22
#define AVR32_EIC_EXTINT_1_FUNCTION        1
#define AVR32_EIC_EXTINT_2_PIN             23
#define AVR32_EIC_EXTINT_2_FUNCTION        1
#define AVR32_EIC_EXTINT_3_PIN             24
#define AVR32_EIC_EXTINT_3_FUNCTION        1
#define AVR32_EIC_EXTINT_7_PIN             8
#define AVR32_EIC_EXTINT_7_FUNCTION        2
#define AVR32_EIC_SCAN_0_PIN               25
#define AVR32_EIC_SCAN_0_FUNCTION          1
#define AVR32_EIC_SCAN_1_PIN               26
#define AVR32_EIC_SCAN_1_FUNCTION          1
#define AVR32_EIC_SCAN_2_PIN               27
#define AVR32_EIC_SCAN_2_FUNCTION          1
#define AVR32_EIC_SCAN_3_PIN               28
#define AVR32_EIC_SCAN_3_FUNCTION          1
#define AVR32_EIC_SCAN_4_PIN               51
#define AVR32_EIC_SCAN_4_FUNCTION          2
#define AVR32_EIC_SCAN_5_PIN               52
#define AVR32_EIC_SCAN_5_FUNCTION          2
#define AVR32_EIC_SCAN_6_PIN               53
#define AVR32_EIC_SCAN_6_FUNCTION          2
#define AVR32_EIC_SCAN_7_PIN               54
#define AVR32_EIC_SCAN_7_FUNCTION          2

#include "avr32/eic_200.h"


/* FLASHC */
#define AVR32_FLASHC_NUM                   1

/* FLASHC */ 
#define AVR32_FLASHC_ADDRESS               0xFFFE1400
#define AVR32_FLASHC                       (*((volatile avr32_flashc_t*)AVR32_FLASHC_ADDRESS))
#define AVR32_FLASHC_CLK_HSB               32
#define AVR32_FLASHC_CLK_PBB               98
#define AVR32_FLASHC_IRQ                   128
#define AVR32_FLASHC_FLASH_SIZE            524288
#define AVR32_FLASHC_FWS_0_MAX_FREQ        33000000
#define AVR32_FLASHC_FWS_1_MAX_FREQ        66000000
#define AVR32_FLASHC_GPF_NUM               32
#define AVR32_FLASHC_PAGES_PR_REGION       64
#define AVR32_FLASHC_PAGE_SIZE             512
#define AVR32_FLASHC_USER_PAGE             ((volatile unsigned char *)AVR32_FLASHC_USER_PAGE_ADDRESS)
#define AVR32_FLASHC_USER_PAGE_ADDRESS     0x80800000
#define AVR32_FLASHC_USER_PAGE_SIZE        512
#define AVR32_FLASHC_BODEN                 27
#define AVR32_FLASHC_BODEN_MASK            0x18000000
#define AVR32_FLASHC_BODEN_OFFSET          27
#define AVR32_FLASHC_BODEN_SIZE            2
#define AVR32_FLASHC_BODHYST               26
#define AVR32_FLASHC_BODHYST_MASK          0x04000000
#define AVR32_FLASHC_BODHYST_OFFSET        26
#define AVR32_FLASHC_BODHYST_SIZE          1
#define AVR32_FLASHC_BODLEVEL              20
#define AVR32_FLASHC_BODLEVEL_MASK         0x03F00000
#define AVR32_FLASHC_BODLEVEL_OFFSET       20
#define AVR32_FLASHC_BODLEVEL_SIZE         6
#define AVR32_FLASHC_FGPFR_BODEN           27
#define AVR32_FLASHC_FGPFR_BODEN_MASK      0x18000000
#define AVR32_FLASHC_FGPFR_BODEN_OFFSET    27
#define AVR32_FLASHC_FGPFR_BODEN_SIZE      2
#define AVR32_FLASHC_FGPFR_BODHYST         26
#define AVR32_FLASHC_FGPFR_BODHYST_MASK    0x04000000
#define AVR32_FLASHC_FGPFR_BODHYST_OFFSET  26
#define AVR32_FLASHC_FGPFR_BODHYST_SIZE    1
#define AVR32_FLASHC_FGPFR_BODLEVEL        20
#define AVR32_FLASHC_FGPFR_BODLEVEL_MASK   0x03F00000
#define AVR32_FLASHC_FGPFR_BODLEVEL_OFFSET 20
#define AVR32_FLASHC_FGPFR_BODLEVEL_SIZE   6
#define AVR32_FLASHC_EXTCLK_0_PIN          57

#include "avr32/flashc_100.h"


/* FREQM */
#define AVR32_FREQM_NUM                    1

/* FREQM */ 
#define AVR32_FREQM_ADDRESS                0xFFFF0D50
#define AVR32_FREQM                        (*((volatile avr32_freqm_t*)AVR32_FREQM_ADDRESS))
#define AVR32_FREQM_IRQ                    42
#define AVR32_FREQM_REFSEL_BITS            1

#include "avr32/freqm_200.h"


/* GPIO */
#define AVR32_GPIO_NUM                     1

/* GPIO */ 
#define AVR32_GPIO_ADDRESS                 0xFFFF1000
#define AVR32_GPIO                         (*((volatile avr32_gpio_t*)AVR32_GPIO_ADDRESS))
#define AVR32_GPIO_CLK_PBA                 65
#define AVR32_GPIO_IRQ_0                  64
#define AVR32_GPIO_IRQ_1                  65
#define AVR32_GPIO_IRQ_2                  66
#define AVR32_GPIO_IRQ_3                  67
#define AVR32_GPIO_IRQ_4                  68
#define AVR32_GPIO_IRQ_5                  69
#define AVR32_GPIO_IRQ_6                  70
#define AVR32_GPIO_IRQ_7                  71
#define AVR32_GPIO_IRQ_8                  72
#define AVR32_GPIO_GFER_DEFAULT_VAL        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_GFER_IMPLEMENTED        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_GFILTER_IMPLEMENTED     "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_GPER_DEFAULT_VAL        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_GPER_IMPLEMENTED        "70'b0000001111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_IRQ_MSB                 8
#define AVR32_GPIO_PADDR_BITS              10
#define AVR32_GPIO_PINS_MSB                69
#define AVR32_GPIO_IER_DEFAULT_VAL         "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_IER_IMPLEMENTED         "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_IFR_IMPLEMENTED         "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_IMR0_DEFAULT_VAL        "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_IMR0_IMPLEMENTED        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_IMR1_DEFAULT_VAL        "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_IMR1_IMPLEMENTED        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_INPUT_SYNC_IMPLEMENTED  "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_IRQS_PER_GROUP          8
#define AVR32_GPIO_NUMBER_OF_PINS          70
#define AVR32_GPIO_ODER_DEFAULT_VAL        "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_ODER_IMPLEMENTED        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_ODMER_DEFAULT_VAL       "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_ODMER_IMPLEMENTED       "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_OVR_DEFAULT_VAL         "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_OVR_IMPLEMENTED         "70'b1111111111111111111111111111111111111101111111111111111111111111111111"
#define AVR32_GPIO_PADDR_MSB               9
#define AVR32_GPIO_PDATA_MSB               31
#define AVR32_GPIO_PMR0_DEFAULT_VAL        "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_PMR0_IMPLEMENTED        "70'b0000001111111111111111011111000001001101111111111111111101111111111111"
#define AVR32_GPIO_PMR1_DEFAULT_VAL        "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_PMR1_IMPLEMENTED        "70'b0000001110000001111111011111000001000000011110000000111100000110000000"
#define AVR32_GPIO_PORT_LENGTH             3
#define AVR32_GPIO_PUER_DEFAULT_VAL        "70'b0000000000000000000000000000000000000000000000000000000000000000000000"
#define AVR32_GPIO_PUER_IMPLEMENTED        "70'b1111111111111111111111111111111111111101111111111111111111111111111111"

#include "avr32/gpio_100.h"


/* HMATRIX */
#define AVR32_HMATRIX_NUM                  1

/* HMATRIX */ 
#define AVR32_HMATRIX_ADDRESS              0xFFFE1000
#define AVR32_HMATRIX                      (*((volatile avr32_hmatrix_t*)AVR32_HMATRIX_ADDRESS))
#define AVR32_HMATRIX_CLK_HSB_PBA_BRIDGE   33
#define AVR32_HMATRIX_CLK_HSB_PBB_BRIDGE   34
#define AVR32_HMATRIX_CLK_PBB              96
#define AVR32_HMATRIX_MASTER_CPU_DATA      0
#define AVR32_HMATRIX_MASTER_CPU_INSN      1
#define AVR32_HMATRIX_MASTER_CPU_SAB       2
#define AVR32_HMATRIX_MASTER_MACB_DMA      4
#define AVR32_HMATRIX_MASTER_NUM           6
#define AVR32_HMATRIX_MASTER_PDCA          3
#define AVR32_HMATRIX_MASTER_USBB_DMA      5
#define AVR32_HMATRIX_SLAVE_FLASH          0
#define AVR32_HMATRIX_SLAVE_NUM            5
#define AVR32_HMATRIX_SLAVE_PBA            1
#define AVR32_HMATRIX_SLAVE_PBB            2
#define AVR32_HMATRIX_SLAVE_SRAM           3
#define AVR32_HMATRIX_SLAVE_USBB_DPRAM     4

#include "avr32/hmatrix_220.h"


/* JTAG */

/* JTAG */ 



/* MACB */
#define AVR32_MACB_NUM                     1

/* MACB */ 
#define AVR32_MACB_ADDRESS                 0xFFFE1800
#define AVR32_MACB                         (*((volatile avr32_macb_t*)AVR32_MACB_ADDRESS))
#define AVR32_MACB_CLK_HSB                 36
#define AVR32_MACB_CLK_PBB                 99
#define AVR32_MACB_IRQ                     512
#define AVR32_MACB_COL_0_PIN               48
#define AVR32_MACB_COL_0_FUNCTION          0
#define AVR32_MACB_CRS_0_PIN               36
#define AVR32_MACB_CRS_0_FUNCTION          0
#define AVR32_MACB_MDC_0_PIN               40
#define AVR32_MACB_MDC_0_FUNCTION          0
#define AVR32_MACB_MDIO_0_PIN              41
#define AVR32_MACB_MDIO_0_FUNCTION         0
#define AVR32_MACB_RXD_0_PIN               37
#define AVR32_MACB_RXD_0_FUNCTION          0
#define AVR32_MACB_RXD_1_PIN               38
#define AVR32_MACB_RXD_1_FUNCTION          0
#define AVR32_MACB_RXD_2_PIN               45
#define AVR32_MACB_RXD_2_FUNCTION          0
#define AVR32_MACB_RXD_3_PIN               46
#define AVR32_MACB_RXD_3_FUNCTION          0
#define AVR32_MACB_RX_CLK_0_PIN            49
#define AVR32_MACB_RX_CLK_0_FUNCTION       0
#define AVR32_MACB_RX_DV_0_PIN             47
#define AVR32_MACB_RX_DV_0_FUNCTION        0
#define AVR32_MACB_RX_ER_0_PIN             39
#define AVR32_MACB_RX_ER_0_FUNCTION        0
#define AVR32_MACB_SCAN_CLOCK_0_0_PIN      32
#define AVR32_MACB_SCAN_CLOCK_0_1_PIN      49
#define AVR32_MACB_SPEED_0_PIN             50
#define AVR32_MACB_SPEED_0_FUNCTION        0
#define AVR32_MACB_TXD_0_PIN               34
#define AVR32_MACB_TXD_0_FUNCTION          0
#define AVR32_MACB_TXD_1_PIN               35
#define AVR32_MACB_TXD_1_FUNCTION          0
#define AVR32_MACB_TXD_2_PIN               42
#define AVR32_MACB_TXD_2_FUNCTION          0
#define AVR32_MACB_TXD_3_PIN               43
#define AVR32_MACB_TXD_3_FUNCTION          0
#define AVR32_MACB_TX_CLK_0_PIN            32
#define AVR32_MACB_TX_CLK_0_FUNCTION       0
#define AVR32_MACB_TX_EN_0_PIN             33
#define AVR32_MACB_TX_EN_0_FUNCTION        0
#define AVR32_MACB_TX_ER_0_PIN             44
#define AVR32_MACB_TX_ER_0_FUNCTION        0

#include "avr32/macb_112.h"


/* PDCA */
#define AVR32_PDCA_NUM                     1

/* PDCA */ 
#define AVR32_PDCA_ADDRESS                 0xFFFF0000
#define AVR32_PDCA                         (*((volatile avr32_pdca_t*)AVR32_PDCA_ADDRESS))
#define AVR32_PDCA_CLK_HSB                 37
#define AVR32_PDCA_CLK_PBA                 66
#define AVR32_PDCA_IRQ_0                  96
#define AVR32_PDCA_IRQ_1                  97
#define AVR32_PDCA_IRQ_2                  98
#define AVR32_PDCA_IRQ_3                  99
#define AVR32_PDCA_IRQ_4                  100
#define AVR32_PDCA_IRQ_5                  101
#define AVR32_PDCA_IRQ_6                  102
#define AVR32_PDCA_IRQ_7                  103
#define AVR32_PDCA_IRQ_8                  104
#define AVR32_PDCA_IRQ_9                  105
#define AVR32_PDCA_IRQ_10                 106
#define AVR32_PDCA_IRQ_11                 107
#define AVR32_PDCA_IRQ_12                 108
#define AVR32_PDCA_IRQ_13                 109
#define AVR32_PDCA_IRQ_14                 110
#define AVR32_PDCA_CHANNEL_LENGTH          15
#define AVR32_PDCA_PID_ADC_RX              0
#define AVR32_PDCA_PID_SPI0_RX             7
#define AVR32_PDCA_PID_SPI0_TX             15
#define AVR32_PDCA_PID_SPI1_RX             8
#define AVR32_PDCA_PID_SPI1_TX             16
#define AVR32_PDCA_PID_SSC_RX              1
#define AVR32_PDCA_PID_SSC_TX              9
#define AVR32_PDCA_PID_TWI_RX              6
#define AVR32_PDCA_PID_TWI_TX              14
#define AVR32_PDCA_PID_USART0_RX           2
#define AVR32_PDCA_PID_USART0_TX           10
#define AVR32_PDCA_PID_USART1_RX           3
#define AVR32_PDCA_PID_USART1_TX           11
#define AVR32_PDCA_PID_USART2_RX           4
#define AVR32_PDCA_PID_USART2_TX           12
#define AVR32_PDCA_PID_USART3_RX           5
#define AVR32_PDCA_PID_USART3_TX           13

#include "avr32/pdca_100.h"


/* PLL */

/* PLL0 */ 
#define AVR32_PLL0_DN_0_PIN                50
#define AVR32_PLL0_FDIV_0_PIN              52
#define AVR32_PLL0_FDIV_TEST_0_PIN         53
#define AVR32_PLL0_LOCK_0_PIN              1
#define AVR32_PLL0_PLLCLK_0_PIN            0
#define AVR32_PLL0_UP_0_PIN                51


/* PLL1 */ 
#define AVR32_PLL1_DN_0_PIN                55
#define AVR32_PLL1_FDIV_0_PIN              57
#define AVR32_PLL1_FDIV_TEST_0_PIN         58
#define AVR32_PLL1_LOCK_0_PIN              3
#define AVR32_PLL1_PLLCLK_0_PIN            2
#define AVR32_PLL1_UP_0_PIN                56



/* PM */
#define AVR32_PM_NUM                       1

/* PM */ 
#define AVR32_PM_ADDRESS                   0xFFFF0C00
#define AVR32_PM                           (*((volatile avr32_pm_t*)AVR32_PM_ADDRESS))
#define AVR32_PM_CLK_PBA                   67
#define AVR32_PM_IRQ                       41
#define AVR32_PM_GCLK_MSB                  3
#define AVR32_PM_GCLK_NUM                  5
#define AVR32_PM_GCLK_USBB                 4
#define AVR32_PM_GPLP_NUM                  2
#define AVR32_PM_CPU_MAX_FREQ              66000000
#define AVR32_PM_HSB_MAX_FREQ              66000000
#define AVR32_PM_PBA_MAX_FREQ              33000000
#define AVR32_PM_PBB_MAX_FREQ              66000000
#define AVR32_PM_PLL_VCO_RANGE0_MAX_FREQ   240000000
#define AVR32_PM_PLL_VCO_RANGE0_MIN_FREQ   160000000
#define AVR32_PM_PLL_VCO_RANGE1_MAX_FREQ   180000000
#define AVR32_PM_PLL_VCO_RANGE1_MIN_FREQ   80000000
#define AVR32_PM_RCOSC_CALIBRATION_BITS    10
#define AVR32_PM_RCOSC_FREQUENCY           115200
#define AVR32_PM_GCLK_0_0_PIN              7
#define AVR32_PM_GCLK_0_0_FUNCTION         1
#define AVR32_PM_GCLK_0_1_PIN              51
#define AVR32_PM_GCLK_0_1_FUNCTION         1
#define AVR32_PM_GCLK_1_0_PIN              52
#define AVR32_PM_GCLK_1_0_FUNCTION         1
#define AVR32_PM_GCLK_2_0_PIN              53
#define AVR32_PM_GCLK_2_0_FUNCTION         1
#define AVR32_PM_GCLK_3_0_PIN              54
#define AVR32_PM_GCLK_3_0_FUNCTION         1
#define AVR32_PM_GCLK_1_1_PIN              61
#define AVR32_PM_GCLK_1_1_FUNCTION         1
#define AVR32_PM_GCLK_2_1_PIN              62
#define AVR32_PM_GCLK_2_1_FUNCTION         1
#define AVR32_PM_GCLK_3_1_PIN              63
#define AVR32_PM_GCLK_3_1_FUNCTION         1
#define AVR32_PM_RSTM_N_0_PIN              63
#define AVR32_PM_XIN0_0_PIN                66
#define AVR32_PM_XIN1_0_PIN                68
#define AVR32_PM_XIN32_0_PIN               64
#define AVR32_PM_XOUT0_0_PIN               67
#define AVR32_PM_XOUT1_0_PIN               69
#define AVR32_PM_XOUT32_0_PIN              65
#define AVR32_PM_CLK_GRP_CPU               0
#define AVR32_PM_CLK_GRP_HSB               1
#define AVR32_PM_CLK_GRP_PBA               2
#define AVR32_PM_CLK_GRP_PBB               3
#define AVR32_PM_NUM_CLK_GRPS              4
#define AVR32_PM_NUM_CLKS_PER_GRP0         2
#define AVR32_PM_NUM_CLKS_PER_GRP1         6
#define AVR32_PM_NUM_CLKS_PER_GRP2         15
#define AVR32_PM_NUM_CLKS_PER_GRP3         4

#include "avr32/pm_200.h"


/* PWM */
#define AVR32_PWM_NUM                      1

/* PWM */ 
#define AVR32_PWM_ADDRESS                  0xFFFF3000
#define AVR32_PWM                          (*((volatile avr32_pwm_t*)AVR32_PWM_ADDRESS))
#define AVR32_PWM_CLK_PBA                  76
#define AVR32_PWM_IRQ                      384
#define AVR32_PWM_CHANNEL_LENGTH           0x7
#define AVR32_PWM_LINES_MSB                6
#define AVR32_PWM_0_PIN                    51
#define AVR32_PWM_0_FUNCTION               0
#define AVR32_PWM_1_PIN                    52
#define AVR32_PWM_1_FUNCTION               0
#define AVR32_PWM_2_PIN                    53
#define AVR32_PWM_2_FUNCTION               0
#define AVR32_PWM_3_PIN                    54
#define AVR32_PWM_3_FUNCTION               0
#define AVR32_PWM_4_0_PIN                  5
#define AVR32_PWM_4_0_FUNCTION             1
#define AVR32_PWM_5_0_PIN                  6
#define AVR32_PWM_5_0_FUNCTION             1
#define AVR32_PWM_4_1_PIN                  59
#define AVR32_PWM_4_1_FUNCTION             1
#define AVR32_PWM_5_1_PIN                  60
#define AVR32_PWM_5_1_FUNCTION             1
#define AVR32_PWM_6_PIN                    50
#define AVR32_PWM_6_FUNCTION               2

#include "avr32/pwm_120.h"


/* RTC */
#define AVR32_RTC_NUM                      1

/* RTC */ 
#define AVR32_RTC_ADDRESS                  0xFFFF0D00
#define AVR32_RTC                          (*((volatile avr32_rtc_t*)AVR32_RTC_ADDRESS))
#define AVR32_RTC_CLK_PBA                  67
#define AVR32_RTC_IRQ                      40

#include "avr32/rtc_200.h"


/* SPI */
#define AVR32_SPI_NUM                      2

/* SPI0 */ 
#define AVR32_SPI0_ADDRESS                 0xFFFF2400
#define AVR32_SPI0                         (*((volatile avr32_spi_t*)AVR32_SPI0_ADDRESS))
#define AVR32_SPI0_CLK_PBA                 69
#define AVR32_SPI0_IRQ                     288
#define AVR32_SPI0_SPI_CS_MSB              3
#define AVR32_SPI0_MISO_0_PIN              11
#define AVR32_SPI0_MISO_0_FUNCTION         0
#define AVR32_SPI0_MOSI_0_PIN              12
#define AVR32_SPI0_MOSI_0_FUNCTION         0
#define AVR32_SPI0_NPCS_0_PIN              10
#define AVR32_SPI0_NPCS_0_FUNCTION         0
#define AVR32_SPI0_NPCS_1_PIN              8
#define AVR32_SPI0_NPCS_1_FUNCTION         1
#define AVR32_SPI0_NPCS_2_PIN              9
#define AVR32_SPI0_NPCS_2_FUNCTION         1
#define AVR32_SPI0_NPCS_3_PIN              7
#define AVR32_SPI0_NPCS_3_FUNCTION         2
#define AVR32_SPI0_SCAN_CLOCK_0_PIN        13
#define AVR32_SPI0_SCK_0_PIN               13
#define AVR32_SPI0_SCK_0_FUNCTION          0


/* SPI1 */ 
#define AVR32_SPI1_ADDRESS                 0xFFFF2800
#define AVR32_SPI1                         (*((volatile avr32_spi_t*)AVR32_SPI1_ADDRESS))
#define AVR32_SPI1_CLK_PBA                 70
#define AVR32_SPI1_IRQ                     320
#define AVR32_SPI1_SPI_CS_MSB              3
#define AVR32_SPI1_MISO_0_PIN              17
#define AVR32_SPI1_MISO_0_FUNCTION         1
#define AVR32_SPI1_MOSI_0_PIN              16
#define AVR32_SPI1_MOSI_0_FUNCTION         1
#define AVR32_SPI1_NPCS_0_PIN              14
#define AVR32_SPI1_NPCS_0_FUNCTION         1
#define AVR32_SPI1_NPCS_1_PIN              18
#define AVR32_SPI1_NPCS_1_FUNCTION         1
#define AVR32_SPI1_NPCS_2_PIN              19
#define AVR32_SPI1_NPCS_2_FUNCTION         1
#define AVR32_SPI1_NPCS_3_PIN              20
#define AVR32_SPI1_NPCS_3_FUNCTION         1
#define AVR32_SPI1_SCAN_CLOCK_0_PIN        15
#define AVR32_SPI1_SCK_0_PIN               15
#define AVR32_SPI1_SCK_0_FUNCTION          1

#include "avr32/spi_192.h"


/* SSC */
#define AVR32_SSC_NUM                      1

/* SSC */ 
#define AVR32_SSC_ADDRESS                  0xFFFF3400
#define AVR32_SSC                          (*((volatile avr32_ssc_t*)AVR32_SSC_ADDRESS))
#define AVR32_SSC_CLK_PBA                  77
#define AVR32_SSC_IRQ                      416
#define AVR32_SSC_RX_CLOCK_0_PIN           18
#define AVR32_SSC_RX_CLOCK_0_FUNCTION      0
#define AVR32_SSC_RX_DATA_0_PIN            17
#define AVR32_SSC_RX_DATA_0_FUNCTION       0
#define AVR32_SSC_RX_FRAME_SYNC_0_PIN      19
#define AVR32_SSC_RX_FRAME_SYNC_0_FUNCTION 0
#define AVR32_SSC_TX_CLOCK_0_PIN           15
#define AVR32_SSC_TX_CLOCK_0_FUNCTION      0
#define AVR32_SSC_TX_DATA_0_PIN            16
#define AVR32_SSC_TX_DATA_0_FUNCTION       0
#define AVR32_SSC_TX_FRAME_SYNC_0_PIN      14
#define AVR32_SSC_TX_FRAME_SYNC_0_FUNCTION 0

#include "avr32/ssc_301.h"


/* TC */
#define AVR32_TC_NUM                       1

/* TC */ 
#define AVR32_TC_ADDRESS                   0xFFFF3800
#define AVR32_TC                           (*((volatile avr32_tc_t*)AVR32_TC_ADDRESS))
#define AVR32_TC_CLK_PBA                   78
#define AVR32_TC_IRQ0                      448
#define AVR32_TC_IRQ1                      449
#define AVR32_TC_IRQ2                      450
#define AVR32_TC_A0_0_PIN                  55
#define AVR32_TC_A0_0_FUNCTION             0
#define AVR32_TC_A1_0_PIN                  57
#define AVR32_TC_A1_0_FUNCTION             0
#define AVR32_TC_A2_0_PIN                  59
#define AVR32_TC_A2_0_FUNCTION             0
#define AVR32_TC_B0_0_PIN                  56
#define AVR32_TC_B0_0_FUNCTION             0
#define AVR32_TC_B1_0_PIN                  58
#define AVR32_TC_B1_0_FUNCTION             0
#define AVR32_TC_B2_0_PIN                  60
#define AVR32_TC_B2_0_FUNCTION             0
#define AVR32_TC_CLK0_0_0_PIN              0
#define AVR32_TC_CLK0_0_0_FUNCTION         1
#define AVR32_TC_CLK0_0_1_PIN              44
#define AVR32_TC_CLK0_0_1_FUNCTION         1
#define AVR32_TC_CLK1_0_0_PIN              1
#define AVR32_TC_CLK1_0_0_FUNCTION         1
#define AVR32_TC_CLK1_0_1_PIN              45
#define AVR32_TC_CLK1_0_1_FUNCTION         1
#define AVR32_TC_CLK2_0_0_PIN              2
#define AVR32_TC_CLK2_0_0_FUNCTION         1
#define AVR32_TC_CLK2_0_1_PIN              46
#define AVR32_TC_CLK2_0_1_FUNCTION         1

#include "avr32/tc_222.h"


/* TWI */
#define AVR32_TWI_NUM                      1

/* TWI */ 
#define AVR32_TWI_ADDRESS                  0xFFFF2C00
#define AVR32_TWI                          (*((volatile avr32_twi_t*)AVR32_TWI_ADDRESS))
#define AVR32_TWI_CLK_PBA                  71
#define AVR32_TWI_IRQ                      352
#define AVR32_TWI_SCL_0_0_PIN              30
#define AVR32_TWI_SCL_0_0_FUNCTION         0
#define AVR32_TWI_SCL_0_1_PIN              30
#define AVR32_TWI_SCL_INPUT_TEST_0_PIN     0
#define AVR32_TWI_SCL_OUTPUT_TEST_0_PIN    1
#define AVR32_TWI_SDA_0_0_PIN              29
#define AVR32_TWI_SDA_0_0_FUNCTION         0
#define AVR32_TWI_SDA_0_1_PIN              29
#define AVR32_TWI_SDA_INPUT_TEST_0_PIN     2
#define AVR32_TWI_SDA_OUTPUT_TEST_0_PIN    3

#include "avr32/twi_202.h"


/* USART */
#define AVR32_USART_NUM                    4

/* USART0 */ 
#define AVR32_USART0_ADDRESS               0xFFFF1400
#define AVR32_USART0                       (*((volatile avr32_usart_t*)AVR32_USART0_ADDRESS))
#define AVR32_USART0_CLK_PBA               72
#define AVR32_USART0_IRQ                   160
#define AVR32_USART0_CLK_0_PIN             2
#define AVR32_USART0_CLK_0_FUNCTION        0
#define AVR32_USART0_CTS_0_PIN             4
#define AVR32_USART0_CTS_0_FUNCTION        0
#define AVR32_USART0_RTS_0_PIN             3
#define AVR32_USART0_RTS_0_FUNCTION        0
#define AVR32_USART0_RXD_0_PIN             0
#define AVR32_USART0_RXD_0_FUNCTION        0
#define AVR32_USART0_TXD_0_PIN             1
#define AVR32_USART0_TXD_0_FUNCTION        0


/* USART1 */ 
#define AVR32_USART1_ADDRESS               0xFFFF1800
#define AVR32_USART1                       (*((volatile avr32_usart_t*)AVR32_USART1_ADDRESS))
#define AVR32_USART1_CLK_PBA               73
#define AVR32_USART1_IRQ                   192
#define AVR32_USART1_CLK_0_PIN             7
#define AVR32_USART1_CLK_0_FUNCTION        0
#define AVR32_USART1_CTS_0_PIN             9
#define AVR32_USART1_CTS_0_FUNCTION        0
#define AVR32_USART1_DCD_0_PIN             55
#define AVR32_USART1_DCD_0_FUNCTION        1
#define AVR32_USART1_DSR_0_PIN             56
#define AVR32_USART1_DSR_0_FUNCTION        1
#define AVR32_USART1_DTR_0_PIN             57
#define AVR32_USART1_DTR_0_FUNCTION        1
#define AVR32_USART1_RI_0_PIN              58
#define AVR32_USART1_RI_0_FUNCTION         1
#define AVR32_USART1_RTS_0_PIN             8
#define AVR32_USART1_RTS_0_FUNCTION        0
#define AVR32_USART1_RXD_0_PIN             5
#define AVR32_USART1_RXD_0_FUNCTION        0
#define AVR32_USART1_TXD_0_PIN             6
#define AVR32_USART1_TXD_0_FUNCTION        0


/* USART2 */ 
#define AVR32_USART2_ADDRESS               0xFFFF1C00
#define AVR32_USART2                       (*((volatile avr32_usart_t*)AVR32_USART2_ADDRESS))
#define AVR32_USART2_CLK_PBA               74
#define AVR32_USART2_IRQ                   224
#define AVR32_USART2_CLK_0_PIN             63
#define AVR32_USART2_CLK_0_FUNCTION        0
#define AVR32_USART2_CTS_0_0_PIN           30
#define AVR32_USART2_CTS_0_0_FUNCTION      1
#define AVR32_USART2_CTS_0_1_PIN           33
#define AVR32_USART2_CTS_0_1_FUNCTION      1
#define AVR32_USART2_RTS_0_0_PIN           29
#define AVR32_USART2_RTS_0_0_FUNCTION      1
#define AVR32_USART2_RTS_0_1_PIN           32
#define AVR32_USART2_RTS_0_1_FUNCTION      1
#define AVR32_USART2_RXD_0_PIN             61
#define AVR32_USART2_RXD_0_FUNCTION        0
#define AVR32_USART2_TXD_0_PIN             62
#define AVR32_USART2_TXD_0_FUNCTION        0


/* USART3 */ 
#define AVR32_USART3_ADDRESS               0xFFFF2000
#define AVR32_USART3                       (*((volatile avr32_usart_t*)AVR32_USART3_ADDRESS))
#define AVR32_USART3_CLK_PBA               75
#define AVR32_USART3_IRQ                   256
#define AVR32_USART3_CLK_0_PIN             36
#define AVR32_USART3_CLK_0_FUNCTION        1
#define AVR32_USART3_RXD_0_PIN             42
#define AVR32_USART3_RXD_0_FUNCTION        1
#define AVR32_USART3_TXD_0_PIN             43
#define AVR32_USART3_TXD_0_FUNCTION        1

#include "avr32/usart_319.h"


/* USBB */
#define AVR32_USBB_NUM                     1

/* USBB */ 
#define AVR32_USBB_ADDRESS                 0xFFFE0000
#define AVR32_USBB                         (*((volatile avr32_usbb_t*)AVR32_USBB_ADDRESS))
#define AVR32_USBB_CLK_HSB                 35
#define AVR32_USBB_CLK_PBB                 97
#define AVR32_USBB_IRQ                     544
#define AVR32_USBB_EPT_NUM                 7
#define AVR32_USBB_ENABLE_TEST_0_PIN       14
#define AVR32_USBB_EOPN_TEST_0_PIN         0
#define AVR32_USBB_FS_TEST_0_PIN           1
#define AVR32_USBB_OEN_TEST_0_PIN          2
#define AVR32_USBB_ONN_TEST_0_PIN          3
#define AVR32_USBB_PDONDM_TEST_0_PIN       8
#define AVR32_USBB_PDONDP_TEST_0_PIN       9
#define AVR32_USBB_PUIDLE_TEST_0_PIN       11
#define AVR32_USBB_PUON_TEST_0_PIN         10
#define AVR32_USBB_RXDM_TEST_0_PIN         4
#define AVR32_USBB_RXDP_TEST_0_PIN         5
#define AVR32_USBB_RXD_TEST_0_PIN          6
#define AVR32_USBB_SCAN_CLOCK_0_PIN        62
#define AVR32_USBB_SESSVLD_TEST_0_PIN      12
#define AVR32_USBB_TXD_TEST_0_PIN          7
#define AVR32_USBB_USB_ID_0_0_PIN          11
#define AVR32_USBB_USB_ID_0_0_FUNCTION     1
#define AVR32_USBB_USB_ID_0_1_PIN          48
#define AVR32_USBB_USB_ID_0_1_FUNCTION     1
#define AVR32_USBB_USB_VBOF_0_0_PIN        12
#define AVR32_USBB_USB_VBOF_0_0_FUNCTION   1
#define AVR32_USBB_USB_VBOF_0_1_PIN        49
#define AVR32_USBB_USB_VBOF_0_1_FUNCTION   1
#define AVR32_USBB_VAVBUSVLD_TEST_0_PIN    13
#define AVR32_USBB_VBUSDISCHARGE_TEST_0_PIN 15
#define AVR32_USBB_VBUSPULSING_TEST_0_PIN  16

#include "avr32/usbb_260.h"


/* WDT */
#define AVR32_WDT_NUM                      1

/* WDT */ 
#define AVR32_WDT_ADDRESS                  0xFFFF0D30
#define AVR32_WDT                          (*((volatile avr32_wdt_t*)AVR32_WDT_ADDRESS))
#define AVR32_WDT_WDTEXTRST_MSB            1

#include "avr32/wdt_200.h"


/* PAD->GPIO bits mapping */
#define AVR32_PIN_PA00   0
#define AVR32_PIN_PA01   1
#define AVR32_PIN_PA02   2
#define AVR32_PIN_PA03   3
#define AVR32_PIN_PA04   4
#define AVR32_PIN_PA05   5
#define AVR32_PIN_PA06   6
#define AVR32_PIN_PA07   7
#define AVR32_PIN_PA08   8
#define AVR32_PIN_PA09   9
#define AVR32_PIN_PA10   10
#define AVR32_PIN_PA11   11
#define AVR32_PIN_PA12   12
#define AVR32_PIN_PA13   13
#define AVR32_PIN_PA14   14
#define AVR32_PIN_PA15   15
#define AVR32_PIN_PA16   16
#define AVR32_PIN_PA17   17
#define AVR32_PIN_PA18   18
#define AVR32_PIN_PA19   19
#define AVR32_PIN_PA20   20
#define AVR32_PIN_PA21   21
#define AVR32_PIN_PA22   22
#define AVR32_PIN_PA23   23
#define AVR32_PIN_PA24   24
#define AVR32_PIN_PA25   25
#define AVR32_PIN_PA26   26
#define AVR32_PIN_PA27   27
#define AVR32_PIN_PA28   28
#define AVR32_PIN_PA29   29
#define AVR32_PIN_PA30   30
#define AVR32_PIN_PB00   32
#define AVR32_PIN_PB01   33
#define AVR32_PIN_PB02   34
#define AVR32_PIN_PB03   35
#define AVR32_PIN_PB04   36
#define AVR32_PIN_PB05   37
#define AVR32_PIN_PB06   38
#define AVR32_PIN_PB07   39
#define AVR32_PIN_PB08   40
#define AVR32_PIN_PB09   41
#define AVR32_PIN_PB10   42
#define AVR32_PIN_PB11   43
#define AVR32_PIN_PB12   44
#define AVR32_PIN_PB13   45
#define AVR32_PIN_PB14   46
#define AVR32_PIN_PB15   47
#define AVR32_PIN_PB16   48
#define AVR32_PIN_PB17   49
#define AVR32_PIN_PB18   50
#define AVR32_PIN_PB19   51
#define AVR32_PIN_PB20   52
#define AVR32_PIN_PB21   53
#define AVR32_PIN_PB22   54
#define AVR32_PIN_PB23   55
#define AVR32_PIN_PB24   56
#define AVR32_PIN_PB25   57
#define AVR32_PIN_PB26   58
#define AVR32_PIN_PB27   59
#define AVR32_PIN_PB28   60
#define AVR32_PIN_PB29   61
#define AVR32_PIN_PB30   62
#define AVR32_PIN_PB31   63
#define AVR32_PIN_PC00   64
#define AVR32_PIN_PC01   65
#define AVR32_PIN_PC02   66
#define AVR32_PIN_PC03   67
#define AVR32_PIN_PC04   68
#define AVR32_PIN_PC05   69


#if !defined (DEPRECATED_DISABLE)

#define AVR32_ADC_ADC_CHANNELS_MSB         7
#define AVR32_ADC_ADC_DATA_MSB             9

#define AVR32_FREQM_FREQM_IRQ              42
#define AVR32_FREQM_FREQM_REFSEL_BITS      1

#define AVR32_GPIO_GPIO_IRQ_MSB            8
#define AVR32_GPIO_GPIO_PADDR_BITS         10
#define AVR32_GPIO_GPIO_PINS_MSB           69

#endif


/* #ifndef AVR32_UC3A1512ES_H_INCLUDED */
#endif
