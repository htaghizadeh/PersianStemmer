object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 362
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    624
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 8
    Top = 8
    Width = 608
    Height = 346
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      608
      346)
    object lbl1: TLabel
      Left = 540
      Top = 13
      Width = 23
      Height = 13
      Anchors = [akTop, akRight]
      BiDiMode = bdRightToLeft
      Caption = #1604#1594#1578':'
      ParentBiDiMode = False
      ExplicitLeft = 550
    end
    object Label1: TLabel
      Left = 540
      Top = 40
      Width = 40
      Height = 13
      Anchors = [akTop, akRight]
      BiDiMode = bdRightToLeft
      Caption = #1585#1740#1588#1607#8204#1607#1575':'
      ParentBiDiMode = False
      ExplicitLeft = 550
    end
    object Label2: TLabel
      Left = 540
      Top = 177
      Width = 65
      Height = 13
      Anchors = [akTop, akRight]
      BiDiMode = bdRightToLeft
      Caption = #1602#1608#1575#1593#1583' '#1605#1585#1576#1608#1591#1607':'
      ParentBiDiMode = False
      WordWrap = True
      ExplicitLeft = 550
    end
    object edtWord: TEdit
      Left = 9
      Top = 10
      Width = 528
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      TabOrder = 0
    end
    object btnClose: TBitBtn
      Left = 9
      Top = 308
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Cancel = True
      Caption = #1576#1587#1578#1606
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
      TabOrder = 3
      OnClick = btnCloseClick
    end
    object btnOK: TBitBtn
      Left = 462
      Top = 308
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1578#1581#1604#1740#1604
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 5
      OnClick = btnOKClick
    end
    object mmoStemList: TMemo
      Left = 9
      Top = 37
      Width = 528
      Height = 131
      Anchors = [akLeft, akTop, akRight]
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object mmoPatternList: TMemo
      Left = 9
      Top = 174
      Width = 528
      Height = 125
      Anchors = [akLeft, akTop, akRight, akBottom]
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object btnReLoadPattern: TBitBtn
      Left = 356
      Top = 308
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1576#1575#1586#1582#1608#1575#1606#1740' '#1602#1608#1575#1593#1583
      NumGlyphs = 2
      TabOrder = 4
      OnClick = btnReLoadPatternClick
    end
  end
end
