object GraspForm: TGraspForm
  Left = 744
  Top = 377
  Caption = 'GraspForm'
  ClientHeight = 446
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgPrintButton: TImage
    Left = 38
    Top = 24
    Width = 36
    Height = 18
    Picture.Data = {
      07544269746D6170560A0000424D560A00000000000036000000280000002400
      0000120000000100200000000000200A0000120B0000120B0000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00D0C5BC009C8674009C8674009C8674009C8674009C8674009C8674009C86
      74009C867400D0C6BD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E0E0E000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00E1E1E100FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C5B8AD00B1A09100D7CFC700D7CF
      C700D7CFC700D7CFC700D7CFC700D7CFC700B1A09100C5B8AD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D9D9D900CDCD
      CD00E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500CDCDCD00D9D9
      D900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C5B8AD00AF9D8E00D1C7BE00D1C7BE00D1C7BE00D1C7BE00D1C7BE00D1C7
      BE00AF9D8E00C5B8AD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00D9D9D900CBCBCB00E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100CBCBCB00D9D9D900FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C5B8AD00AC9A8B00CABEB500CABE
      B500CABEB500CABEB500CABEB500CABEB500AC9A8B00C5B8AD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D9D9D900CACA
      CA00DDDDDD00DDDDDD00DDDDDD00DDDDDD00DDDDDD00DDDDDD00CACACA00D9D9
      D900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B4A39600B8A9
      9C00C5B8AD00AA978800C4B6AC00C4B6AC00C4B6AC00C4B6AC00C4B6AC00C4B6
      AC00AA978800C5B8AD00B8A99C00B4A39600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00CFCFCF00D1D1D100D9D9D900C8C8C800D9D9D900D9D9D900D9D9D900D9D9
      D900D9D9D900D9D9D900C8C8C800D9D9D900D1D1D100CFCFCF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF009C867400D4CBC300C9BDB300AE9C8E00C4B6AC00C4B6
      AC00C4B6AC00C4B6AC00C4B6AC00C4B6AC00AE9C8E00C9BDB300D4CBC3009C86
      7400FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFBFBF00E3E3E300DCDCDC00CBCB
      CB00D9D9D900D9D9D900D9D9D900D9D9D900D9D9D900D9D9D900CBCBCB00DCDC
      DC00E3E3E300BFBFBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C867400C4B7
      AD00D1C7BE00D1C7BE00D1C7BE00D1C7BE00D1C7BE00D1C7BE00D1C7BE00D1C7
      BE00D1C7BE00D1C7BE00C4B7AD009C867400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00BFBFBF00D9D9D900E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100D9D9D900BFBFBF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF009C8674009C8674009C8674009C8674009C8674009C86
      74009C8674009C8674009C8674009C8674009C8674009C8674009C8674009C86
      7400FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C8674009C86
      74009C8674009C8674009C8674009C8674009C8674009C8674009C8674009C86
      74009C867400D2C8C000C0B3A7009C867400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00E2E2E200D7D7D700BFBFBF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF009C8674009C8674009C8674009C8674009C8674009C86
      74009C8674009C8674009C8674009C8674009D877500F5F3F100DCD4CD009C86
      7400FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00C0C0C000F8F8
      F800E8E8E800BFBFBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009F8A79009C86
      74009C8674009C8674009C8674009C8674009C8674009C8674009C8674009C86
      74009C8674009E8977009C8675009F8A7800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C1C1C100BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00C1C1C100BFBFBF00C1C1C100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00F5F3F100D8D0C800C7BAB000BAAA9D00B2A19300B09E
      9000AA988800AA988800B09E9000B2A19300BAAA9D00C7BAB000D8CFC800F5F3
      F100FFFFFF00FFFFFF00FFFFFF00FFFFFF00F8F8F800E6E6E600DBDBDB00D2D2
      D200CDCDCD00CCCCCC00C8C8C800C8C8C800CCCCCC00CDCDCD00D2D2D200DBDB
      DB00E6E6E600F8F8F800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00E0D9D300CABEB500CABEB500CABEB500CABEB500CABEB500CABEB500CABE
      B500CABEB500E0D9D300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EBEBEB00DDDDDD00DDDDDD00DDDDDD00DDDDDD00DDDD
      DD00DDDDDD00DDDDDD00DDDDDD00EBEBEB00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C5B8AD009C8674009C8674009C86
      74009C8674009C8674009C8674009C8674009C867400C5B8AD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D9D9D900BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00D9D9
      D900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C5B8AD009C8674009C8674009C8674009C8674009C8674009C8674009C86
      74009C867400C5B8AD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00D9D9D900BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00D9D9D900FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D1C7BE009C8674009C8674009C86
      74009C8674009C8674009C8674009C8674009C867400D1C7BF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E1E1E100BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00E1E1
      E100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00}
    Visible = False
  end
  object imgArrowDown: TImage
    Left = 80
    Top = 24
    Width = 18
    Height = 5
    Picture.Data = {
      07544269746D61709A040000424D9A0400000000000036040000280000001200
      000005000000010008000000000064000000120B0000120B0000000100000000
      0000000000000101010002020200030303000404040005050500060606000707
      070008080800090909000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F
      0F00101010001111110012121200131313001414140015151500161616001717
      170018181800191919001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F
      1F00202020002121210022222200232323002424240025252500262626002727
      270028282800292929002A2A2A002B2B2B002C2C2C002D2D2D002E2E2E002F2F
      2F00303030003131310032323200333333003434340035353500363636003737
      370038383800393939003A3A3A003B3B3B003C3C3C003D3D3D003E3E3E003F3F
      3F00404040004141410042424200434343004444440045454500464646004747
      470048484800494949004A4A4A004B4B4B004C4C4C004D4D4D004E4E4E004F4F
      4F00505050005151510052525200535353005454540055555500565656005757
      570058585800595959005A5A5A005B5B5B005C5C5C005D5D5D005E5E5E005F5F
      5F00606060006161610062626200636363006464640065656500666666006767
      670068686800696969006A6A6A006B6B6B006C6C6C006D6D6D006E6E6E006F6F
      6F00707070007171710072727200737373007474740075757500767676007777
      770078787800797979007A7A7A007B7B7B007C7C7C007D7D7D007E7E7E007F7F
      7F00808080008181810082828200838383008484840085858500868686008787
      870088888800898989008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F
      8F00909090009191910092929200939393009494940095959500969696009797
      970098989800999999009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F
      9F00A0A0A000A1A1A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7
      A700A8A8A800A9A9A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAF
      AF00B0B0B000B1B1B100B2B2B200B3B3B300B4B4B400B5B5B500B6B6B600B7B7
      B700B8B8B800B9B9B900BABABA00BBBBBB00BCBCBC00BDBDBD00BEBEBE00BFBF
      BF00C0C0C000C1C1C100C2C2C200C3C3C300C4C4C400C5C5C500C6C6C600C7C7
      C700C8C8C800C9C9C900CACACA00CBCBCB00CCCCCC00CDCDCD00CECECE00CFCF
      CF00D0D0D000D1D1D100D2D2D200D3D3D300D4D4D400D5D5D500D6D6D600D7D7
      D700D8D8D800D9D9D900DADADA00DBDBDB00DCDCDC00DDDDDD00DEDEDE00DFDF
      DF00E0E0E000E1E1E100E2E2E200E3E3E300E4E4E400E5E5E500E6E6E600E7E7
      E700E8E8E800E9E9E900EAEAEA00EBEBEB00ECECEC00EDEDED00EEEEEE00EFEF
      EF00F0F0F000F1F1F100F2F2F200F3F3F300F4F4F400F5F5F500F6F6F600F7F7
      F700F8F8F800F9F9F900FAFAFA00FBFBFB00FCFCFC00FDFDFD00FEFEFE00FFFF
      FF00FFFFFFFF61FFFFFFFFFFFFFFFFA6FFFFFFFF0000FFFFFF616160FFFFFFFF
      FFFFA6A5A6FFFFFF0000FFFF6161616061FFFFFFFFA6A5A6A6A6FFFF0000FF61
      616061616161FFFFA6A6A6A6A5A6A6FF0000616161606161606061A6A6A5A6A6
      A5A6A6A60000}
    Visible = False
  end
  object CMEventHandler: TCMEventHandler
    Left = 552
    Top = 208
  end
end
