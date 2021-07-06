inherited frmInputPrintPass: TfrmInputPrintPass
  Left = 493
  Top = 261
  Caption = 'frmInputPrintPass'
  ClientHeight = 141
  ClientWidth = 362
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTitle: TCMCWBackPanel
    Width = 362
    ExplicitWidth = 362
  end
  inherited pnlBottom: TCMCWMaroonPanel
    Top = 100
    Width = 362
    ExplicitTop = 100
    ExplicitWidth = 362
    object btnOK: TButton
      Left = 190
      Top = 8
      Width = 75
      Height = 22
      Caption = #30830#23450
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 271
      Top = 8
      Width = 75
      Height = 22
      Caption = #21462#28040
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inherited pnlEntry: TCMCWBackPanel
    Width = 362
    Height = 46
    ExplicitWidth = 362
    ExplicitHeight = 46
    object Label1: TLabel
      Left = 20
      Top = 17
      Width = 60
      Height = 12
      AutoSize = False
      Caption = #25171#21360#23494#30721
    end
    object edtPassWord: TEdit
      Left = 81
      Top = 12
      Width = 257
      Height = 20
      PasswordChar = '*'
      TabOrder = 0
    end
  end
end
