unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Cypher, Picture, Rand, Vcl.Imaging.pngimage, jpeg,
  Vcl.Buttons, Vcl.Menus, Vcl.WinXCtrls, Saves, Conf, Loading, math, ShellAPI,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    mm: TMainMenu;
    Settings1: TMenuItem;
    OpenForm1: TMenuItem;
    Swithlanquage1: TMenuItem;
    SwitchCG1: TMenuItem;
    SwitchCC1: TMenuItem;
    Selectkeypath1: TMenuItem;
    Selectsourcepath1: TMenuItem;
    Fi1: TMenuItem;
    Close1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Switchsourcemode1: TMenuItem;
    Reference1: TMenuItem;
    Projectreference1: TMenuItem;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    Selectfilepath1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure OpenForm1Click(Sender: TObject);
    procedure SwitchCG1Click(Sender: TObject);
    procedure SwitchCC1Click(Sender: TObject);
    procedure Swithlanquage1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Selectkeypath1Click(Sender: TObject);
    procedure Selectsourcepath1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure UpdateStateString;
    procedure Localize();
    procedure Switchsourcemode1Click(Sender: TObject);
    procedure LoadPic();
    procedure Selectfilepath1Click(Sender: TObject);
    procedure Projectreference1Click(Sender: TObject);
    private

    public
    var key_small_for_encode:string;
        key_small_for_decode:string;
    { Public declarations }
  end;

var
  MF: TForm1;

implementation

{$R *.dfm}
// обновить надпись с описанием текущего состояния приложения(настроек)
procedure Tform1.UpdateStateString;
var userModeRenamed, pictureModeRenamed:string;
begin
  if getlang = 'en' then begin
    if getusermode = 'creator' then
      userModeRenamed := 'key creator'
    else
      userModeRenamed := 'user';
    if GetCryptMode = 'pic' then
      pictureModeRenamed := 'decrypt'
    else
      pictureModeRenamed := 'encrypt';

    label1.Caption := 'Type of user: ' + userModeRenamed;
    label4.Caption := 'Type of encryption: ' + pictureModeRenamed;
  end
  else begin
    if getusermode = 'creator' then
      userModeRenamed := 'создатель ключа'
    else
      userModeRenamed := 'пользователь';
    if GetCryptMode = 'pic' then
      pictureModeRenamed := 'дешифровать'
    else
      pictureModeRenamed := 'зашифровать';

    label1.Caption := 'Тип пользователя : ' + userModeRenamed;
    label4.Caption := 'Вид шифрования : ' + pictureModeRenamed;
  end;
end;

// закрытие по нажатию пункта меню
procedure TForm1.Close1Click(Sender: TObject);
begin
  mf.Close;
  Loading.load.Close;
end;

// полное закрытие приложения по кнопке
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Loading.load.Close;
end;

// функция, оотвечающая за локализацию приложения
procedure TForm1.Localize();
begin
  UpdateStateString;
  if GetLang = 'en' then begin
    label2.Caption := 'For details, go to the settings form';
    conff.Caption := 'settings form';
    load.Caption := 'loading';
    label5.Caption := 'Short state:';
    mm.Items[0].Caption := 'File';
    mm.Items[0].Items[0].Caption := 'Close';

    mm.Items[1].Caption := 'Settings';
    mm.Items[1].Items[0].Caption := 'Open settings form';
    mm.Items[1].Items[1].Caption := 'Switch language';
    mm.Items[1].Items[2].Caption := 'Switch generate mode';
    mm.Items[1].Items[3].Caption := 'Switch user mode';
    mm.Items[1].Items[4].Caption := 'Switch encryption mode';
    mm.Items[1].Items[5].Caption := 'Select key';
    mm.Items[1].Items[6].Caption := 'Select source';
    mm.Items[1].Items[7].Caption := 'Select file';

    mm.Items[2].Caption := 'Reference';
    mm.Items[2].Items[0].Caption := 'Project reference';

    conff.Label2.Caption := 'Russian/English';
    conff.Label3.Caption := 'User/Key creator';
    conff.Label4.Caption := 'Use cryptoproof numbers?';
    conff.Label8.Caption := 'Encrypt/Decrypt';
    conff.Label1.Caption := 'Select key';
    conff.Label5.Caption := 'Select source';
    conff.Label11.Caption := 'Select file';
    conff.Label9.Caption := 'For changes to take effect, close the form';
    conff.Button1.Caption := 'Main';

    mf.key_small_for_encode := 'File too large, cannot be encoded';
    mf.key_small_for_decode := 'The key bytes are not enough to decode the data';
  end
  else begin
    label2.Caption := 'За подробностями перейдите на форму настроек';
    conff.Caption := 'форма настроек';
    load.Caption := 'загрузка';
    label5.Caption := 'Краткое состояние:';
    mm.Items[0].Caption := 'Файл';
    mm.Items[0].Items[0].Caption := 'Закрыть';

    mm.Items[1].Caption := 'Настройки';
    mm.Items[1].Items[0].Caption := 'Открыть форму настроек';
    mm.Items[1].Items[1].Caption := 'Переключить язык';
    mm.Items[1].Items[2].Caption := 'Переключить вид генерации';
    mm.Items[1].Items[3].Caption := 'Переключить вид пользователя';
    mm.Items[1].Items[4].Caption := 'Переключить вид шифрования';
    mm.Items[1].Items[5].Caption := 'Выбрать ключ';
    mm.Items[1].Items[6].Caption := 'Выбрать источник';
    mm.Items[1].Items[7].Caption := 'Выбрать файл';

    mm.Items[2].Caption := 'Справка';
    mm.Items[2].Items[0].Caption := 'Справка проекта';

    conff.Label2.Caption := 'Русский/Английский';
    conff.Label3.Caption := 'Пользователь/Создатель ключа';
    conff.Label4.Caption := 'Использовать криптостойкие числа?';
    conff.Label8.Caption := 'Зашифровать/Дешифровать';
    conff.Label1.Caption := 'Выбрать ключ';
    conff.Label5.Caption := 'Выбрать источник';
    conff.Label11.Caption := 'Указать файл';
    conff.Label9.Caption := 'Чтобы изменения вступили в силу, закройте форму';
    conff.Button1.Caption := 'Главная';

    mf.key_small_for_encode := 'Слишком большой файл, невозможно закодировать';
    mf.key_small_for_decode := 'Байт ключа недостаточно, чтобы декодировать данные';
  end;
end;

// загрузка картинки, которая показывает какой процесс настроен
procedure Tform1.LoadPic();
var filename: string;
begin
  filename := extractFilePath(paramstr(0)) + PathDelim + 'imgs' +  PathDelim;
  var pic := TPicture.Create;
  if getUsermode = 'creator' then
    filename := filename + 'c_key.png'
  else if getcryptmode = 'pic' then
    filename := filename + 'decode.png'
  else filename := filename + 'encode.png';

  pic.LoadFromFile(filename);
  Image1.Picture := pic;
  image1.update;
end;

// первоначальная настройка формы
procedure TForm1.FormCreate(Sender: TObject);
begin
  GenSettingsFileIfNotExists;
  LoadKeyPng;
  LoadFilePng;
  LoadPic;
  Localize;
end;

// открытие формы настроек
procedure TForm1.OpenForm1Click(Sender: TObject);
begin
  ConfF.ShowModal;
end;

// открытие справки
procedure TForm1.Projectreference1Click(Sender: TObject);
begin
  ShellExecute(0, PChar('Open'),PChar(extractFilePath(paramstr(0)) + 'HID.chm'),nil,nil,SW_SHOW);
end;

// выбор пути к файлу
procedure TForm1.Selectfilepath1Click(Sender: TObject);
begin
  SelectFilePath;
end;

// выбор пути к картинке-ключу
procedure TForm1.Selectkeypath1Click(Sender: TObject);
begin
  Selectkeypath;
end;

// выбор пути к картинке-источнику
procedure TForm1.Selectsourcepath1Click(Sender: TObject);
begin
  Selectsourcepath;
end;

// реализация выбранного процесса по нажатию кнопки
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if getusermode = 'creator' then begin
    EncryptPicture();
    pngForWork.SaveResult(GetPictureKeyPath);
  end
  else begin
    if Saves.GetCryptMode = 'npic' then begin
      EncryptFile();
    end
    else begin
      DecryptFile();
    end;
  end;
end;

// смена пользователя
procedure TForm1.SwitchCC1Click(Sender: TObject);
begin
  if GetUserMode = 'consumer' then
    SaveUserMode('creator')
  else
    SaveUserMode('consumer');

  LoadPic;
end;

// смена вида генерации байтов ключа
procedure TForm1.SwitchCG1Click(Sender: TObject);
begin
  if GetGenMode = 'nc' then
    SaveGenMode('cn')
  else
    SaveGenMode('nc')
end;

// смена шифрования/дешифрования
procedure TForm1.Switchsourcemode1Click(Sender: TObject);
begin
  if GetCryptMode = 'pic' then
    SaveCryptMode('npic')
  else
    SaveCryptMode('pic');
  LoadPic;
end;

// смена языка
procedure TForm1.Swithlanquage1Click(Sender: TObject);
begin
  if Getlang = 'en' then
    SaveLanguage('ru')
  else
    SaveLanguage('en')
end;
end.
