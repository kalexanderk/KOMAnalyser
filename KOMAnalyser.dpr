program KOMAnalyser;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  OptionsUnit in 'OptionsUnit.pas' {OptionsForm},
  FinalTableUnit in 'FinalTableUnit.pas' {FinalTable},
  ChartUnit in 'ChartUnit.pas' {PlotForm},
  HelpUnit in 'HelpUnit.pas' {HelpForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TFinalTable, FinalTable);
  Application.CreateForm(TPlotForm, PlotForm);
  Application.CreateForm(THelpForm, HelpForm);
  Application.Run;
end.
