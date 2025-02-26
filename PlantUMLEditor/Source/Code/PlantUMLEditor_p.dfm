object frmPlantUMLEditor: TfrmPlantUMLEditor
  Left = 0
  Top = 0
  Caption = 'PlantUML Editor'
  ClientHeight = 603
  ClientWidth = 1067
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object Edge: TEdgeBrowser
    Left = 0
    Top = 41
    Width = 1067
    Height = 562
    Align = alClient
    TabOrder = 0
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnNavigationCompleted = EdgeNavigationCompleted
    OnWebMessageReceived = EdgeWebMessageReceived
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1067
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      1067
      41)
    object lblEdtFileName: TLabel
      Left = 585
      Top = 12
      Width = 22
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'File'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 8
      Top = 7
      Width = 105
      Height = 25
      Alignment = taRightJustify
      BevelWidth = 2
      Caption = 'Select File '
      Color = 16447734
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      OnClick = Panel1Click
      object Image1: TImage
        Left = 5
        Top = 2
        Width = 25
        Height = 21
        Picture.Data = {
          0B5453564747726170686963980200003C73766720786D6C6E733D2268747470
          3A2F2F7777772E77332E6F72672F323030302F737667222076696577426F783D
          223020302035373620353132223E3C212D2D2120466F6E7420417765736F6D65
          204672656520362E312E312062792040666F6E74617765736F6D65202D206874
          7470733A2F2F666F6E74617765736F6D652E636F6D204C6963656E7365202D20
          68747470733A2F2F666F6E74617765736F6D652E636F6D2F6C6963656E73652F
          66726565202849636F6E733A20434320425920342E302C20466F6E74733A2053
          494C204F464C20312E312C20436F64653A204D4954204C6963656E7365292043
          6F70797269676874203230323220466F6E7469636F6E732C20496E632E202D2D
          3E3C7061746820643D224D3537322E36203237302E336C2D3936203139324334
          37312E32203437332E32203436302E3120343830203434372E31203438304836
          34632D33352E333520302D36342D32382E36362D36342D363456393663302D33
          352E33342032382E36352D36342036342D3634683131372E356331362E393720
          302033332E323520362E3734322034352E32362031382E37354C3237352E3920
          3936483431366333352E333520302036342032382E3636203634203634763332
          682D34385631363063302D382E3832342D372E3137382D31362D31362D313648
          3235364C3139322E382038342E3639433138392E382038312E3636203138352E
          38203830203138312E352038304836344335352E31382038302034382038372E
          3138203438203936763238386C37312E31362D3134322E33433132342E362032
          33302E38203133352E3720323234203134372E3820323234683339362E324335
          36372E3720323234203538332E3220323439203537322E36203237302E337A22
          2F3E3C2F7376673E}
        Proportional = True
        Stretch = True
      end
    end
    object edtFileName: TEdit
      Left = 616
      Top = 11
      Width = 441
      Height = 21
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 1
    end
    object btnSave: TPanel
      Left = 122
      Top = 7
      Width = 81
      Height = 25
      Hint = 'Save the current diagram'
      Alignment = taRightJustify
      BevelWidth = 2
      Caption = 'Save  '
      Color = 16447734
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = btnSaveClick
      object Image2: TImage
        Left = 5
        Top = 2
        Width = 25
        Height = 21
        Picture.Data = {
          0B5453564747726170686963F00000003C73766720786D6C6E733D2268747470
          3A2F2F7777772E77332E6F72672F323030302F737667222076696577426F783D
          22302030203234203234223E0A202020203C673E0A20202020202020203C7061
          74682066696C6C3D226E6F6E652220643D224D30203068323476323448307A22
          2F3E0A20202020202020203C7061746820643D224D3138203231762D38483676
          384834613120312030203020312D312D3156346131203120302030203120312D
          316831336C342034763133613120312030203020312D312031682D327A6D2D32
          20304838762D36683876367A222F3E0A202020203C2F673E0A3C2F7376673E0A}
        Proportional = True
        Stretch = True
      end
    end
  end
  object TimerDelayedLoad: TTimer
    Enabled = False
    OnTimer = TimerDelayedLoadTimer
    Left = 208
    Top = 416
  end
  object TimerBackup: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = TimerBackupTimer
    Left = 640
    Top = 264
  end
  object MainMenu: TMainMenu
    Left = 432
    Top = 128
    object File1: TMenuItem
      Caption = 'File'
      object Save1: TMenuItem
        Caption = 'Save'
        Hint = 'Save the current code.'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As'
        Hint = 'Save the current code with a name of your choosing.'
        ShortCut = 24659
        OnClick = SaveAs1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        Hint = 'Close this application.'
        ShortCut = 32883
        OnClick = Exit1Click
      end
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'PlantUml files|*.puml;*.pu;*.plantuml;*.iuml'
    Options = [ofOverwritePrompt, ofShowHelp, ofEnableSizing]
    Left = 760
    Top = 400
  end
  object SVGIconImageList1: TSVGIconImageList
    SVGIconItems = <
      item
        IconName = 'folder-open'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><!' +
          '--! Font Awesome Free 6.1.1 by @fontawesome - https://fontawesom' +
          'e.com License - https://fontawesome.com/license/free (Icons: CC ' +
          'BY 4.0, Fonts: SIL OFL 1.1, Code: MIT License) Copyright 2022 Fo' +
          'nticons, Inc. --><path d="M572.6 270.3l-96 192C471.2 473.2 460.1' +
          ' 480 447.1 480H64c-35.35 0-64-28.66-64-64V96c0-35.34 28.65-64 64' +
          '-64h117.5c16.97 0 33.25 6.742 45.26 18.75L275.9 96H416c35.35 0 6' +
          '4 28.66 64 64v32h-48V160c0-8.824-7.178-16-16-16H256L192.8 84.69C' +
          '189.8 81.66 185.8 80 181.5 80H64C55.18 80 48 87.18 48 96v288l71.' +
          '16-142.3C124.6 230.8 135.7 224 147.8 224h396.2C567.7 224 583.2 2' +
          '49 572.6 270.3z"/></svg>'
      end
      item
        IconName = 'save-fill_rm'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'#10'   ' +
          ' <g>'#10'        <path fill="none" d="M0 0h24v24H0z"/>'#10'        <path' +
          ' d="M18 21v-8H6v8H4a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h13l4 4v13a1 1 ' +
          '0 0 1-1 1h-2zm-2 0H8v-6h8v6z"/>'#10'    </g>'#10'</svg>'#10
      end>
    Scaled = True
    Left = 760
    Top = 112
  end
  object OpenTextFileDialog: TOpenTextFileDialog
    Filter = 'PlantUml files|*.puml;*.pu;*.plantuml;*.iuml'
    Left = 440
    Top = 272
  end
end
