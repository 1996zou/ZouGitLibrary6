inherited frmBatchMessage: TfrmBatchMessage
  ActiveControl = btnClose
  Caption = 'frmBatchMessage'
  ClientHeight = 308
  ClientWidth = 542
  Position = poScreenCenter
  ExplicitWidth = 548
  ExplicitHeight = 337
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlEntry: TCMCWBackPanel
    Top = 44
    Width = 542
    Height = 222
    ExplicitTop = 44
    ExplicitWidth = 542
    ExplicitHeight = 222
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 5
      Height = 222
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
    end
    object MsgMemo: TRzRichEdit
      Left = 5
      Top = 0
      Width = 532
      Height = 222
      Align = alClient
      Color = clWhite
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      HideScrollBars = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      ReadOnlyColor = clWhite
    end
    object Panel2: TPanel
      Left = 537
      Top = 0
      Width = 5
      Height = 222
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
    end
  end
  inherited pnlBottom: TCMCWMaroonPanel
    Top = 266
    Width = 542
    Height = 42
    ExplicitTop = 266
    ExplicitWidth = 542
    ExplicitHeight = 42
    object btnOK: TButton
      Left = 377
      Top = 9
      Width = 66
      Height = 25
      Caption = #26159
      TabOrder = 0
      Visible = False
      OnClick = btnOKClick
    end
    object btnClose: TButton
      Left = 458
      Top = 9
      Width = 66
      Height = 25
      Caption = #20851#38381
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  inherited pnlTitle: TCMCWBackPanel
    Width = 542
    Height = 44
    ExplicitWidth = 542
    ExplicitHeight = 44
    inherited Shape2: TShape
      Left = 261
      ExplicitLeft = 261
    end
    inherited Shape1: TShape
      Left = 259
      ExplicitLeft = 259
    end
    inherited lblTitle: TLabel
      Left = 264
      ExplicitLeft = 264
    end
    object Image: TImage
      Left = 19
      Top = 7
      Width = 32
      Height = 32
    end
  end
  inherited cdsGetRecordSet: TClientDataSet
    Left = 432
    Top = 65534
  end
end
