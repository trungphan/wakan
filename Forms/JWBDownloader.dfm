object fDownloader: TfDownloader
  Left = 0
  Top = 0
  Caption = 'File Downloader'
  ClientHeight = 485
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    480
    485)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPageTitle: TLabel
    Left = 8
    Top = 8
    Width = 88
    Height = 25
    Caption = 'Page title'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblPageDescription: TLabel
    Left = 8
    Top = 39
    Width = 255
    Height = 13
    Caption = 'Page description which is taken from active page Hint'
  end
  object btnClose: TBitBtn
    Left = 377
    Top = 448
    Width = 95
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnNext: TBitBtn
    Left = 276
    Top = 448
    Width = 95
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Next'
    Default = True
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnPrev: TBitBtn
    Left = 175
    Top = 448
    Width = 95
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Back'
    TabOrder = 1
    OnClick = btnPrevClick
  end
  object PageControl: TPageControl
    Left = 8
    Top = 58
    Width = 464
    Height = 384
    ActivePage = tsSelectFiles
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsButtons
    TabOrder = 0
    OnChange = PageControlChange
    object tsReadyToDownload: TTabSheet
      Hint = 'The following files will be downloaded/updated:'
      Caption = 'Ready to download'
      ImageIndex = 1
      TabVisible = False
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 358
        Width = 450
        Height = 13
        Align = alBottom
        Caption = 'Press "Download" to proceed.'
        ExplicitWidth = 143
      end
      object lbFilesToDownload: TListBox
        Left = 0
        Top = 0
        Width = 456
        Height = 355
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object tsDownloading: TTabSheet
      Hint = 'Your files are being downloaded. Please wait...'
      Caption = 'Downloading'
      ImageIndex = 2
      TabVisible = False
      object vtJobs: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 456
        Height = 374
        Align = alClient
        BorderWidth = 1
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Images = ilJobImages
        TabOrder = 0
        TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning, toFullRowDrag, toEditOnClick]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
        OnBeforeCellPaint = vtJobsBeforeCellPaint
        OnFreeNode = vtJobsFreeNode
        OnGetText = vtJobsGetText
        OnGetImageIndex = vtJobsGetImageIndex
        OnGetNodeDataSize = vtJobsGetNodeDataSize
        OnInitNode = vtJobsInitNode
        Columns = <
          item
            Position = 0
            Width = 210
            WideText = 'Component'
            WideHint = 'Name'
          end
          item
            Position = 1
            Width = 210
            WideText = 'Status'
          end>
      end
    end
    object tsSelectFiles: TTabSheet
      Hint = 'Please select which files you want to download:'
      Caption = 'Select Files'
      TabVisible = False
      object vtKnownFiles: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 456
        Height = 255
        Align = alClient
        BorderWidth = 1
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Images = ilKnownFileImages
        TabOrder = 0
        TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning, toFullRowDrag, toEditOnClick]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
        OnChecked = vtKnownFilesChecked
        OnCompareNodes = vtKnownFilesCompareNodes
        OnFocusChanged = vtKnownFilesFocusChanged
        OnFreeNode = vtKnownFilesFreeNode
        OnGetText = vtKnownFilesGetText
        OnPaintText = vtKnownFilesPaintText
        OnGetImageIndex = vtKnownFilesGetImageIndex
        OnGetNodeDataSize = vtKnownFilesGetNodeDataSize
        OnInitNode = vtKnownFilesInitNode
        ExplicitHeight = 285
        Columns = <
          item
            Position = 0
            Width = 320
            WideText = 'Name'
            WideHint = 'Name'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Language'
          end>
      end
      object mmFileDetails: TMemo
        Left = 0
        Top = 285
        Width = 456
        Height = 89
        Align = alBottom
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 0
        Top = 255
        Width = 456
        Height = 30
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitTop = 344
        DesignSize = (
          456
          30)
        object cbCheckDownloadAll: TCheckBox
          Left = 8
          Top = 6
          Width = 441
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Check / uncheck all'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbCheckDownloadAllClick
        end
      end
    end
  end
  object ilKnownFileImages: TImageList
    Left = 312
    Top = 8
  end
  object ilJobImages: TImageList
    Left = 400
    Top = 8
    Bitmap = {
      494C010102000C00480010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F6F9F700F9FBF900000000000000000000000000000000000000
      0000000000000000000000000000000000007AC9EC002DA7E0002BA4DF0029A1
      DD00279EDC00259BDA002398D9002093D6001B8CD3001685CF00117ECC000D77
      C9000971C600066CC3000368C1005D9CD6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FAF70037833D00347D3A00F9FBF9000000000000000000000000000000
      00000000000000000000000000000000000047B6E600BEE3F500F4FCFE00EFFB
      FE00EEFBFE00EEFBFE00EFFCFE00EFFCFE00EFFBFE00EEFBFE00EDFBFE00EDFB
      FE00ECFBFE00F2FCFE00ABCEEB00297FCA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7FA
      F700408E470054A35C004F9F5700327C3800F8FAF80000000000000000000000
      000000000000000000000000000000000000C3E7F70062BFE800F4FCFE00B5EF
      FA0058DAF50058DAF50057D8F30058D7F20058D6F20057D9F40051D8F5004ED7
      F40062DAF600EAFBFE004493D200B5D4ED000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7FBF800499A
      51005BAC640077CA820074C87E0051A05900337D3900F8FAF800000000000000
      000000000000000000000000000000000000000000005EC0EA009DD7F100E7F9
      FD008BE5F8005ADBF6005BDAF4003DA1D5003DA1D50054D6F20052D8F50050D6
      F400D8F6FC0088BFE50054A0D800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8FBF80051A65A0063B5
      6D007ECE89007BCC870076CA810076C9810052A25A00347E3A00F8FAF8000000
      00000000000000000000000000000000000000000000E2F4FB0037B2E500F3FB
      FE00C3F2FB005CDCF6005CDAF40064DFF60057CBEB0055D6F20054D9F50094E7
      F800E3F4FB001C89D100DDEDF700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F9FCF90059B063006BBD760084D2
      90007AC9850060B26A0063B46D0078C9830078CB820053A35C0035803B00F8FA
      F80000000000000000000000000000000000000000000000000079CCEE008CD2
      F000EAFBFE0094E6F8005CDAF40047B1DD003DA1D50056D7F2005CDBF500DEF8
      FD007DC0E70087C3E80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D2EBD5006CBC760079C9860080CE
      8D0053A75B00B1D6B5009BC9A0005CAD67007CCC860079CB850054A45D003781
      3D00F8FAF8000000000000000000000000000000000000000000F5FBFD0044B9
      E700C8EAF700E6FAFD005DDAF4003DA1D5003DA1D50057D7F200C7F3FC00C0E3
      F4003BA3DD00F4FAFD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D9EEDB006BBD75006DC0
      7900B5DAB900000000000000000098C79C005EAE68007DCD89007CCD870056A5
      5F0038823E00F8FAF8000000000000000000000000000000000000000000B8E5
      F60071C8ED00F9FEFF005EDCF4003EA2D5003EA2D5005CD9F400EDFBFE0068BB
      E500B2DCF2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D4EDD700BEE2
      C2000000000000000000000000000000000098C79D005FAF69007FCE8A007ECE
      890057A6600039833F00F8FAF800000000000000000000000000000000000000
      000059C3EB00A9DFF400EDF9FD003EA3D6003EA3D600D4F5FC00A2D7F1005CB8
      E500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000098C89D0060B06A0081CF
      8D007FCF8B0058A7610039854000F8FAF8000000000000000000000000000000
      0000D9F1FA0039B7E800F9FDFF0094E9F9009EEBFA00ECFAFE0031AAE100D7EE
      F900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000099C89E0062B2
      6C0082D18F007AC8850057A660009FC3A2000000000000000000000000000000
      00000000000073CDEF0094D8F200F3FCFE00E7FAFE008FD3F00085CEEE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000099C9
      9E0063B36D005FAF6900A4CAA800000000000000000000000000000000000000
      000000000000F1FAFD0044BDEA00F1FAFD00D5EFFA0043B7E700F0F9FD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009ACA9F00A4CEA80000000000000000000000000000000000000000000000
      000000000000000000008DD7F30085D4F10082D1F000ACE0F500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FCFEFE005CC7EE0068CAEE00FCFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000F9FF000000000000
      F0FF000000000000E07F000000000000C03F800100000000801F800100000000
      000FC003000000000007C003000000008603E00700000000CF01F00F00000000
      FF80F00F00000000FFC0F81F00000000FFE1F81F00000000FFF3FC3F00000000
      FFFFFC3F00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object tmrJobUpdateTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrJobUpdateTimerTimer
    Left = 400
    Top = 112
  end
end
