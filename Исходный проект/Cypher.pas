unit Cypher;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Rand, Vcl.Imaging.pngimage, Picture;

var
  pngForWork,pngForFile:Png;
function EncryptDecryptByte(source:TColor; key: byte):Tcolor;
function DecryptDecryptByte(source:TColor):byte;
function HigherShapeFilter(c:byte):byte;
function GetEncryptedShape(c:byte; en:char):byte;
function GetDecryptedBytes(count:integer):TArray<Byte>;
procedure EncryptPicture();
procedure EncryptFile();
procedure DecryptFile();
procedure LoadKeyPng();
procedure LoadFilePng();
procedure writebytestopic(pic:PNG; bytes:TArray<Byte>);
function GetFileBytes():TArray<Byte>;
procedure SaveSizeToPic(len:Int64);
function GetSizeFromPic():int64;
function GetPosXFromPic():int64;
procedure SavePosXToPic(num:int64);
function GetPosYFromPic():int64;
procedure SavePosYToPic(num:int64);
procedure SetPosXYToDefault();
procedure SaveNameToPic(const name:string);
function GetNameFromPic():string;


implementation
uses Saves, Main;
// загрузка картинки-ключа в переменную
procedure LoadKeyPng();
begin
  pngForWork := Png.Create(GetPictureKeyPath);
  pngForWork.picture.RemoveTransparency();
end;

// загрузка картинки-источника в переменную
procedure LoadFilePng();
begin
  pngForFile := Png.Create(GetPictureSourcePath);
  pngForFile.picture.RemoveTransparency();
end;

// сохранение названия файла в картинку-источник
procedure SaveNameToPic(const name:string);
var Bytes: TArray<byte>;
      color: Tcolor;
begin
  bytes := TEncoding.UTF8.GetBytes(name);
  SetLength(Bytes, 64);
  for var i:= 8 to 71 do begin
    color := EncryptDecryptByte(pngForFile.GetPixelColor(i, 0), bytes[i-8]);
    pngForFile.SetPixelColor(i, 0, color);
  end;

  pngForFile.SaveResult(GetPictureSourcePath);
end;

// получение названия файла из картинки-источника
function GetNameFromPic():string;
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 64);
  for var i:= 8 to 71 do begin
    color := pngforfile.GetPixelColor(i, 0);
    bytes[i-8] := DecryptDecryptByte(color);
  end;

  Result := TEncoding.UTF8.GetString(bytes);
end;

// получение размера файла из картинки-источника
function GetSizeFromPic():int64;
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 8);
  for var i:=0 to 7 do begin
    color := pngforfile.GetPixelColor(i, 0);
    bytes[i] := DecryptDecryptByte(color);
  end;

  Result := PInteger(@Bytes[0])^;
end;

// сохранение размера файла в картинку-источник
procedure SaveSizeToPic(len:Int64);
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 8);
  Move(len, Bytes[0], SizeOf(Int64));

  for var i:= 0 to 7 do begin
    color := EncryptDecryptByte(pngForFile.GetPixelColor(i, 0), bytes[i]);
    pngForFile.SetPixelColor(i, 0, color);
  end;

  pngForFile.SaveResult(GetPictureSourcePath);
end;

// сохранение x координаты в картинку-ключ
procedure SavePosXToPic(num:Int64);
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 8);
  Move(num, Bytes[0], SizeOf(Int64));

  for var i:= 0 to 7 do begin
    color := EncryptDecryptByte(pngForwork.GetPixelColor(i, 0), bytes[i]);
    pngForwork.SetPixelColor(i, 0, color);
  end;

  pngForwork.SaveResult(GetPictureKeyPath);
end;

// чтение x координаты из картинки-ключa
function GetPosXFromPic():int64;
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 8);
  for var i:= 0 to 7 do begin
    color := pngforwork.GetPixelColor(i, 0);

    bytes[i] := DecryptDecryptByte(color);
  end;

  Result := PInteger(@Bytes[0])^;
end;

// сохранение y координаты в картинку-ключ
procedure SavePosYToPic(num:Int64);
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 8);
  Move(num, Bytes[0], SizeOf(Int64));

  for var i:= 8 to 15 do begin
    color := EncryptDecryptByte(pngForWork.GetPixelColor(i, 0), bytes[i-8]);
    pngForWork.SetPixelColor(i, 0, color);
  end;

  pngForwork.SaveResult(GetPictureKeyPath);
end;

// чтение y координаты из картинки-ключa
function GetPosYFromPic():int64;
  var Bytes: TArray<byte>;
      color: Tcolor;
begin
  SetLength(Bytes, 8);
  for var i:= 8 to 15 do begin
    color := pngforwork.GetPixelColor(i, 0);
    bytes[i-8] := DecryptDecryptByte(color);
  end;

  Result := PInteger(@Bytes[0])^;
end;

// установка значений по умолчанию для позиций x и y
procedure SetPosXYToDefault();
var color: Tcolor;
begin
  SavePosXToPic(0);
  SavePosYToPic(1);
end;

// закодировать байт в цвет
function EncryptDecryptByte(source:TColor; key: byte):TColor;
var r, g, b:byte;
begin   
    var keyLikeStr := inttostr(key);
    if keyLikeStr.Length = 1 then keyLikeStr := '00' + keyLikeStr;
    if keyLikeStr.Length = 2 then keyLikeStr := '0' + keyLikeStr;

    r := GetEncryptedShape(HigherShapeFilter(GetRValue(source)), keyLikeStr[1]);
    g := GetEncryptedShape(HigherShapeFilter(GetGValue(source)), keyLikeStr[2]);
    b := GetEncryptedShape(HigherShapeFilter(GetBValue(source)), keyLikeStr[3]);

    var color := RGB(r, g, b);
    Result:= color;
end;

// функция для корректной записи в цвет
function HigherShapeFilter(c:byte):byte;
begin
    if c >= 250 then c := c - 10;
    Result := c;
end;

// кодирование одной 1/3 через 1/3 байта ключа
function GetEncryptedShape(c:byte; en:char):byte;
begin
    Result := c - c mod 10 + strtoint(en);
end;

// декодирование зашифрованного байта из цвета
function DecryptDecryptByte(source:TColor):byte;
var r, g, b:byte;
begin
    r := (GetRValue(source) mod 10) * 100;
    g := (GetGValue(source) mod 10) * 10;
    b := GetBValue(source) mod 10;
    Result:= r + g + b;
end;

// кодирование картинки-ключа
procedure EncryptPicture();
var 
  bytes: Tarray<Byte>;
begin
  bytes := GenerateRandomBytes(pngForWork.size);
  writebytestopic(pngforwork,bytes);
  SetPosXYToDefault;
end;

// запись байтов в картинку
procedure writebytestopic(pic:PNG; bytes:TArray<Byte>);
var color, encryptedColor:TColor;
begin
  var counter := 0;
    for var y := 1 to pic.picture.Width - 1 do begin
    for var x := 0 to pic.picture.Height - 1 do begin
      color := pic.GetPixelColor(x, y);
      encryptedColor := EncryptDecryptByte(color, bytes[counter]);
      pic.SetPixelColor(x, y, encryptedColor);
      counter := counter + 1;
      if counter >= length(bytes) then
        break
    end;
    if counter >= length(bytes) then
        break
  end;
end;

// шифрование файла
procedure EncryptFile();
var
  FileStream: TFileStream;
  bytes: TArray<Byte>;
begin
  LoadKeyPng;
  LoadFilePng;

  FileStream := TFileStream.Create(GetFilePath, fmOpenRead);
  try
    SetLength(bytes, FileStream.Size);
    FileStream.ReadBuffer(bytes[0], FileStream.Size);
  finally
    FileStream.Free;
  end;

  if length(bytes) > pngForWork.size then begin
     messageDlg(mf.key_small_for_encode, mtError, [mbOK],0);
     exit
  end;

  var encryptedBytes := GetDecryptedBytes(Length(bytes));
  for var i := 0 to Length(bytes) - 1 do begin
//    showmessage(IntToStr(encryptedBytes[i]));
    bytes[i] := bytes[i] xor encryptedBytes[i];
  end;

  SaveSizeToPic(length(bytes));
  SaveNameToPic(ExtractFileName(GetFilePath));
  writebytestopic(pngForFile, bytes);
  pngforfile.SaveResult(GetPictureSourcePath);
end;

// декодирование файла
procedure DecryptFile();
var
  color:TColor;
  FileStream: TFileStream;
begin
  LoadKeyPng;
  LoadFilePng;

  var fileBytes := GetFileBytes;
    if length(filebytes) > (pngForWork.size - GetPosXFromPic	- GetPosYFromPic * pngforwork.picture.Width	- 1) then begin
     messageDlg(mf.key_small_for_decode, mtError, [mbOK],0);
     exit
  end;
  var decryptedBytes := GetDecryptedBytes(GetSizeFromPic);
  for var i := 0 to Length(fileBytes) - 1 do begin
//    showmessage(IntToStr(decryptedBytes[i]));
    fileBytes[i] := fileBytes[i] xor decryptedBytes[i];
  end;
  FileStream := TFileStream.Create(extractFilePath(paramstr(0))  + 'res' + PathDelim + GetNameFromPic, fmCreate);
  try
    FileStream.Write(fileBytes[0], Length(fileBytes));
  finally
    FileStream.Free;
  end;
end;

// получение байтов файла
function GetFileBytes():TArray<Byte>;
var
  color:TColor;
  bytes:TArray<byte>;
begin
  var counter:int64:=0;
  var size := GetSizeFromPic;
  SetLength(bytes, size);
    for var y := 1 to pngForFile.picture.Width - 1 do begin
    for var x := 0 to pngForFile.picture.Height - 1 do begin
      color := pngForFile.GetPixelColor(x, y);
      bytes[counter] := DecryptDecryptByte(color);
      counter := counter + 1;
      if counter >= size then begin
        break
      end;
    end;
    if counter >= size then
        break;
  end;
  Result := bytes;
end;

// получение байтов ключа
function GetDecryptedBytes(count:integer):TArray<Byte>;
  var
  color:TColor;
  bytes:TArray<byte>;
  encryptedColor: TColor;
begin
  var counter:int64:=0;
  SetLength(bytes, count);
  var posX :int64 := GetPosXFromPic;
  var posY :int64 := GetPosYFromPic;
//  showmessage('poss');
    for var y := posY to pngForWork.picture.Width - 1 do begin
    for var x := posX to pngForWork.picture.Height - 1 do begin
//      showmessage(IntToStr(x));
      PosX := x;

      color := pngForWork.GetPixelColor(x, y);
      bytes[counter] := DecryptDecryptByte(color);
      if (counter + 1) <> count then begin
        color := pngForWork.GetPixelColor(x, y);//затирание значения
        encryptedColor := EncryptDecryptByte(color, Random(256));
        pngForWork.SetPixelColor(x, y, encryptedColor);
      end;

      counter := counter + 1;
      if counter >= count then begin
        break
      end;
    end;
    if counter >= count then
        break;
        posY := y;
  end;

  SavePosXToPic(posX);
  SavePosYToPic(posY);
  pngForWork.SaveResult(GetPictureKeyPath);

  Result := bytes;
end;
end.
