object fUserDetails: TfUserDetails
  Left = 237
  Top = 305
  BorderStyle = bsNone
  Caption = '#00692^eVocabulary word details'
  ClientHeight = 188
  ClientWidth = 1060
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  DesignSize = (
    1060
    188)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 1060
    Height = 188
    Align = alClient
    Shape = bsFrame
    ExplicitWidth = 752
    ExplicitHeight = 219
  end
  object Label5: TLabel
    Left = 8
    Top = 9
    Width = 94
    Height = 13
    Caption = '#00060^ePhonetic:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Shape2: TShape
    Left = 8
    Top = 25
    Width = 249
    Height = 29
    Brush.Color = clWindow
  end
  object pbPhonetic: TPaintBox
    Left = 9
    Top = 26
    Width = 248
    Height = 27
    Color = clBtnFace
    ParentColor = False
    OnPaint = pbPhoneticPaint
  end
  object Shape5: TShape
    Left = 269
    Top = 25
    Width = 248
    Height = 29
    Brush.Color = clWindow
  end
  object Label6: TLabel
    Left = 269
    Top = 9
    Width = 86
    Height = 13
    Caption = '#00061^eWritten:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object pbKanji: TPaintBox
    Left = 270
    Top = 26
    Width = 246
    Height = 27
    Color = clBtnFace
    ParentColor = False
    OnMouseMove = pbKanjiMouseMove
    OnPaint = pbKanjiPaint
  end
  object Label9: TLabel
    Left = 8
    Top = 65
    Width = 93
    Height = 13
    Caption = '#00691^eMeaning:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 839
    Top = 24
    Width = 89
    Height = 13
    Caption = '#00694^eCreated:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 839
    Top = 82
    Width = 108
    Height = 13
    Caption = '#00695^eLearning list:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 839
    Top = 44
    Width = 91
    Height = 13
    Caption = '#00696^eLearned:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 839
    Top = 63
    Width = 96
    Height = 13
    Caption = '#00697^eMastered:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblDateCreated: TLabel
    Left = 929
    Top = 22
    Width = 48
    Height = 16
    Caption = 'Label15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblDateLearned: TLabel
    Left = 929
    Top = 42
    Width = 48
    Height = 16
    Caption = 'Label15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblDateMastered: TLabel
    Left = 929
    Top = 61
    Width = 48
    Height = 16
    Caption = 'Label15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblTimesPrinted: TLabel
    Left = 929
    Top = 80
    Width = 48
    Height = 16
    Caption = 'Label15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object btnMoveUpInCategory: TSpeedButton
    Left = 999
    Top = 8
    Width = 53
    Height = 34
    Hint = '#00698^eMove up in the category'
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
      3333333333777F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
      3333333777737777F333333099999990333333373F3333373333333309999903
      333333337F33337F33333333099999033333333373F333733333333330999033
      3333333337F337F3333333333099903333333333373F37333333333333090333
      33333333337F7F33333333333309033333333333337373333333333333303333
      333333333337F333333333333330333333333333333733333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = btnMoveUpInCategoryClick
    ExplicitLeft = 832
  end
  object btnMoveDownInCategory: TSpeedButton
    Left = 999
    Top = 56
    Width = 53
    Height = 34
    Hint = '#00699^eMove down in the category'
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
      333333333337F33333333333333033333333333333373F333333333333090333
      33333333337F7F33333333333309033333333333337373F33333333330999033
      3333333337F337F33333333330999033333333333733373F3333333309999903
      333333337F33337F33333333099999033333333373333373F333333099999990
      33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333300033333333333337773333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = btnMoveDownInCategoryClick
    ExplicitLeft = 832
  end
  object btnDelete: TButton
    Left = 999
    Top = 146
    Width = 53
    Height = 34
    Hint = '#00700^eDelete this word'
    Anchors = [akRight, akBottom]
    Caption = '#00701^eDelete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnDeleteClick
  end
  object btnSaveMeaning: TButton
    Left = 441
    Top = 157
    Width = 75
    Height = 23
    Caption = '#00553^eChange'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnSaveMeaningClick
  end
  object GroupBox3: TGroupBox
    Left = 655
    Top = 8
    Width = 170
    Height = 169
    Caption = '#00634^eCategories'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    DesignSize = (
      170
      169)
    object cbAddCategory: TComboBox
      Left = 9
      Top = 20
      Width = 96
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = cbAddCategoryChange
    end
    object btnAddToCategory: TButton
      Left = 105
      Top = 20
      Width = 57
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '#00078^eAdd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnAddToCategoryClick
    end
    object lbCategories: TListBox
      Left = 8
      Top = 48
      Width = 154
      Height = 96
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 2
    end
    object btnRemoveFromCategory: TButton
      Left = 105
      Top = 145
      Width = 57
      Height = 18
      Anchors = [akRight, akBottom]
      Caption = '#00079^eRemove'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnRemoveFromCategoryClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 522
    Top = 8
    Width = 127
    Height = 169
    Caption = '#00693^eStatus:'
    TabOrder = 3
    object lblLearnState: TRxLabel
      Left = 9
      Top = 16
      Width = 75
      Height = 18
      Caption = 'Learned'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object btnSetProblematic: TButton
      Left = 9
      Top = 42
      Width = 113
      Height = 25
      Caption = '#00638^eProblematic'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSetProblematicClick
    end
    object btnSetUnlearned: TButton
      Tag = 1
      Left = 9
      Top = 73
      Width = 113
      Height = 25
      Caption = '#00639^eUnlearned'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnSetProblematicClick
    end
    object btnSetLearned: TButton
      Tag = 2
      Left = 9
      Top = 104
      Width = 113
      Height = 25
      Caption = '#00640^eLearned'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnSetProblematicClick
    end
    object btnSetMastered: TButton
      Tag = 3
      Left = 9
      Top = 135
      Width = 113
      Height = 25
      Caption = '#00703^eMastered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnSetProblematicClick
    end
  end
  object edtMeaning: TMemo
    Left = 8
    Top = 84
    Width = 508
    Height = 68
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'edtMeaning')
    ParentFont = False
    TabOrder = 4
    WantReturns = False
    OnChange = edtMeaningChange
    OnKeyPress = edtMeaningKeyPress
  end
end
