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
// �������� �������� �� ���������
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

// ���������� ����� � ���������, ���������� �����������
procedure SaveLanguage(lang:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[0] := lang;
  WriteSettingsInFile(list);
  mf.Localize();
end;

// ���������� ��������-����� � ���������
procedure SavePictureKeyPath(path:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[1] := path;
  WriteSettingsInFile(list);
end;

// ���������� ��������-��������� � ���������
procedure SavePictureSourcePath(path:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[4] := path;
  WriteSettingsInFile(list);
end;

// ���������� �������� ������ ������������ � ���������
procedure SaveUserMode(mode:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[2] := mode;
  WriteSettingsInFile(list);

  mf.UpdateStateString;
end;

// ���������� �������� ������ ��������� � ���������
procedure SaveGenMode(mode:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[3] := mode;
  WriteSettingsInFile(list);
end;

// ���������� �������� ������ ���������� � ���������
procedure SaveCryptMode(mode:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[5] := mode;
  WriteSettingsInFile(list);
  mf.UpdateStateString;
end;

// ���������� ���� � ����� ��� ���������� � ���������
procedure SaveFilePath(path:string);
var
  list: TStringlist;
begin
  list := ReadSettingsFile();
  list[6] := path;
  WriteSettingsInFile(list);
end;

// ���������� ��������
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

// ��������� �������� ����������� �����
function GetLang():string;
begin
   Result := ReadSettingsFile[0];
end;

// ��������� �������� ����������� ���� � ��������-�����
function GetPictureKeyPath():string;
begin
   Result := ReadSettingsFile[1];
end;

// ��������� �������� ����������� ���� � �����
function GetFilePath():string;
begin
   Result := ReadSettingsFile[6];
end;

// ��������� �������� ����������� ���� � ��������-���������
function GetPictureSourcePath():string;
begin
   Result := ReadSettingsFile[4];
end;

// ��������� �������� ������ ������������
function GetUserMode():string;
begin
   Result := ReadSettingsFile[2];
end;

// ��������� �������� ������ ��������� ������ �����
function GetGenMode():string;
begin
   Result := ReadSettingsFile[3];
end;

// ��������� �������� ������ ���������� �����
function GetCryptMode():string;
begin
   Result := ReadSettingsFile[5];
end;

// ������ ���� ��������
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

// ������ ���� �������� � ����
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

// ������� ��� ��������� ����
function GetPath():string;
begin
  var path:='';
  var OpenDialog := TOpenDialog.Create(nil);
  if OpenDialog.Execute then
    path := OpenDialog.FileName;

  Result:= path
end;

// ���������� ���� � �����
procedure SelectFilePath();
begin
  var path := GetPath;
  if path <> '' then
    SaveFilePath(path);
end;

// ���������� ���� � ��������-�����
procedure Selectkeypath();
begin
  var path := GetPath;
  if path <> '' then
    SavePictureKeyPath(path);
end;

// ���������� ���� � ��������-���������
procedure Selectsourcepath();
begin
  var path := GetPath;
  if path <> '' then
    SavePictureSourcePath(path);
end;
end.
