inherited frmBatchMessage: TfrmBatchMessage
  ActiveControl = btnClose
  Caption = 'frmBatchMessage'
  ClientHeight = 308
  ClientWidth = 542
  ExplicitWidth = 548
  ExplicitHeight = 336
  PixelsPerInch = 96
  TextHeight = 13
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
  inherited pnlEntry: TCMCWBackPanel
    Top = 44
    Width = 542
    Height = 222
    ExplicitTop = 44
    ExplicitWidth = 542
    ExplicitHeight = 222
    object MsgMemo: TMemo
      Left = 5
      Top = 0
      Width = 537
      Height = 222
      Align = alClient
      BevelInner = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 5
      Height = 222
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
    end
  end
  inherited cdsGetRecordSet: TClientDataSet
    Left = 432
    Top = 65534
  end
end
