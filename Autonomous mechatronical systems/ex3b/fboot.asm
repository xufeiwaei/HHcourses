        .title  "Flash boot for 6211 dsk"
        .option D,T
        .length 102
        .width  140

; Taken from blink example boot code, adapted for
; FlashBlink Demo and the FlashBurn application.
; R. Heeschen  TI Pittsburgh
;
; $Log: fboot.asm,v $
; Revision 1.1  2000/11/01 20:57:59  heeschen
; Initial version tested with FlashBurn v1.003.
; This is adapted from the 6211 DSK blink application.
;
;     

BOOT_SIZE     .equ    0x800       ;bootup code size in byte
FLASH_START   .equ    0x90000000  ;flash start address
BOOT_START    .equ    0x00000000  ;L2 sram start address

CODE_SIZE     .equ    0xF800      ;application code size in byte
CODE_START    .equ    0x800       ;application code start address

IO_PORT       .equ    0x90080000  ;address of I/O port, only top byte has valid data 
EMIF_GCR 	  .equ    0x01800000  ;EMIF global control     
EMIF_CE0      .equ    0x01800008  ;EMIF CE0control          
EMIF_SDCTRL   .equ    0x01800018  ;EMIF SDRAM control     
EMIF_SDRP     .equ    0x0180001c  ;EMIF SDRM refresh period 
EMIF_CE1_32   .equ    0xffffff23  ;
EMIF_CE0_V    .equ    0xffffff33  ;EMIF CE0control   ;0x30
EMIF_SDCTRL_V .equ    0x07117000  ;EMIF SDRAM control ;0x73380000    



  
 .global _boot

 .ref _c_int00
 .sect ".boot_load"
_boot:
            mvkl  EMIF_GCR,A4    ;EMIF_GCR address ->A4
      ||    mvkl  0x3300,B4      

            mvkh  EMIF_GCR,A4
      ||    mvkh  0x3300,B4  
                            
            stw   B4,*A4                

            mvkl  EMIF_CE0,A4       ;EMIF_CE0 address ->A4
      ||    mvkl  EMIF_CE0_V,B4     ;

            mvkh  EMIF_CE0,A4
      ||    mvkh  EMIF_CE0_V,B4
      
            stw   B4,*A4                
      ||    mvkl  EMIF_SDCTRL,A4    ;EMIF_SDCTRL address ->A4
      ||    mvkl  EMIF_SDCTRL_V,B4     ;

            mvkh  EMIF_SDCTRL,A4
      ||    mvkh  EMIF_SDCTRL_V,B4     
      
            stw   B4,*A4                
      ||    mvkl  EMIF_SDRP,A4      ;EMIF_SDRP address ->A4
      ||    mvkl  0x61a,B4    ;

            mvkh  EMIF_SDRP,A4
      ||    mvkh  0x61a,B4
            
            stw   B4,*A4
 

; Copy from Flash memory (slow!) to DSP memory
; (Fast!) and branch to start main code executing.

            mvkl  BOOT_START+1024,A4 ;ram start address ->A4
      ||    mvkl  FLASH_START+1024,B4 ;flash start address ->B4

            mvkh  BOOT_START+1024,A4
      ||    mvkh  FLASH_START+1024,B4   
       

            zero  A1
_boot_loop1:
            ldb   *B4++,B5
            mvkl  BOOT_SIZE-1024,B6 ;B6 = BOOT_SIZE -1024

            add   1,A1,A1          ;A1+=1,inc outer counter
      ||    mvkh  BOOT_SIZE-1024,B6
       
            cmplt A1,B6,B0
            nop   
            stb   B5,*A4++
      [B0]  b     _boot_loop1
            nop   5

            mvkl  CODE_START,A4 ;apps code start address ->A4
            mvkh  CODE_START,A4
            zero  A1
 
_boot_loop2:
            ldb   *B4++,B5
            mvkl  CODE_SIZE-4,B6 ;B6 = CODE_SIZE -1024

            add   1,A1,A1          ;A1+=1,inc outer counter
      ||    mvkh  CODE_SIZE-4,B6
       
            cmplt  A1,B6,B0
            nop    
            stb   B5,*A4++
      [B0]  b     _boot_loop2
            nop   5
        
            mvkl .S2 _c_int00, B0
            mvkh .S2 _c_int00, B0
            B    .S2 B0
            nop   5

  