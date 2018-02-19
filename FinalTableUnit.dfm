object FinalTable: TFinalTable
  Left = 0
  Top = 0
  ClientHeight = 546
  ClientWidth = 1020
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object StringGridTable: TStringGrid
    Left = 0
    Top = 0
    Width = 1020
    Height = 546
    Cursor = crHandPoint
    Align = alClient
    ColCount = 8
    DefaultColWidth = 140
    DrawingStyle = gdsGradient
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs, goThumbTracking, goFixedColClick, goFixedRowClick]
    TabOrder = 0
    OnFixedCellClick = StringGridTableFixedCellClick
    ColWidths = (
      140
      168
      140
      140
      140
      140
      140
      140)
  end
end
