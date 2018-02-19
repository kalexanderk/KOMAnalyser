object HelpForm: THelpForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Help'
  ClientHeight = 284
  ClientWidth = 433
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
  object lblQuest: TLabel
    Left = 37
    Top = 249
    Width = 149
    Height = 15
    Caption = 'For more questions write to:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object memoHelp: TMemo
    Left = 8
    Top = 8
    Width = 417
    Height = 225
    Cursor = crArrow
    Ctl3D = False
    Lines.Strings = (
      'HOW DOES IT WORK?'
      ''
      
        '1. Click on '#39'File'#39' ->'#39'Browse...'#39' and choose any Excel file You w' +
        'ant to analyse. '
      
        '    { The file should include 3 columns: '#39'Account'#39', '#39'Service'#39', '#39 +
        'Visit'#39' in the following '
      
        '    sequence. Column '#39'Service'#39' must consist of ATM, AUTO, CCRD, ' +
        'CD, CKCRD,'
      
        '    CKING, HMEQLC, IRA, MMDA, MTG, PLOAN, SVG, TRUST. First row ' +
        'of the '
      '    file should be free of information to analyse.  }'
      ''
      
        '2. Now you are able to choose options different from default (Nu' +
        'mber of items = 2;'
      '    Minimal support=5%'#39' Minimal confidence=0.1).'
      ''
      '3. To start analysing your file press '#39'Run'#39' button. '
      '    Wait a little bit while the program is running.'
      ''
      
        '4. To see results press '#39'Show table'#39' or '#39'Show statistics line pl' +
        'ot'#39'. '
      ' ')
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    OnMouseUp = memoHelpMouseUp
  end
  object edtHelp: TEdit
    Left = 192
    Top = 249
    Width = 137
    Height = 15
    Cursor = crHandPoint
    Alignment = taCenter
    BorderStyle = bsNone
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsUnderline]
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = False
    TabOrder = 1
    Text = 'alex.trump@hotmail.com.'
    OnClick = edtHelpClick
  end
end
