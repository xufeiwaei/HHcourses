-c
-heap  0x400
-stack 0x400 /* very large stack for DSP programs. */
-lrts6201.lib

MEMORY
{
	INT_VEC       o = 00000000h  l = 00000200h
	BOOT_RAM:  o = 00000200h  l = 00000200h
	IRAM:           o = 00000800h  l = 0000f7ffh
}

SECTIONS
{
	"vectors"   > 		INT_VEC   fill = 0
	.boot_load  > 		BOOT_RAM  fill = 0
	.text       > 		IRAM      fill = 0
    .stack      >       IRAM
    .bss        >       IRAM 
    .const      >       IRAM
    .data       >       IRAM
    .far        >       IRAM
    .switch     >       IRAM
    .sysmem     >       IRAM
    .tables     >       IRAM
    .cio        >       IRAM
}                             

 
