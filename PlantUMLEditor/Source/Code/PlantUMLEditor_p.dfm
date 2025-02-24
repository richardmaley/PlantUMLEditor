object frmPlantUMLEditor: TfrmPlantUMLEditor
  Left = 0
  Top = 0
  Caption = 'PlantUML Editor'
  ClientHeight = 603
  ClientWidth = 1057
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object Edge: TEdgeBrowser
    Left = 0
    Top = 35
    Width = 1057
    Height = 568
    Align = alClient
    TabOrder = 0
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnNavigationCompleted = EdgeNavigationCompleted
    OnWebMessageReceived = EdgeWebMessageReceived
  end
  object pnlFileName: TPanel
    Left = 0
    Top = 0
    Width = 1057
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    DesignSize = (
      1057
      35)
    object edtFileName: TEdit
      Left = 16
      Top = 10
      Width = 971
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 208
    Top = 416
  end
  object TimerRestoreClipboard: TTimer
    Enabled = False
    OnTimer = TimerRestoreClipboardTimer
    Left = 376
    Top = 424
  end
  object TimerBackup: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = TimerBackupTimer
    Left = 640
    Top = 264
  end
end
