unit ChartUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series;

type
  TPlotForm = class(TForm)
    crtChart: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlotForm: TPlotForm;
  crtChart: TChart;
  Series1: TFastLineSeries;
  Series2: TFastLineSeries;
  Series3: TFastLineSeries;
  Series4: TFastLineSeries;

implementation
uses MainUnit;
{$R *.dfm}

end.
