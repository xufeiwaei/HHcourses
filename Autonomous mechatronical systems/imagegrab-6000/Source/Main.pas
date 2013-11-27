unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, ComCtrls;


//------------------------------------------------------------------------------
Type TPixel = Record
  Red     : Byte;
  Green   : Byte;
  Blue    : Byte;
  Reserved: Byte;
end;
Type PPixel= ^TPixel;

Type TRGBTripleArray = Array[WORD] of TRGBTriple;
Type PRGBTripleArray = ^TRGBTripleArray;


//------------------------------------------------------------------------------
type TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ScanButton: TButton;
    AddressEdit: TEdit;
    ImageWidthEdit: TEdit;
    ImageHeightEdit: TEdit;
    StatusBar1: TStatusBar;
    SaveButton: TButton;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    procedure ScanButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BoardFile: String;

  end;

//------------------------------------------------------------------------------
Const DefaultBoard = 'dsk6x11.cfg';

var
  Form1: TForm1;
  ProgramDir: String;

implementation

{$R *.dfm}

Uses dsk6x11hpi;

var hBd        : TdskHANDLE;
var Image      : Array[0..640*480-1] of Cardinal;



//------------------------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
begin
  ProgramDir:=ExtractFilePath(ParamStr(0));

  BoardFile:= ProgramDir + DefaultBoard;

  // Check that the config file exists.
  IF not FileExists(BoardFile) then
    raise exception.Create('FAILED: ' + BoardFile + ' not found!');

	// Open a driver connection to a dsk6x board.
	if not dsk6x_open(PChar(BoardFile), hBd ) then
    raise exception.Create('FAILED: dsk6x_open()!');

	// Establish a connection to the HPI of a target board.
	if not dsk6x_hpi_open( hBd ) then
    raise exception.Create('FAILED: dsk6x_hpi_open()!');

  ScanButton.Enabled:=True;
  SaveButton.Enabled:=True;
end;

//------------------------------------------------------------------------------
procedure TForm1.ScanButtonClick(Sender: TObject);
var ImageAdr   : Cardinal;
var ImageWidth : Integer;
var ImageHeight: Integer;
var ImageSize  : Integer;
var Pixel      : PPixel;
var X,Y        : Integer;
var Index      : Integer;
var NbrOfByte  : Cardinal;
var Line       : PRGBTripleArray;
begin
  Screen.Cursor:=crHourGlass;
  StatusBar1.Panels[0].Text:='Reading image...';
  Refresh;

  ImageWidth :=StrToIntDef(ImageWidthEdit .Text, 320);
  ImageHeight:=StrToIntDef(ImageHeightEdit.Text, 240);
  ImageAdr   :=StrToIntDef(AddressEdit    .Text,   0);

 	ImageSize:= ImageWidth * ImageHeight;

  IF ImageAdr = 0 then
    raise exception.Create('FAILED: Startadress null!');

  NbrOfByte:= ImageSize *4;
  if not dsk6x_hpi_read(hBd, Addr(Image), NbrOfByte, ImageAdr) then
    raise exception.Create('FAILED: dsk6x_hpi_read()!');

  Image1.Width :=ImageWidth;
  Image1.Height:=ImageHeight;
  with Image1.Picture.Bitmap do begin
    PixelFormat:=pf24Bit;
    Width      :=ImageWidth;
    Height     :=ImageHeight;

    Index:=0;
    for Y:=0 to ImageHeight-1 do begin
      Line:=ScanLine[Y];
      for X:=0 to ImageWidth-1 do begin
        Pixel:= @TPixel(Image[Index]);

        Line[X].rgbtRed  :=Pixel.Red;
        Line[X].rgbtGreen:=Pixel.Green;
        Line[X].rgbtBlue :=Pixel.Blue;

       Inc(Index);
      end;
    end;
  end;

  Screen.Cursor:=crDefault;
  StatusBar1.Panels[0].Text:='';
  Refresh;
end;


//------------------------------------------------------------------------------
procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  IF SavePictureDialog1.Execute then begin
    Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

end.
