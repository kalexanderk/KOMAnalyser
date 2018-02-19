unit FinalTableUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Graphics,
  Controls, Forms, Dialogs, Grids, StdCtrls, ComObj;



type
  TFinalTable = class(TForm)
    StringGridTable: TStringGrid;
    procedure StringGridTableFixedCellClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FinalTable: TFinalTable;
  StringGridTable: TStringGrid;
  Excel: Variant;


implementation
uses MainUnit, OptionsUnit;
{$R *.dfm}



procedure TFinalTable.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i, j, k: integer;
begin

  k:=0;
  repeat
    k:=k+1;
  until FileExists('C:\KOMAnalyser Results'+ '\RESULT'+IntToStr(k)+'.xlsx')=false ;

    Excel:=CreateOleObject('Excel.Application');
    Excel.WorkBooks.Add;
    Excel.WorkSheets.Add;
    with StringGridtable do
    for i:=0 to RowCount-1 do
    for j:=0 to ColCount-1 do
    Excel.WorkSheets[1].Cells[i+1, j+1]:=StringGridTable.Cells[j,i];
    ChDir('C:\');
    if DirectoryExists('KOMAnalyser Results')=false then CreateDir('KOMAnalyser Results');
    Excel.ActiveWorkBook.Saveas('C:\KOMAnalyser Results'+ '\RESULT'+IntToStr(k)+'.xlsx');

  try
  Excel.Quit;
  except
  end;
  Excel:=Unassigned;
  CanClose:=True;
end;

procedure TFinalTable.StringGridTableFixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
var n,i,j, k:integer;
  count: Integer;
  val1, val2: real;
begin
n:=StringGridTable.RowCount-1;

if ACol=1 then
begin
  for i:=1 to n-2 do
  for j:=i+1 to n-1 do
   begin
    if StringGridTable.Cells[ACol,i]>StringGridTable.Cells[ACol,j] then
      for k:=0 to 7 do
      StringGridTable.Cols[k].Exchange(j,i);
   end;
end;

if (ACol=4) or (ACol=5) or (ACol=6) or (ACol=7) then
begin
  for i:=1 to n-2 do
  for j:=i+1 to n-1 do
   begin
    val1:=StrToFloat(StringGridTable.Cells[ACol,i]);
    val2:=StrToFloat(StringGridTable.Cells[ACol,j]);
    if val1<val2 then
      for k:=0 to 7 do
      StringGridTable.Cols[k].Exchange(j,i);
   end;
end;

if (ACol=2) or (ACol=3) then
begin
  for i:=1 to n-2 do
  for j:=i+1 to n-1 do
   begin
    val1:=StrToInt(StringGridTable.Cells[ACol,i]);
    val2:=StrToInt(StringGridTable.Cells[ACol,j]);
    if val1<val2 then
      for k:=0 to 7 do
      StringGridTable.Cols[k].Exchange(j,i);
   end;
end;

if (ACol=0)then
begin
  for i:=1 to n-2 do
  for j:=i+1 to n-1 do
   begin
    val1:=StrToInt(StringGridTable.Cells[ACol,i]);
    val2:=StrToInt(StringGridTable.Cells[ACol,j]);
    if val1>val2 then
      for k:=0 to 7 do
      StringGridTable.Cols[k].Exchange(j,i);
   end;
end;

end;

end.
