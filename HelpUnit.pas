unit HelpUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI;

type
  THelpForm = class(TForm)
    memoHelp: TMemo;
    edtHelp: TEdit;
    lblQuest: TLabel;
    procedure memoHelpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;

implementation
uses MainUnit;
{$R *.dfm}

procedure THelpForm.edtHelpClick(Sender: TObject);
var
  pCh: PChar;
begin
  pCh := 'mailto:alex.trump@hotmail.com?subject=KOMAnalyser&body=Hi, Alex!';
  try
    ShellExecute(0, 'open', pCh, nil, nil, SW_SHOWNORMAL);
  except
  end;
end;

procedure THelpForm.memoHelpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  memoHelp.SelLength:=0;
end;

end.
