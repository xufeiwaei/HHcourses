-c
-heap  0x400
-stack 0x400 /* very large stack for DSP programs. */
-lrts6201.lib
  
MEMORY{

	vecs:      o = 00000000h  l = 00000200h
	IRAM:      o = 00000200h  l = 0000FDE0h 

/*	IRAM:		o = 80000000h	l = 0000FFFFh */
	                           
}

SECTIONS{

    "vectors"   >       vecs
    .cinit      >       IRAM
    .text       >       IRAM
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

 
