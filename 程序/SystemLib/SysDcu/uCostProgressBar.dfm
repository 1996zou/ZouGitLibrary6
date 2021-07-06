object frmCostProgressBar: TfrmCostProgressBar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = ' '
  ClientHeight = 14
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 0
    Top = 0
    Width = 323
    Height = 14
    Align = alClient
    BorderStyle = bsNone
    ForeColor = clGradientActiveCaption
    Progress = 0
    ExplicitHeight = 15
  end
end
