object DiagramDev: TDiagramDev
  Left = 0
  Top = 0
  Width = 1102
  Height = 752
  AlphaBlendValue = 245
  AutoScroll = True
  Caption = 'Status flow diagram'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_wzor: TPanel
    Left = 805
    Top = 627
    Width = 273
    Height = 41
    Cursor = crHandPoint
    BevelKind = bkFlat
    BevelOuter = bvNone
    BorderWidth = 2
    Caption = 'New Status'
    Color = 11141120
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    PopupMenu = PopupMenuPanelu
    TabOrder = 0
    Visible = False
    StyleElements = []
    OnMouseDown = pnl_wzorMouseDown
    OnMouseMove = pnl_wzorMouseMove
    OnMouseUp = pnl_wzorMouseUp
  end
  object pnl_narzedzia: TPanel
    Left = 0
    Top = 0
    Width = 1086
    Height = 40
    Align = alTop
    Color = 16250871
    ParentBackground = False
    TabOrder = 1
    object btn_nowy: TButton
      Left = 8
      Top = 6
      Width = 121
      Height = 25
      Caption = 'New Status'
      TabOrder = 0
      OnClick = btn_nowyClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 674
    Width = 1086
    Height = 19
    Panels = <
      item
        Width = 300
      end>
  end
  object PopupMenuPanelu: TPopupMenu
    Left = 408
    Top = 168
    object Zmienazw1: TMenuItem
      Caption = 'Rename'
      OnClick = Zmienazw1Click
    end
    object Dodajpowizanie1: TMenuItem
      Caption = 'Add association'
      OnClick = Dodajpowizanie1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Usupowizaniategoobiektu1: TMenuItem
      Caption = 'Delete all associations for this object'
      OnClick = Usupowizaniategoobiektu1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Usuobiekt1: TMenuItem
      Caption = 'Delete object'
      OnClick = Usuobiekt1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 408
    Top = 112
    object Diagram1: TMenuItem
      Caption = 'Diagram'
      object Nowy1: TMenuItem
        Caption = 'New'
        OnClick = Nowy1Click
      end
      object Wczytajdiagramzpliku1: TMenuItem
        Caption = 'Load from file'
        OnClick = Wczytajdiagramzpliku1Click
      end
      object Zapiszdopliku1: TMenuItem
        Caption = 'Save to file'
        OnClick = Zapiszdopliku1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object EksportujdiagramdoplikuPNG1: TMenuItem
        Caption = 'Export to PNG'
        OnClick = EksportujdiagramdoplikuPNG1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Zamknij1: TMenuItem
        Caption = 'Close'
        OnClick = Zamknij1Click
      end
    end
    object Narzdzia1: TMenuItem
      Caption = 'Tools'
      object chkPositionRunTime: TMenuItem
        Caption = 'Enable component setting'
        Checked = True
        OnClick = chkPositionRunTimeClick
      end
      object cbox_zadaj_nazwy: TMenuItem
        Caption = 'Request to give the object a name when creating it'
        Checked = True
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Szukajniepowizanychobiektw1: TMenuItem
        Caption = 'Search for unrelated objects'
        OnClick = Szukajniepowizanychobiektw1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object AlphaBlend1: TMenuItem
        Caption = 'AlphaBlend'
        OnClick = AlphaBlend1Click
      end
      object CarbonStyle1: TMenuItem
        Caption = 'CarbonStyle'
        OnClick = CarbonStyle1Click
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.fdia'
    Filter = 'Pliki diagramu|*.fdia'
    Title = 'Zapisz diagram do pliku'
    Left = 408
    Top = 216
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.fdia'
    Filter = 'Pliki diagramu|*.fdia'
    Title = 'Wczytaj diagram z pliku'
    Left = 408
    Top = 272
  end
  object SavePictureDialog: TSavePictureDialog
    DefaultExt = '*.png'
    Filter = 'PNG Picture|*.png'
    Title = 'Eksport diagramu do pliku PNG'
    Left = 408
    Top = 328
  end
  object AutoRefresh: TTimer
    Enabled = False
    Interval = 100
    OnTimer = AutoRefreshTimer
    Left = 408
    Top = 376
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 408
    Top = 432
  end
end
