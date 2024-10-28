unit Loading;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    await:integer;
  end;

var
  load: TForm3;

implementation
uses Main;

// активация формы при конце загрузки
procedure TForm3.Timer1Timer(Sender: TObject);
begin
  ProgressBar1.StepBy(1);
  if ProgressBar1.Position = ProgressBar1.Max then begin
    await := await - 1;
    if await = 0 then begin
      Timer1.Enabled := False;
      hide;
      mf.Show();
    end;
  end;
end;

{$R *.dfm}

// установка значений по умолчанию для загрузки и запуск таймера
procedure TForm3.FormCreate(Sender: TObject);
begin
  await := 40;
  ProgressBar1.Max := 100;
  ProgressBar1.Position := 0;
  Timer1.Enabled := True;
end;
end.
