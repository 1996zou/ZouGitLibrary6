inherited frmPurchaseSetting: TfrmPurchaseSetting
  Caption = #37319#36141#20215#26684#34920#37197#32622
  ClientHeight = 242
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlEntry: TCMCWBackPanel
    Height = 147
    ExplicitHeight = 147
    object grpElecBar: TCMGGroupBox
      Left = 0
      Top = 0
      Width = 412
      Height = 147
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      CMBasictype = CMbtNo
      CMShowCustomCaption = True
      CMShowCaption = True
      CMCustomCaptionNo = 0
      object chkIsCreateVoucher: TCheckBox
        Left = 38
        Top = 22
        Width = 156
        Height = 17
        Hint = 'SalesDefault'
        Caption = #37319#36141#20215#26684#34920#21551#29992
        TabOrder = 0
        OnClick = chkIsCreateVoucherClick
      end
    end
  end
  inherited pnlBottom: TCMCWMaroonPanel
    Top = 201
    ExplicitTop = 201
    object btnClose: TCMGXwBitbtn
      Left = 319
      Top = 6
      Width = 75
      Height = 25
      Caption = #20851#38381
      DoubleBuffered = True
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
      UseBtnBackJpeg = False
      BtnType = btNone
      BtnLimitType = ltNone
      UseBtnLimit = False
      CMBtnTag = 33
      CMBtnType = gbtClose
      CMShowCustomCaption = False
      CMCustomCaptionNo = 0
    end
  end
  inherited CMEventHandler: TCMEventHandler
    Left = 312
  end
end
