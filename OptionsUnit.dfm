object OptionsForm: TOptionsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 257
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblSupport: TLabel
    Left = 161
    Top = 32
    Width = 98
    Height = 13
    Alignment = taCenter
    Caption = 'Minimum support, %'
  end
  object lblItems: TLabel
    Left = 8
    Top = 32
    Width = 78
    Height = 13
    Alignment = taCenter
    Caption = 'Number of items'
  end
  object lblConfidence: TLabel
    Left = 312
    Top = 32
    Width = 113
    Height = 13
    Alignment = taCenter
    Caption = 'Minimum confidence, %'
  end
  object cbxItems: TComboBox
    Left = 8
    Top = 72
    Width = 121
    Height = 21
    MaxLength = 1
    TabOrder = 0
    Text = '2'
    OnKeyPress = cbxItemsKeyPress
    Items.Strings = (
      '2'
      '3')
  end
  object edtSupport: TEdit
    Left = 161
    Top = 72
    Width = 120
    Height = 21
    MaxLength = 7
    TabOrder = 1
    Text = '5'
    OnKeyPress = edtSupportKeyPress
    OnMouseUp = edtSupportMouseUp
  end
  object edtConfidence: TEdit
    Left = 312
    Top = 72
    Width = 121
    Height = 21
    MaxLength = 7
    TabOrder = 2
    Text = '2'
    OnKeyPress = edtConfidenceKeyPress
    OnMouseUp = edtConfidenceMouseUp
  end
  object btnOptionsOK: TButton
    Left = 96
    Top = 155
    Width = 97
    Height = 41
    Caption = 'OK'
    TabOrder = 3
    OnClick = btnOptionsOKClick
  end
  object btnOptionsCancel: TButton
    Left = 248
    Top = 155
    Width = 97
    Height = 41
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnOptionsCancelClick
  end
end
