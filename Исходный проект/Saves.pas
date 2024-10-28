unit Saves;


interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi;

procedure GenSettingsFileIfNotExists();
procedure SaveLanguage(lang:string);
procedure SavePictureKeyPath(path:string);
procedure SavePictureSourcePath(path:string);
procedure SaveFilePath(path:string);
procedure SaveUserMode(mode:string);
procedure SaveGenMode(mode:string);
procedure SaveCryptMode(mode:string);
procedure UpdateSettings(lang, um, gm, pm:string);
function GetLang():string;
function GetPictureKeyPath():string;
function GetPictureSourcePath():string;
function GetUserMode():string;
function GetGenMode():string;
function GetCryptMode():string;
function GetFilePath():string;
function ReadSettingsFile():TStringlist;
procedure WriteSettingsInFile(list:TStringlist);
function GetPath():string;
procedure Selectkeypath();
procedure Selectsourcepath();
procedure SelectFilePath();

implementation
uses Main;
// создание настроек по умолчанию
procedure GenSettingsFileIfNotExists();
var F:TextFile;
begin
  if not FileExists(extractFilePath(paramstr(0)) + 'settings.txt') then begin
    AssignFile(F, extractFilePath(paramstr(0)) + 'settings.txt');
    Rewrite(F);
    writeln(F, 're');
    writeln(F, extractFilePath(paramstr(0)) + 'ex' +  PathDelim + 'key.png');
    writeln(F, 'creator');
    writeln(F, 'cn');
    writeln(F, extractFilePath(paramstr(0))	+ 'ex' +  PathDelim + 'source.png');
    writeln(F, 'pic');
    writeln(F, extractFilePath(paramstr(0)) + 'ex' +  PathDelim + 'test.txt');
    close(F);
  end;
end;

// сохранение языка в настройки, обновление локализации
procedure SaveLanguage(lang:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[0] := lang;
  WriteSettingsInFile(list);
  mf.Localize();
end;

// сохранение картинки-ключа в настройки
procedure SavePictureKeyPath(path:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[1] := path;
  WriteSettingsInFile(list);
end;

// сохранение картинки-источника в настройки
procedure SavePictureSourcePath(path:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[4] := path;
  WriteSettingsInFile(list);
end;

// сохранение текущего режима пользователя в настройки
procedure SaveUserMode(mode:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[2] := mode;
  WriteSettingsInFile(list);

  mf.UpdateStateString;
end;

// сохранение текущего режима генерации в настройки
procedure SaveGenMode(mode:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[3] := mode;
  WriteSettingsInFile(list);
end;

// сохранение текущего режима шифрования в настройки
procedure SaveCryptMode(mode:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[5] := mode;
  WriteSettingsInFile(list);
  mf.UpdateStateString;
end;

// сохранение пути к файлу для шифрования в настройки
procedure SaveFilePath(path:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[6] := path;
  WriteSettingsInFile(list);
end;

// обновление настроек
procedure UpdateSettings(lang, um, gm, pm:string);
var list: TStringlist;
begin
  list := ReadSettingsFile;
  list[0] := lang;
  list[2] := um;
  list[3] := gm;
  list[5] := pm;

  WriteSettingsInFile(list);
  mf.Localize;
  mf.LoadPic;
end;

// получение текущего сохранённого языка
function GetLang():string;
begin
   Result := ReadSettingsFile[0];
end;

// получение текущего сохранённого пути к картинке-ключу
function GetPictureKeyPath():string;
begin
   Result := ReadSettingsFile[1];
end;

// получение текущего сохранённого пути к файлу
function GetFilePath():string;
begin
   Result := ReadSettingsFile[6];
end;

// получение текущего сохранённого пути к картинке-источнику
function GetPictureSourcePath():string;
begin
   Result := ReadSettingsFile[4];
end;

// получение текущего режима пользователя
function GetUserMode():string;
begin
   Result := ReadSettingsFile[2];
end;

// получение текущего режима генерации байтов ключа
function GetGenMode():string;
begin
   Result := ReadSettingsFile[3];
end;

// получение текущего режима шифрования ключа
function GetCryptMode():string;
begin
   Result := ReadSettingsFile[5];
end;

// чтение всех настроек
function ReadSettingsFile():TStringlist;
var
  F:textFile;
  list: TStringlist;
  s:string;
begin
  list := TStringList.Create();
  AssignFile(F, extractFilePath(paramstr(0)) + 'settings.txt');
  Reset(F);

  while not eof(F) do begin
    readln(F, s);
    list.Add(s);
  end;

  close(F);
  Result := list;
end;

// запись всех настроек в файл
procedure WriteSettingsInFile(list:TStringlist);
var
  F:textFile;
  s:string;
begin
  AssignFile(F, extractFilePath(paramstr(0)) + 'settings.txt');
  Rewrite(F);
  for var i := 0 to list.Count-1 do begin
    s := list[i];
    writeln(F, s);
  end;
  close(F);
end;

// функция для получения пути
function GetPath():string;
begin
  var path:='';
  var OpenDialog := TOpenDialog.Create(nil);
  if OpenDialog.Execute then
    path := OpenDialog.FileName;

  Result:= path
end;

// сохранение пути к файлу
procedure SelectFilePath();
begin
  var path := GetPath;
  if path <> '' then
    SaveFilePath(path);
end;

// сохранение пути к картинке-ключу
procedure Selectkeypath();
begin
  var path := GetPath;
  if path <> '' then
    SavePictureKeyPath(path);
end;

// сохранение пути к картинке-источнику
procedure Selectsourcepath();
begin
  var path := GetPath;
  if path <> '' then
    SavePictureSourcePath(path);
end;
end.
