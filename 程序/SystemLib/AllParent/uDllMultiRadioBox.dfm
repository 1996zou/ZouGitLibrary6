inherited frmDllMultiRadioBox: TfrmDllMultiRadioBox
  Left = 352
  Top = 177
  Caption = 'frmDllMultiRadioBox'
  ClientHeight = 307
  ClientWidth = 440
  OldCreateOrder = True
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTitle: TCMCWBackPanel
    Width = 440
    ExplicitWidth = 440
  end
  inherited pnlBottom: TCMCWMaroonPanel
    Top = 266
    Width = 440
    ExplicitTop = 266
    ExplicitWidth = 440
    object lblHint: TLabel
      Left = 4
      Top = 15
      Width = 6
      Height = 12
      Transparent = True
    end
    object btnOK: TCMGXwBitbtn
      Left = 262
      Top = 11
      Width = 81
      Height = 24
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      Default = True
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ModalResult = 1
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
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
      Left = 350
      Top = 11
      Width = 81
      Height = 24
      Anchors = [akTop, akRight]
      Cancel = True
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
      TabOrder = 1
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
  inherited pnlEntry: TCMCWBackPanel
    Width = 440
    Height = 212
    BorderWidth = 10
    ExplicitWidth = 440
    ExplicitHeight = 212
    object Bevel1: TBevel
      Left = 10
      Top = 10
      Width = 420
      Height = 192
      Align = alClient
      Shape = bsFrame
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
end
