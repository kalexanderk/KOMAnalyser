unit AboutUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TAboutForm = class(TForm)
    grpbxAbout1: TGroupBox;
    grpbxAbout2: TGroupBox;
    edtAbout1: TEdit;
    edtAbout2: TEdit;
    edtAbout3: TEdit;
    edtAbout4: TEdit;
    memoAbout5: TMemo;
    lblInt: TLabel;
    lblEm: TLabel;
    img3: TImage;
    procedure edtAbout2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtAbout1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtAbout3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtAbout4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure memoAbout5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtAbout3Click(Sender: TObject);
    procedure edtAbout4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}



procedure TAboutForm.edtAbout1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  edtAbout1.SelLength:=0;
end;

procedure TAboutForm.edtAbout2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  edtAbout2.SelLength:=0;
end;

procedure TAboutForm.edtAbout3Click(Sender: TObject);
var
  MyLink: string;
begin
  MyLink := 'http://www.facebook.com/alextrump2/';
  ShellExecute(Application.Handle, PChar('open'), PChar(MyLink),
   nil, nil, SW_SHOW);
end;

procedure TAboutForm.edtAbout3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    edtAbout3.SelLength:=0;
end;

procedure TAboutForm.edtAbout4Click(Sender: TObject);
var
  pCh: PChar;
begin
  pCh := 'mailto:alex.trump@hotmail.com?subject=KOMAnalyser&body=Hi, Alex!';
  try
    ShellExecute(0, 'open', pCh, nil, nil, SW_SHOWNORMAL);
  except
  end;
end;

procedure TAboutForm.edtAbout4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    edtAbout4.SelLength:=0;
end;


procedure TAboutForm.memoAbout5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    memoAbout5.SelLength:=0;
end;

end.
