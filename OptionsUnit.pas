unit OptionsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;
type
  TOptionsForm = class(TForm)
    cbxItems: TComboBox;
    edtSupport: TEdit;
    edtConfidence: TEdit;
    lblSupport: TLabel;
    lblItems: TLabel;
    lblConfidence: TLabel;
    btnOptionsOK: TButton;
    btnOptionsCancel: TButton;
    procedure btnOptionsCancelClick(Sender: TObject);
    procedure btnOptionsOKClick(Sender: TObject);
    procedure cbxItemsKeyPress(Sender: TObject; var Key: Char);
    procedure edtSupportKeyPress(Sender: TObject; var Key: Char);
    procedure edtSupportMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtConfidenceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtConfidenceKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
 procedure Opt( var num: byte; var minsup, minconf: single);
var
  OptionsForm: TOptionsForm;
  cbxItems: TComboBox;
  edtSupport: TEdit;
  edtConfidence: TEdit;
  minsup: single;
  minconf: single;
  num: byte;
  Key: char;


implementation
 uses MainUnit, FinalTableUnit;
{$R *.dfm}


procedure Opt(var num: byte; var minsup, minconf: single);
begin
  if OptionsForm.cbxItems.Text='' then OptionsForm.cbxItems.Text:='2'
  else num:=StrToInt(OptionsForm.cbxItems.Text);
  if OptionsForm.edtSupport.Text='' then OptionsForm.edtSupport.Text:='5'
  else minsup:=StrToFloat(OptionsForm.edtSupport.Text);
  if OptionsForm.edtConfidence.Text='' then OptionsForm.edtConfidence.Text:='2'
  else minconf:=StrToFloat(OptionsForm.edtConfidence.Text);
end;

procedure TOptionsForm.cbxItemsKeyPress(Sender: TObject; var Key: Char);
begin
  if Not (Key in ['2','3'])then Key:=#0;
  if Key<>#0 then
    begin
      OptionsForm.cbxItems.Text:='';
      OptionsForm.cbxItems.Text:=Key;
    end;
end;


procedure TOptionsForm.edtConfidenceKeyPress(Sender: TObject; var Key: Char);
var i: byte;
begin
  if Not (Key in ['0'..'9', '.', #08 {backspace},#127{delete} ])then Key:=#0;
  if (Key in ['0'..'9']) and (StrToFloat(edtConfidence.Text+Key)>100) then Key:=#0;
  if length(edtConfidence.Text)=0 then if Key='.' then Key:=#0;
  if Key='.' then for i := 1 to length(edtConfidence.Text) do
    if edtConfidence.Text[i]='.' then Key:=#0;
end;


procedure TOptionsForm.edtSupportKeyPress(Sender: TObject; var Key: Char);
var i: byte;
begin
  if Not (Key in ['0'..'9', '.', #08 {backspace},#127{delete} ])then Key:=#0;
  if (Key in ['0'..'9']) and (StrToFloat(edtSupport.Text+Key)>100) then Key:=#0;
  if length(edtSupport.Text)=0 then if Key='.' then Key:=#0;
  if Key='.' then for i := 1 to length(edtSupport.Text) do
    if edtSupport.Text[i]='.' then Key:=#0;
end;

procedure TOptionsForm.edtConfidenceMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
edtConfidence.SelLength:=0;
end;

procedure TOptionsForm.edtSupportMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtSupport.SelLength:=0;
end;

procedure TOptionsForm.btnOptionsOKClick(Sender: TObject);
begin
  if OptionsForm.cbxItems.Text='' then OptionsForm.cbxItems.Text:=IntToStr(num)
  else num:=StrToInt(OptionsForm.cbxItems.Text);
  if OptionsForm.edtSupport.Text='' then OptionsForm.edtSupport.Text:=FloatToStr(minsup)
  else minsup:=StrToFloat(OptionsForm.edtSupport.Text);
  if OptionsForm.edtConfidence.Text='' then OptionsForm.edtConfidence.Text:=FloatToStr(minconf)
  else minconf:=StrToFloat(OptionsForm.edtConfidence.Text);
  Opt(num, minsup, minconf);
  OptionsForm.Close();
end;


procedure TOptionsForm.btnOptionsCancelClick(Sender: TObject);
begin
  if OptionsForm.cbxItems.Text='' then OptionsForm.cbxItems.Text:=IntToStr(num);
  if OptionsForm.edtSupport.Text='' then OptionsForm.edtSupport.Text:=FloatToStr(minsup);
  if OptionsForm.edtConfidence.Text='' then OptionsForm.edtConfidence.Text:=FloatToStr(minconf);
  OptionsForm.Close();
end;



end.
