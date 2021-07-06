inherited frmDialogParent: TfrmDialogParent
  Left = 391
  Top = 175
  BorderStyle = bsDialog
  Caption = 'frmDialogParent'
  ClientHeight = 364
  ClientWidth = 412
  Position = poMainFormCenter
  OnClose = FormClose
  ExplicitWidth = 418
  ExplicitHeight = 392
  PixelsPerInch = 96
  TextHeight = 13
  object pnlEntry: TCMCWBackPanel [2]
    Left = 0
    Top = 54
    Width = 412
    Height = 269
    Align = alClient
    BevelOuter = bvNone
    Color = 14213344
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object pnlBottom: TCMCWMaroonPanel [3]
    Left = 0
    Top = 323
    Width = 412
    Height = 41
    Align = alBottom
    Color = 13819101
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    NoPaint = False
  end
  object pnlTitle: TCMCWBackPanel [4]
    Left = 0
    Top = 0
    Width = 412
    Height = 54
    Align = alTop
    BevelOuter = bvNone
    Color = 14213344
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Shape2: TShape
      Left = 10
      Top = 7
      Width = 104
      Height = 27
      Brush.Color = clBlack
      Shape = stRoundRect
    end
    object Shape1: TShape
      Left = 8
      Top = 5
      Width = 104
      Height = 27
      Brush.Color = 16041572
      Shape = stRoundRect
    end
    object lblTitle: TLabel
      Left = 13
      Top = 11
      Width = 34
      Height = 16
      Caption = #26631#39064
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  inherited CMEventHandler: TCMEventHandler
    Left = 160
    Top = 112
  end
  object cdsGetRecordSet: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pv_sp_Open'
    Left = 304
    Top = 254
  end
end
