unit Picture;



interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Rand, Vcl.Imaging.pngimage, jpeg;

type
  Png = class
    picture: TPngImage;
    size: integer;

    constructor Create(path:string);
    procedure LoadPicture(path:string);
    procedure SaveResult(filename:string);
    procedure SetPixelColor(x, y:integer; color:TColor);
    function GetPixelColor(x, y:integer):TColor;
  end;

implementation

// контруктор класса. «агружает картинку и устанавливает поле size
constructor Png.Create(path:string);
begin
  LoadPicture(path);
  size:= picture.Width * picture.Height;
end;

// загружает картинку в переменную
procedure Png.LoadPicture(path:string);
begin
  picture := TPngImage.Create;
  picture.loadfromfile(path);
end;

// сохран€ет результат
procedure Png.SaveResult(filename:string);
begin
  picture.SaveToFile(filename)
end;

// устанавливает цвет пикселю
procedure Png.SetPixelColor(x, y:integer; color:TColor);
begin
  picture.Canvas.Pixels[y, x] := color;
end;

// возвращает цвет пиксел€
function Png.GetPixelColor(x, y:integer):TColor;
begin
  Result := picture.Canvas.Pixels[y, x];
end;
end.
