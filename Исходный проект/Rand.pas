unit Rand;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, Saves;

function GenerateRandomBytes(len: ulong):TArray<Byte>;
function ReadData():TArray<Byte>;
function ListToArray(list:Tlist):Tarray<Byte>;

implementation

uses Main;
// генерация случайных байтов ключа
function GenerateRandomBytes(len: ulong):TArray<Byte>;
begin
  if Saves.GetGenMode = 'cn' then begin
    ShellExecute(0, 'open', 'Rand.exe', PChar(PWideString(UIntToStr(len))), nil, SW_SHOWNORMAL);
    sleep(10000);        //костыль
    Result:= ReadData();
  end
  else begin
    var arr: TArray<Byte>;
    setLength(arr, len);
    for var i := 0 to len-1 do begin
      arr[i] := Random(256);
    Result:= arr;
    end;
  end;
end;

// чтение байтов, сгенерированных отдельным приложением
function ReadData():TArray<Byte>;
var
  f: file of byte;
  list: Tlist;
  b:byte;
begin
  Reset(f, 'data.dat');

  list := Tlist.Create();
  while not eof(f) do
  begin
    read(f, b);
    list.Add(Pointer(b))
  end;

  Close(F);

  Result:= ListToArray(list);
end;

// перевод списка в массив
function ListToArray(list:Tlist):Tarray<Byte>;
var arr: TArray<Byte>;
begin
  SetLength(arr, list.Count);
  for var i:=0 to list.Count - 1 do
    arr[i] := Integer(list[i]);

  Result:= arr;
end;
end.
