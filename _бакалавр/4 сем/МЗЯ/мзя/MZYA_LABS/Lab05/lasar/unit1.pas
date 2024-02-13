unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Panel1: TPanel;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure mySetText(s:ShortString);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
{$L lab05assemb\lab05assemb.OBJ}
// ассемблерная процедура изменения текста
procedure myCange(a,b:byte; s:ShortString);pascal;external;

// pascal процедура назначения нового текста
procedure TForm1.mySetText(s:ShortString);
begin    
  Memo1.Text:= s;
end;




{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

  if(length(Memo1.Text) > 255)then
  begin
    Memo1.Text := copy(Memo1.Text, 1, 255);
  end;

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then Key := #0;
end;


procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then Key := #0;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  memoText:ShortString;
  a,b:shortint;

begin

  // проверка на допустимые значения
  if(length(Edit1.Text) = 0)then
  begin
    Edit1.Text := '1';
  end;

  if(strToInt(Edit1.Text) > 254)then
  begin
    Edit1.Text := '254';
  end;

  if(length(Edit2.Text) = 0)then
  begin
    Edit2.Text := '1';
  end;

  if(strToInt(Edit2.Text) > 254)then
  begin
    Edit2.Text := '254';
  end;

  if(strToInt(Edit1.Text) > strToInt(Edit2.Text))then
  begin
    a:= strToInt(Edit2.Text); 
    b:= strToInt(Edit1.Text);
  end
  else
  begin  
    a:= strToInt(Edit1.Text);
    b:= strToInt(Edit2.Text);
  end;

  // вызов подпрограммы
  if(a<>b)then
  begin
    memoText:= Memo1.Text;
    myCange(a,b, memoText);
  end;

end;







end.

