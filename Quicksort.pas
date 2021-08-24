unit Quicksort;
// non recursive Quicksort
// original :
// https://gist.github.com/burakkose/7faa4e70c7c672ee2694

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Generics.Collections;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

const
  max = 4096;
var
  Form1: TForm1;
  tab : array [0..max-1] of integer;
  stack    : System.Generics.Collections.TStack<integer>  ;
  i : integer;

implementation

{$R *.dfm}

function GetTickCountEx :Extended;
var
  Frequency :Int64;
  Counter   :Int64;

begin
  //Si le compteur de précision n'est pas disponible
  //utilise GetTickCount converti en seconde.
  if QueryPerformanceFrequency(Frequency) then
  begin
    QueryPerformanceCounter(Counter);
    Result := Counter /Frequency;
  end
  else Result := GetTickCount *1000;
end;

procedure QuickSort;
var
  subArray : integer;
  _left, left, _right, right  : integer;
  pivot : integer;
  temp: integer;

begin
  subArray := 0;
  stack.Push(0);     { left }
  stack.Push(max-1); { right }

  repeat
    right := stack.Pop;
    left := stack.Pop;
    dec(subArray);
    repeat
      _left := left;
      _right := right;
      pivot := tab[(left + right) div 2];
      while (_right >= _left) do
        begin
          while (pivot < tab[_right]) do dec(_right);
          while (pivot > tab[_left])  do inc(_left);

          if (_left <= _right) then
          begin
            if (_left <> _right) then
            begin
              temp := tab[_left];
              tab[_left] := tab[_right];
              tab[_right]:= temp;
            end;
            dec(_right);
            inc(_left);
          end;
        end; //   while (_right >= _left)
      if (_left < right) then
      begin
        inc(subArray);
        stack.push(_left);
        stack.push(right);
      end;
      right := _right;
    until (left>=right);  // while (left < right);

  until (subArray <= -1);



end;

procedure TForm1.Button1Click(Sender: TObject);
var
  before, after : Extended;

begin
  Memo1.Clear;
  { Create a new stack. }
  stack := TStack<integer>.Create;
  for i := 0 to max-1 do
  begin
    tab[i] := Random(max*3);
    //Memo1.Lines.Add(IntToStr(tab[i]));
  end;
  before := GetTickCountEx;
  QuickSort;
  after := GetTickCountEx;
  memo1.Lines.Add('--------------');
  for i := 0 to max-1 do
  begin
    //Memo1.Lines.Add(IntToStr(tab[i]));
  end;
  Memo1.Lines.Add(floattostr((after-before)*1000));
end;

end.