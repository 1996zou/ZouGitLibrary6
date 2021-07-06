inherited frmDllMDIParent: TfrmDllMDIParent
  Top = 390
  Caption = 'frmDllMDIParent'
  FormStyle = fsMDIChild
  Position = poDefault
  Visible = True
  OnClose = FormClose
  ExplicitWidth = 704
  ExplicitHeight = 484
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButton: TCMCWMaroonPanel [2]
    Left = 0
    Top = 383
    Width = 688
    Height = 44
    Align = alBottom
    Color = 13819101
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    NoPaint = False
  end
  object pnlEntry: TCMCWBackPanel [3]
    Left = 0
    Top = 93
    Width = 688
    Height = 290
    Align = alClient
    BevelOuter = bvNone
    Color = 14213344
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object sbStatus: TStatusBar [4]
    Left = 0
    Top = 427
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pnlTitle: TCMCWBackPanel [5]
    Left = 0
    Top = 24
    Width = 688
    Height = 69
    Align = alTop
    BevelOuter = bvNone
    Color = 14213344
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object ShadowPanel1: TShadowPanel
      Left = 14
      Top = 5
      Width = 100
      Height = 27
      BevelOuter = bvNone
      Caption = 'ShadowPanel1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      FaceColor = 16041572
      ShadowColor = clBlack
      Shape = stRoundRect
      ShadowOffset = 2
      ShapeVisible = True
      object lblTitle: TLabel
        Left = 9
        Top = 5
        Width = 72
        Height = 16
        Caption = 'lblTitle'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
    end
  end
  object ToolBar: TToolBar [6]
    Left = 0
    Top = 0
    Width = 688
    Height = 24
    ButtonHeight = 7
    ButtonWidth = 13
    Caption = 'ToolBar'
    Color = 15790320
    EdgeBorders = [ebBottom]
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    List = True
    ParentColor = False
    ParentFont = False
    ShowCaptions = True
    TabOrder = 0
    object btnExpertPrint: TCMXwPrintBtn
      Left = 0
      Top = 0
      Width = 65
      Height = 7
      Caption = #25171#21360
      Enabled = True
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ShowMenuBtn = True
      PrintID = 0
      ShowSetUpDialog = False
      NeedRecordStatus = False
    end
    object tbsPrintSep: TToolButton
      Left = 65
      Top = 0
      Width = 8
      Caption = 'tbsPrintSep'
      ImageIndex = 0
      Style = tbsSeparator
    end
  end
  inherited CMEventHandler: TCMEventHandler
    SetPrintIdAndTemplateName = CMEventHandlerSetPrintIdAndTemplateName
  end
  object cdsGetRecordSet: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pv_sp_Open'
    Left = 624
    Top = 340
  end
  object XPMenu1: TXPMenu
    DimLevel = 30
    GrayLevel = 10
    Font.Charset = ANSI_CHARSET
    Font.Color = clMenuText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Color = clBtnFace
    IconBackColor = clBtnFace
    MenuBarColor = clBtnFace
    SelectColor = clHighlight
    SelectBorderColor = clHighlight
    SelectFontColor = clMenuText
    DisabledColor = clInactiveCaption
    SeparatorColor = clBtnFace
    CheckedColor = clHighlight
    IconWidth = 24
    DrawSelect = True
    UseSystemColors = True
    OverrideOwnerDraw = False
    Gradient = False
    FlatMenu = False
    AutoDetect = True
    Active = False
    Left = 568
    Top = 80
  end
end
