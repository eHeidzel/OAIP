unit Conf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Buttons, saves;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ToggleSwitch1: TToggleSwitch;
    ToggleSwitch2: TToggleSwitch;
    ToggleSwitch3: TToggleSwitch;
    Button1: TButton;
    Label5: TLabel;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    SpeedButton1: TSpeedButton;
    Label8: TLabel;
    ToggleSwitch4: TToggleSwitch;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    SpeedButton3: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Save();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfF: TForm2;

implementation

{$R *.dfm}
uses cypher;
//сохранение настроек и закрытие формы по кнопке
procedure TForm2.Button1Click(Sender: TObject);
begin
  Save;
  Close;
end;

//сохранение настроек
procedure TForm2.Save();
var lang, um, gm, pm:string;
begin
  if ToggleSwitch1.State = tssOn then
  lang := 'en'
else
  lang := 'ru';

if ToggleSwitch2.State = tssOn then
  um := 'creator'
else
  um := 'consumer';

if ToggleSwitch3.State = tssOn then
  gm := 'cn'
else
  gm := 'nc';

if ToggleSwitch4.State = tssOn then
  pm := 'pic'
else
  pm := 'npic';

UpdateSettings(lang, um, gm, pm);
Loadkeypng;
end;

// выбор картинки для ключа по кнопке
procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
  Selectkeypath;
  label6.Caption := GetPictureKeyPath;
end;

// выбор картинки для хранения закодированного файла по кнопке
procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
  Selectsourcepath;
  label7.Caption := GetPictureSourcePath;
end;

// выбор файла для кодирования по кнопке
procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
  Selectfilepath;
  label10.Caption := GetFilePath;
end;

// загрузка всех значений настроек
procedure TForm2.FormActivate(Sender: TObject);
begin
  if GetLang = 'en' then
    ToggleSwitch1.State := tssOn
  else
    ToggleSwitch1.State := tssOff;

  if GetUserMode = 'creator' then
    ToggleSwitch2.State := tssOn
  else
    ToggleSwitch2.State := tssOff;

  if GetGenMode = 'cn' then
    ToggleSwitch3.State := tssOn
  else
    ToggleSwitch3.State := tssOff;

  if GetCryptMode = 'pic' then
    ToggleSwitch4.State := tssOn
  else
    ToggleSwitch4.State := tssOff;

  label6.Caption := GetPictureKeyPath;
  label7.Caption := GetPictureSourcePath;
  label10.Caption := GetFilePath;
end;

//сохранение настроек при закрытии
procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Save;
end;
end.
