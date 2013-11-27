unit dsk6x11hpi;

interface

Uses Windows;


// Enumeration used with dsk_board_type
//------------------------------------------------------------------------------
Type TdskDLL_BOARD_TYPE = (
  TYPE_UNKNOWN  = 0,
  TYPE_6211_DSK = 1,
  TYPE_6711_DSK = 2
  );
  PdskDLL_BOARD_TYPE = ^TdskDLL_BOARD_TYPE;


// DSK Public Handle declaration
//------------------------------------------------------------------------------
type TdskHANDLE = Pointer;




//------------------------------------------------------------------------------
Function dsk6x_open      (BoardFile: PChar; var Handle: TdskHANDLE): Bool; stdcall; external 'dsk6x11hpi.dll';
Function dsk6x_close     (                      Handle: TdskHANDLE): Bool; stdcall; external 'dsk6x11hpi.dll';

Function dsk6x_hpi_open  (                      Handle: TdskHANDLE): Bool; stdcall; external 'dsk6x11hpi.dll';
Function dsk6x_hpi_close (                      Handle: TdskHANDLE): Bool; stdcall; external 'dsk6x11hpi.dll';


Function dsk6x_hpi_read  (Handle: TdskHANDLE; Data: Pointer ; var NumBytes: Cardinal ; Address: Cardinal  ): Bool; stdcall; external 'dsk6x11hpi.dll';
Function dsk6x_hpi_write (Handle: TdskHANDLE; Data: Pointer ; var NumBytes: Cardinal ; Address: Cardinal  ): Bool; stdcall; external 'dsk6x11hpi.dll';



           {

extern BOOL  dsk6x_open(char *, dskHANDLE*);
extern BOOL  dsk6x_close(dskHANDLE );
extern BOOL  dsk6x_board_type( dskHANDLE , PdskDLL_BOARD_TYPE, unsigned short *);           
extern BOOL  dsk6x_hpi_open(dskHANDLE );
extern BOOL  dsk6x_hpi_close(dskHANDLE );
extern BOOL  dsk6x_reset_dsp(dskHANDLE,unsigned char,unsigned char);
extern BOOL  dsk6x_reset_board(dskHANDLE);
extern BOOL  dsk6x_hpi_read(dskHANDLE ,unsigned long *, unsigned long *, unsigned long);
extern BOOL  dsk6x_hpi_write(dskHANDLE ,unsigned long *,unsigned long *, unsigned long);
extern BOOL  dsk6x_hpi_fill(dskHANDLE ,unsigned long,unsigned long *,unsigned long);
extern BOOL  dsk6x_hpi_generate_int(dskHANDLE );
extern int   dsk6x_coff_load(dskHANDLE ,char *, BOOL, BOOL, BOOL);


}

implementation

end.
