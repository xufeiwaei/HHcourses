program View6000;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  dsk6x11hpi in 'dsk6x11hpi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
