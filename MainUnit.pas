unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ImgList, Vcl.FileCtrl, Vcl.Grids, VCLTee.Chart, VCLTee.Series, VCLTee.TeeProcs,
  System.UITypes, Vcl.Imaging.jpeg;

type
  DynWord=^Word;
  DynSingle=^Single;
  ItemsList = (ATM, AUTO, CCRD, CD, CKCRD,
  CKING, HMEQLC, IRA, MMDA, MTG, PLOAN, SVG, TRUST);
  arTab=array[ItemsList, ItemsList] of ^word;
  arTab3=array[ItemsList, ItemsList, ItemsList] of ^word;
  arTab4=array[ItemsList, ItemsList, ItemsList, ItemsList] of ^word;
  TMainForm = class(TForm)
    ImageListMain: TImageList;
    MainMenuMain: TMainMenu;
    btnFileMenu: TMenuItem;
    btnRunMenu: TMenuItem;
    btnOptionsMenu: TMenuItem;
    btnBrowseMenu: TMenuItem;
    btnAboutMenu: TMenuItem;
    btnExitMenu: TMenuItem;
    btnFinalTable: TButton;
    btnPlot: TButton;
    Help1: TMenuItem;
    lblMain: TLabel;
    Img1: TImage;
    Img2: TImage;
    procedure btnExitMenuClick(Sender: TObject);
    procedure btnAboutMenuClick(Sender: TObject);
    procedure btnOptionsMenuClick(Sender: TObject);
    procedure btnBrowseMenuClick(Sender: TObject);
    procedure btnRunMenuClick(Sender: TObject);
    procedure btnFinalTableClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Help1Click(Sender: TObject);
    procedure btnPlotClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure  BuildItemsTable2(var Table: arTab);

const arItems : array [ItemsList] of string[5] = ('ATM', 'AUTO', 'CCRD', 'CD', 'CKCRD',
      'CKING', 'HMEQLC', 'IRA', 'MMDA', 'MTG', 'PLOAN', 'SVG', 'TRUST');
       arItemsTable : array [1..13] of string[5] = ('ATM', 'AUTO', 'CCRD', 'CD', 'CKCRD',
      'CKING', 'HMEQLC', 'IRA', 'MMDA', 'MTG', 'PLOAN', 'SVG', 'TRUST');

var
  MainForm: TMainForm;  openDialog : TOpenDialog;
  ExcelFile: Variant; {Переменная Excel}
  Table: arTab;
  Table3: arTab3;
  NumberOfRules: Word;
  support: Single ;
  confidence: Single;
  expconfidence: Single;
  opn, ext, msg: boolean;
  arAB: array [ItemsList] of word;

implementation
uses AboutUnit, OptionsUnit,
{для работы с excel:начало} ComObj, Excel_TLB{для работы с excel: конец},
FinalTableUnit, HelpUnit, ChartUnit;
{$R *.dfm}

//OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_
//
//процедура открытия excel-файла для обработки
Procedure OpenExcelFile(FileAdress: string);
var i,j: ItemsList;
begin
  //сначала проверим, не был ли до этого открыт excel-файл
  if opn=false then
  begin
    //создаем excel-обьект
    ExcelFile:=CreateOleObject('Excel.Application');
    //загружаем файл из прописанной в FileName директории
    ExcelFile.Workbooks.Open(FileAdress, 0, true);
    //задаем тип формул в формате "R1C1"
    ExcelFile.Application.ReferenceStyle:=xlR1C1;
    //отключаем предупреждения
    ExcelFile.DisplayAlerts:=false;
    opn:=true;
  end
  else
  begin
    //разрываем связь с excel-документом
    try
    ExcelFile.Quit;
    except
    end;
    ExcelFile:=Unassigned;
    //создаем excel-обьект
    ExcelFile:=CreateOleObject('Excel.Application');
    //загружаем файл из прописанной в FileName директории
    ExcelFile.Workbooks.Open(FileAdress, 0, true);
    //задаем тип формул в формате "R1C1"
    ExcelFile.Application.ReferenceStyle:=xlR1C1;
    //отключаем предупреждения
    ExcelFile.DisplayAlerts:=false;
    opn:=true;
  end;
end;


//Браузинг в поиске excel-файла
procedure TMainForm.btnBrowseMenuClick(Sender: TObject);
var FileAdress: string;
begin
  openDialog := TOpenDialog.Create(self);
  //заголовок открытого окна браузинга файла
  openDialog.Title:='Browse';
  //ставим папкой для умолчания, с которой начинается поиск, текущей
  openDialog.InitialDir := GetCurrentDir;
  //проверка на существование файла
  openDialog.Options := [ofFileMustExist];
  //фильтр доспустимых форматов для выбора
  openDialog.Filter :=
    'Microsoft Excel Worksheet|*.xls|Microsoft Excel Worksheet|*.xlsx';
  openDialog.FilterIndex := 2;
  //вывод сообщений при выборе item/не выборе item
  if openDialog.Execute
  then
    begin
      ShowMessage('File : '+openDialog.FileName);
      FileAdress:=openDialog.Filename;
        //запуск процедуры открытия excel-файла
      OpenExcelFile(FileAdress);
        //enable Run button
      btnRunMenu.Enabled:=true;
      btnOptionsMenu.Enabled:=true;
      Opt(num, minsup, minconf);
      btnFinalTable.Enabled:=False;
      btnPlot.Enabled:=False;
    end
  else Application.MessageBox('Open file was cancelled', 'Error', MB_OK);
  //закрытие окна браузинга файла
  openDialog.Free;
end;
//
//OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_OPENFILE_


//2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_
//
//  процедура-построение 2-мерного массива из айтемов
//простой счёт количества тех или иных последовательностей
procedure BuildItemsTable2(var Table: arTab);
var
  j, i, Item1, Item2: ItemsList;
  strItem1, strItem2: string;
  ID1, ID2: string;
  k, h: integer;

begin
//начинаем работу со второй строки excel-файла
k:=2;
//выделяем под таблицу "последовательности" в куче
for i := ATM to TRUST do
  for j := ATM to TRUST do
    begin
      getmem(Table[i, j], 2);
    end;
//присваиваем всем элементам созданной таблицы значения нули
for i := ATM to TRUST do
  for j := ATM to TRUST do
    begin
      Table[i, j]^:=0;
    end;
for i := ATM to TRUST do
  begin
    arAB[i]:=0;
  end;
repeat
  //сверяем ID: один и тот же клиент?
  ID1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[k,1].Value;
  k:=k+1;

  ID2:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[k,1].Value;
  if ID1 = ID2 then
    begin
      //ищем последовательности
      h:=k-1;
      strItem1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,2].Value;
      h:=h+1;
      strItem2:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,2].Value;


      for i := ATM to TRUST do
        begin
          if strItem1=arItems[i] then Item1:=i;
        end;
      for i := ATM to TRUST do
        begin
          if strItem2=arItems[i] then Item2:=i;
        end;
      arAB[Item1]:=arAb[Item1]+1;
      if Item1<>Item2 then
       begin
         arAB[Item2]:=arAB[Item2]+1;
       end;
     Table[Item1, Item2]^:=Table[Item1, Item2]^+1;
    end;
until ID2 = '';
end;
//конец процедуры построения таблицы из айтемов для 2 элементов
//
//2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_2_




//ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_
//
 PROCEDURE ANALYSE(Table: arTab;  var StringGridTable: TStringGrid; var crtChart: TChart;
           var Series1, Series2, Series3, Series4: TFastLineSeries; var Table3: arTab3);
 label  1;
 var i, j, k, e, q, m, w: ItemsList;
 l, z, y: word;
  Item1, Item2, Item3: ItemsList;
  strItem1, strItem2, strItem3: string;
  ID1, ID2, ID3: string;
  h,t: word;

begin
   y:=0;
   z:=0;
   //очистка таблицы
   with FinalTable.StringGridTable do
    for t:=0 to ColCount-1 do Cols[t].Clear();
   with FinalTable.StringGridTable do
    for t:=0 to RowCount-1 do Rows[t].Clear();
   //fill the table
   with FinalTable.StringGridTable do Cells[0,0]:='Rule identifier';
   with FinalTable.StringGridTable do Cells[1,0]:='Rule';
   with FinalTable.StringGridTable do Cells[2,0]:='Chain size';
   with FinalTable.StringGridTable do Cells[3,0]:='Count';
   with FinalTable.StringGridTable do Cells[4,0]:='Support';
   with FinalTable.StringGridTable do Cells[5,0]:='Confidence';
   with FinalTable.StringGridTable do Cells[6,0]:='Expected confidence';
   with FinalTable.StringGridTable do Cells[7,0]:='Lift';
   //clear chart
   PlotForm.Series1.Clear();
   PlotForm.Series2.Clear();
   PlotForm.Series3.Clear();
   PlotForm.Series4.Clear();
   //
  //проверка на наполненность файла согласно указаниям
  msg:=false;
  ID1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[2,1].Value;
  if ID1='' then
    begin
      MainForm.lblMain.Visible:=false;
      Application.MessageBox('Choose another file.', 'Error', MB_OK);
      msg:=true;
      goto 1;
    end;


//2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_
  if NUM=2 THEN
BEGIN
     BuildItemsTable2(Table);
     //подсчитаем общее количество последовательностей
     NumberOfRules:=0;
     for i := ATM to TRUST do
      for j := ATM to TRUST do
        NumberOfRules:=NumberOfRules+Table[i,j]^;
     for i := ATM to TRUST do
     begin
      for j := ATM to TRUST do
        begin
          if Table[i,j]^= 0 then continue;
          if Table[i,j]^ <> 0 then
            begin
              support:=(Table[i,j]^/NumberOfRules)*100;
              confidence:=(Table[i,j]^/arAB[i])*100;
              expconfidence:=(arAB[j]/NumberOfRules)*100;
              y:=y+1;
              //ТУТ ЖЕ НАЧИНАЕМ ПОСТРОЕНИЕ ТАБЛИЦЫ
              //
              if (support> minsup) and (confidence> minconf) then
                begin
                  z:=z+1;
                  with FinalTable.StringGridTable do Cells[0,z]:=IntToStr(y);
                  with FinalTable.StringGridTable do Cells[1,z]:= arItems[i]+'==>'+arItems[j];
                  with FinalTable.StringGridTable do Cells[2,z]:=IntToStr(num);
                  with FinalTable.StringGridTable do Cells[3,z]:=IntToStr(Table[i,j]^);
                  with FinalTable.StringGridTable do Cells[4,z]:=FloatToStr(support);
                  with FinalTable.StringGridTable do Cells[5,z]:=FloatToStr(confidence);
                  with FinalTable.StringGridTable do Cells[6,z]:=FloatToStr(expconfidence);
                  with FinalTable.StringGridTable do Cells[7,z]:=FloatToStr(confidence/expconfidence);
                  FinalTable.StringGridTable.RowCount:=z+2;
                end;
                //
                //ЗАКАНЧИВАЕМ ПОСТРОЕНИЕ ТАБЛИЦЫ
                //Начинаем заполнять диаграмму
                //
                if y>PlotForm.crtChart.BottomAxis.Maximum then
                 PlotForm.crtChart.BottomAxis.Maximum:=PlotForm.crtChart.BottomAxis.Maximum+1;
                with PlotForm.Series1 do AddXY(y, support, '', clRed);
                with PlotForm.Series2 do AddXY(y, confidence, '', clRed);
                with PlotForm.Series3 do AddXY(y, expconfidence, '', clRed);
                with PlotForm.Series4 do AddXY(y, confidence/expconfidence, '', clRed);
                //
                //Заканчиваем заполнять диаграмму
            end;
         end;
     end;
  //удаляем таблицу "Sequences" из кучи
  for i := ATM to TRUST do
    for j := ATM to TRUST do
      begin
        freemem(Table[i, j], 2);
        Table[i, j]:=nil;
      end;
END;
//2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_2-DIM CASE_


//3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_
 if NUM=3 THEN
BEGIN
  //начинаем работу со второй строки excel-файла
  t:=2;
  //выделяем под таблицу "последовательности" в куче
  for i := ATM to TRUST do
    for j := ATM to TRUST do
      for e := ATM to TRUST do
        begin
          getmem(Table3[i, j, e], 2);
        end;
  //присваиваем всем элементам созданной таблицы значения нули
  for i := ATM to TRUST do
    for j := ATM to TRUST do
      for e := ATM to TRUST do
        begin
          Table3[i, j, e]^:=0;
        end;
  for i := ATM to TRUST do
    begin
      arAB[i]:=0;
    end;
  repeat
  //сверяем ID: один и тот же клиент?
  ID1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[t,1].Value;
  t:=t+1;
  ID2:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[t,1].Value;
  if ID1 = ID2 then
    begin
      //ищем последовательности
      h:=t-1;
      strItem1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,2].Value;
      h:=h+1;
      strItem2:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,2].Value;
      for i := ATM to TRUST do
        begin
          if strItem1=arItems[i] then Item1:=i;
        end;
      for i := ATM to TRUST do
        begin
          if strItem2=arItems[i] then Item2:=i;
        end;
      arAB[Item1]:=arAB[Item1]+1;
      if Item1<>Item2 then
       begin
         arAB[Item2]:=arAB[Item2]+1;
       end;
     Table3[Item1, Item2, ATM]^:=Table3[Item1, Item2, ATM]^+1;
    end;
   until ID2 = '';
   //подсчитаем общее количество последовательностей
   NumberOfRules:=0;
   for i := ATM to TRUST do
     for j := ATM to TRUST do
       NumberOfRules:=NumberOfRules+Table3[i,j, ATM]^;
   for i := ATM to TRUST do
     begin
       for j := ATM to TRUST do
         begin
           if Table3[i,j, ATM]^= 0 then continue;
           if Table3[i,j, ATM]^ <> 0 then
             begin
               begin
                 support:=(Table3[i,j, ATM]^/NumberOfRules)*100;
                 confidence:=(Table3[i,j, ATM]^/arAB[i])*100;
                 expconfidence:=(arAB[j]/NumberOfRules)*100;
                 y:=y+1;
                 //ТУТ ЖЕ НАЧИНАЕМ ПОСТРОЕНИЕ ТАБЛИЦЫ
                 //
                 if (support > minsup) and (confidence > minconf) then
                   begin;
                     z:=z+1;
                     with FinalTable.StringGridTable do Cells[0,z]:=IntToStr(y);
                     with FinalTable.StringGridTable do Cells[1,z]:= arItems[i]+'==>'+arItems[j];
                     with FinalTable.StringGridTable do Cells[2,z]:='2';
                     with FinalTable.StringGridTable do Cells[3,z]:=IntToStr(Table3[i,j, ATM]^);
                     with FinalTable.StringGridTable do Cells[4,z]:=FloatToStr(support);
                     with FinalTable.StringGridTable do Cells[5,z]:=FloatToStr(confidence);
                     with FinalTable.StringGridTable do Cells[6,z]:=FloatToStr(expconfidence);
                     with FinalTable.StringGridTable do Cells[7,z]:=FloatToStr(confidence/expconfidence);
                     FinalTable.StringGridTable.RowCount:=z+2;
                   end;
                 //
                 //ЗАКАНЧИВАЕМ ПОСТРОЕНИЕ ТАБЛИЦЫ
                 //Начинаем заполнять диаграмму
                 //
                 if y>PlotForm.crtChart.BottomAxis.Maximum then
                  PlotForm.crtChart.BottomAxis.Maximum:=PlotForm.crtChart.BottomAxis.Maximum+1;
                 with PlotForm.Series1 do AddXY(y, support, '', clRed);
                 with PlotForm.Series2 do AddXY(y, confidence, '', clRed);
                 with PlotForm.Series3 do AddXY(y, expconfidence, '', clRed);
                 with PlotForm.Series4 do AddXY(y, confidence/expconfidence, '', clRed);
                 //
                 //Заканчиваем заполнять диаграмму
              end;
          end;
      end;
  end;
  //НАЧАЛО РАБОТЫ С 3-МЯ ЯЧЕЙКАМИ
  //присваиваем всем элементам таблицы значения нули
  for i := ATM to TRUST do
    for j := ATM to TRUST do
      for e := ATM to TRUST do
        begin
          Table3[i, j, e]^:=0;
        end;
  for i := ATM to TRUST do
      begin
        arAB[i]:=0;
      end;
  h:=2;
  repeat
  //сверяем ID: один и тот же клиент?
  ID1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,1].Value;
  h:=h+1;
  ID2:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,1].Value;
  h:=h+1;
  ID3:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[h,1].Value;
  if (ID1 = ID2) and (ID1=ID3) and (ID2=ID3) then
    begin
      //ищем последовательности
      t:=h-2;
      strItem1:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[t,2].Value;
      t:=t+1;
      strItem2:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[t,2].Value;
      t:=t+1;
      strItem3:=ExcelFile.WorkBooks[1].WorkSheets[1].Cells[t,2].Value;
      for i := ATM to TRUST do
        begin
          if strItem1=arItems[i] then Item1:=i;
        end;
      for i := ATM to TRUST do
        begin
          if strItem2=arItems[i] then Item2:=i;
        end;
      for i := ATM to TRUST do
        begin
          if strItem3=arItems[i] then Item3:=i;
        end;
     if (Item1=Item2) and (Item1<>Item3) then
       begin
         arAB[Item1]:= arAB[Item1]+1;
         arAB[Item3]:= arAB[Item3]+1;
       end;
     if (Item1=Item3) and (Item1<>Item2) then
       begin
         arAB[Item1]:= arAB[Item1]+1;
         arAB[Item2]:= arAB[Item2]+1;
       end;
     if (Item2=Item3) and (Item1<>Item2) then
       begin
         arAB[Item1]:= arAB[Item1]+1;
         arAB[Item2]:= arAB[Item2]+1;
       end;
     if (Item1=Item3) and (Item1=Item2) then
       begin
         arAB[Item1]:= arAB[Item1]+1;
       end;
     if (Item1<>Item3) and (Item1<>Item2) and (Item2<>Item3) then
       begin
         arAB[Item1]:= arAB[Item1]+1;
         arAB[Item2]:= arAB[Item2]+1;
         arAB[Item3]:= arAB[Item3]+1;
       end;
     Table3[Item1, Item2, Item3]^:=Table3[Item1, Item2, Item3]^+1;
    end;
until ID3 = '';
  //подсчитаем общее количество последовательностей
  NumberOfRules:=0;
  for i := ATM to TRUST do
    for j := ATM to TRUST do
      for e := ATM to TRUST do
        NumberOfRules:=NumberOfRules+Table3[i, j, e]^;
  for i := ATM to TRUST do
    for j := ATM to TRUST do
      begin
        for e := ATM to TRUST do
          begin
            //ищем правила с правилом C, RulesB<=>C
            if Table3[i,j,e]^= 0 then continue;
            if Table3[i,j,e]^ <> 0 then
              begin
                support:=((Table3[i,j,e]^)/NumberOfRules)*100;
                confidence:=(Table3[i,j,e]^/arAB[i])*100;
                expconfidence:=(arAB[e]/NumberOfRules)*100;
                y:=y+1;
                //ТУТ ЖЕ НАЧИНАЕМ ПОСТРОЕНИЕ ТАБЛИЦЫ
                //
                if (support> minsup) and (confidence > minconf) then
                  begin;
                    z:=z+1;
                    with FinalTable.StringGridTable do Cells[0,z]:=IntToStr(y);
                    with FinalTable.StringGridTable do Cells[1,z]:= arItems[i]+'==>'+arItems[j]+'==>'+arItems[e];;
                    with FinalTable.StringGridTable do Cells[2,z]:=IntToStr(num);
                    with FinalTable.StringGridTable do Cells[3,z]:=IntToStr(Table3[i,j,e]^);
                    with FinalTable.StringGridTable do Cells[4,z]:=FloatToStr(support);
                    with FinalTable.StringGridTable do Cells[5,z]:=FloatToStr(confidence);
                    with FinalTable.StringGridTable do Cells[6,z]:=FloatToStr(expconfidence);
                    with FinalTable.StringGridTable do Cells[7,z]:=FloatToStr(confidence/expconfidence);
                    FinalTable.StringGridTable.RowCount:=z+2;
                  end;
                //
                //ЗАКАНЧИВАЕМ ПОСТРОЕНИЕ ТАБЛИЦЫ
                //Начинаем заполнять диаграмму
                //
                if y>PlotForm.crtChart.BottomAxis.Maximum then
                 PlotForm.crtChart.BottomAxis.Maximum:=PlotForm.crtChart.BottomAxis.Maximum+1;
                with PlotForm.Series1 do AddXY(y, support, '', clRed);
                with PlotForm.Series2 do AddXY(y, confidence, '', clRed);
                with PlotForm.Series3 do AddXY(y, expconfidence, '', clRed);
                with PlotForm.Series4 do AddXY(y, confidence/expconfidence, '', clRed);
                //
                //Заканчиваем заполнять диаграмму
          end;
      end;
  end;
    //удаляем таблицу "Sequences" из кучи
    for i := ATM to TRUST do
      for j := ATM to TRUST do
        for e := ATM to TRUST do
        begin
          freemem(Table3[i, j,e], 2);
          Table3[i, j,e]:=nil;
        end;
END;
//3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_3-DIM CASE_
1:
end;
//
//ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_ANALYSE_








//MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_
//
procedure TMainForm.btnAboutMenuClick(Sender: TObject);
begin
AboutForm.ShowModal;
end;

procedure TMainForm.btnExitMenuClick(Sender: TObject);
var i, j: ItemsList;
begin
    //close?
  if MessageDlg('Really close this program?',
  mtConfirmation, [mbOk, mbCancel], 0) = mrCancel then
  begin

  end
  else
    begin
    if opn=true then
      begin
        //разрываем связь с excel-документом
        try
        ExcelFile.Quit;
        except
        end;
        ExcelFile:=Unassigned;
      end
      else;
        ext:=true;
    MainForm.Close();
   end;
end;

procedure TMainForm.btnOptionsMenuClick(Sender: TObject);
begin
OptionsForm.ShowModal;
end;

procedure TMainForm.btnRunMenuClick(Sender: TObject);
var rls: boolean; z:integer;
begin
  lblMain.Visible:=True;
  ANALYSE(Table, StringGridTable, crtChart, Series1, Series2, Series3, Series4, Table3);
  lblMain.Visible:=False;
  rls:=false;
if msg=false then
begin
for z := 1 to FinalTable.StringGridTable.RowCount do
  begin
    if  (FinalTable.StringGridTable.Cells[0,z]<>'') and
    (FinalTable.StringGridTable.Cells[1,z]<>'') and
    (FinalTable.StringGridTable.Cells[2,z]<>'') and
    (FinalTable.StringGridTable.Cells[3,z]<>'') and
    (FinalTable.StringGridTable.Cells[4,z]<>'') and
    (FinalTable.StringGridTable.Cells[5,z]<>'') and
    (FinalTable.StringGridTable.Cells[6,z]<>'') and
    (FinalTable.StringGridTable.Cells[7,z]<>'') then  rls:=true;
  end;
if rls=false then Application.MessageBox('No rules have been found.', 'Error', MB_OK);
end;
  btnFinalTable.Enabled:=True;
  btnPlot.Enabled:=True;
end;

procedure TMainForm.Help1Click(Sender: TObject);
begin
  HelpForm.Show;
end;


//
//MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_MAINMENU_


//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_
//
procedure TMainForm.btnFinalTableClick(Sender: TObject);
begin
  FinalTable.Show;
end;


procedure TMainForm.btnPlotClick(Sender: TObject);
begin
  PlotForm.Show;
end;

//
//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_//BUTTONS_


//ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_
//
procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i, j: ItemsList;
begin
  if (ext=false) then
  begin
   //close?
  if MessageDlg('Really close this program?',
  mtConfirmation, [mbOk, mbCancel], 0) = mrCancel then
  CanClose := False
  else
    begin
    if opn=true then
      begin
        //разрываем связь с excel-документом
        try
        ExcelFile.Quit;
        except
        end;
        ExcelFile:=Unassigned;
      end
      else;
    CanClose:=True;
   end;
  end;
end;
//
//ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_ONCLOSE_


end.
