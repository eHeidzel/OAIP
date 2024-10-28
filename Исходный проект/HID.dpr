 program HID;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  Cypher in 'Cypher.pas',
  Rand in 'Rand.pas',
  Picture in 'Picture.pas',
  Saves in 'Saves.pas',
  Conf in 'Conf.pas' {Form2},
  Loading in 'Loading.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, load);
  Application.CreateForm(TForm2, conff);
  Application.CreateForm(TForm1, mf);
  Application.Run;
end.
