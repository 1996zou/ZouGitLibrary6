inherited frmCondBox: TfrmCondBox
  Left = 311
  Top = 114
  Caption = 'frmCondBox'
  ClientWidth = 413
  ExplicitWidth = 419
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlEntry: TCMCWBackPanel
    Top = 36
    Width = 413
    Height = 287
    BorderWidth = 10
    ExplicitTop = 36
    ExplicitWidth = 413
    ExplicitHeight = 287
    object Bevel1: TBevel
      Left = 10
      Top = 10
      Width = 393
      Height = 267
      Align = alClient
      Shape = bsFrame
      ExplicitWidth = 348
      ExplicitHeight = 270
    end
    object imgTitle: TImage
      Left = 26
      Top = 26
      Width = 35
      Height = 35
      AutoSize = True
      Transparent = True
    end
  end
  inherited pnlBottom: TCMCWMaroonPanel
    Width = 413
    ExplicitWidth = 413
    DesignSize = (
      413
      41)
    object cbxSaveDate: TCMGXwChcekBox
      Left = 14
      Top = 12
      Width = 91
      Height = 15
      Caption = #20445#23384#26597#35810#26102#38388
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      State = cbUnchecked
      TabOrder = 0
      TabStop = False
      WordWrap = True
      CMBasicType = CMbtNo
      CMShowCustomCaption = True
      CMCustomCaptionNo = 0
      FrameWork = fwNo
    end
    object btnOK: TCMGXwBitbtn
      Left = 242
      Top = 8
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 1
      OnClick = btnOKClick
      UseBtnBackJpeg = False
      BtnType = btNone
      BtnLimitType = ltNone
      UseBtnLimit = False
      CMBtnTag = 1
      CMBtnType = gbtOk
      CMShowCustomCaption = False
      CMCustomCaptionNo = 0
    end
    object btnCancel: TCMGXwBitbtn
      Left = 328
      Top = 8
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #21462#28040
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ModalResult = 2
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 2
      UseBtnBackJpeg = False
      BtnType = btNone
      BtnLimitType = ltNone
      UseBtnLimit = False
      CMBtnTag = 16
      CMBtnType = gbtCancel
      CMShowCustomCaption = False
      CMCustomCaptionNo = 0
    end
  end
  inherited pnlTitle: TCMCWBackPanel
    Width = 413
    Height = 36
    ExplicitWidth = 413
    ExplicitHeight = 36
    inherited lblTitle: TLabel
      Left = 20
      ExplicitLeft = 20
    end
  end
end
