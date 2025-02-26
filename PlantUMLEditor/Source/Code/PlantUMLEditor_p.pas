Unit PlantUMLEditor_p;

Interface

Uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.ImageList,
  System.SysUtils,
  System.Variants,
  Vcl.Buttons,
  Vcl.Clipbrd,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.DBCtrls,
  Vcl.DBGrids,
  Vcl.Dialogs,
  Vcl.Edge,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Grids,
  Vcl.ImgList,
  Vcl.Menus,
  Vcl.StdCtrls,
  Winapi.ActiveX,
  Winapi.WebView2, SVGIconImageListBase, SVGIconImageList, SVGIconImage,
  Vcl.ExtDlgs;

Type
  TPlantUMLFile = class
  Private
    FCode    : String;
    FFileName: String;
    FTitle   : String;
  Public
    property Code    : String read FCode write FCode;
    property FileName: String read FFileName write FFileName;
    property Title   : String read FTitle write FTitle;
  end;

  TfrmPlantUMLEditor = Class(TForm)
    Edge: TEdgeBrowser;
    TimerDelayedLoad: TTimer;
    TimerBackup: TTimer;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog: TSaveDialog;
    pnlHeader: TPanel;
    SVGIconImageList1: TSVGIconImageList;
    Panel1: TPanel;
    Image1: TImage;
    OpenTextFileDialog: TOpenTextFileDialog;
    edtFileName: TEdit;
    lblEdtFileName: TLabel;
    btnSave: TPanel;
    Image2: TImage;
    procedure EdgeNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    procedure EdgeWebMessageReceived(Sender: TCustomEdgeBrowser; Args: TWebMessageReceivedEventArgs);
    Procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TimerBackupTimer(Sender: TObject);
    procedure TimerDelayedLoadTimer(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  Public
    inBackupRepeats : Integer;
    PlantUMLFile    : TPlantUMLFile;
    PlantUMLURL     : String;
    sgBackupCode    : String;
    sgBackupFileName: String;
    sgClipboardWas  : String;
    Function File_Save(): Boolean;
    Function File_SaveAs(): Boolean;

    Function Load_File(): Boolean;overload;
    Function Load_File(FileName: String): Boolean;overload;
    Function GenThemes(): String;
    Function GenTPlantUMLFileAsJSON(): String;
    Function RunJavaScript(Script, ProcName: String): Boolean;
    Procedure GenTPlantUMLFileFromJSON(out PlantUMLFile: TPlantUMLFile; Json: String);
    Procedure ScriptTemplate();
  End;

Var
  frmPlantUMLEditor: TfrmPlantUMLEditor;

Implementation

Uses
  ads.FileNew,
  ads.Globals,
  ads.JsonUtils,
  ads.Sendkey,
  Clipbrd,
  PlantUmlHtml,
  PleaseWait,
  PUmlExamples,
  REST.Json,
  System.Json;

{$R *.dfm}

const
  UnitName = 'PlantUMLEditor_p';

function GetTextFromClipboard: string;
var
  ClipboardText: string;
begin
  // Initialize the clipboard
  ClipboardText := '';

  // Check if the clipboard contains text
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    // Get the text from the clipboard
    ClipboardText := Clipboard.AsText;
  end
  else
  begin
    // Handle the case where the clipboard does not contain text
    raise Exception.Create('Clipboard does not contain text.');
  end;

  // Return the copied text
  Result := ClipboardText;
end;

procedure CopyTextToClipboard(const Text: string);
begin
  // Clear the clipboard
  Clipboard.Clear;

  // Set the text to the clipboard
  Clipboard.AsText := Text;
end;

Function FileToStr(FileName: String): String;
Var
  lst: TStringlist;
Begin
  Result := '';
  if Not FileExists(FileName) Then
    Exit;
  lst := TStringlist.Create();
  Try
    lst.LoadFromFile(FileName);
    Result := lst.Text;
  Finally
    FreeAndNil(lst);
  End;
End;

Function StrToFile(s: String; FileName: String): Boolean;
Var
  lst: TStringlist;
Begin
  Result := False;
  If FileExists(FileName) Then
  Begin
    DeleteFile(FileName);
    Application.ProcessMessages();
    If FileExists(FileName) Then
      Exit;
  End;
  lst := TStringlist.Create();
  Try
    lst.SetText(PWideChar(s));
    lst.SaveToFile(FileName);
    Result := FileExists(FileName);
  Finally
    FreeAndNil(lst);
  End;
End;

procedure SimulateLeftMouseClick;
begin
  mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
end;

procedure SetMousePosition(X, Y: Integer);
begin
  if not SetCursorPos(X, Y) then
    RaiseLastOSError;
end;

procedure SimulateCtrlA;
begin
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(Ord('A'), 0, 0, 0);
  keybd_event(Ord('A'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
end;

procedure SimulateCtrlV;
begin
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(Ord('V'), 0, 0, 0);
  keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
end;

procedure SimulateEnter;
begin
  keybd_event(VK_RETURN, 0, 0, 0);
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0);
end;

procedure SimulateCtrlC;
begin
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(Ord('C'), 0, 0, 0);
  keybd_event(Ord('C'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
end;

Function CloneMenuItem(SourceItem: TMenuItem): TMenuItem;
Var
  i: Integer;
Begin
  With SourceItem Do
  Begin
    Result := NewItem(Caption, Shortcut, Checked, Enabled, OnClick, HelpContext, Name + 'Copy');
    If Action <> Nil Then
      Result.Action := Action;
    If imageindex > -1 Then
      Result.imageindex := imageindex;
    For i               := 0 To Count - 1 Do
      Result.Add(CloneMenuItem(Items[i]));
  End;
End;

Procedure CloneMainMenu(m: TMainmenu; p: TPopupMenu);
Var
  i: Integer;
Begin
  p.Items.Clear;
  p.Images := m.Images;
  For i    := 0 To m.Items.Count - 1 Do
  Begin
    If m.Items[i].Visible Then
    Begin
      p.Items.Add(CloneMenuItem(m.Items[i]));
    End;
  End;
End;

procedure TfrmPlantUMLEditor.btnSaveClick(Sender: TObject);
begin
  File_Save();
end;

procedure TfrmPlantUMLEditor.EdgeNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
begin
  ActiveControl := Edge;
  If boAutoBackup Then
  Begin
    If IniData.Values['inBackupFrequencyMins'] <> '' Then
      Try
        inBackupFrequencyMins := StrToInt(IniData.Values['inBackupFrequencyMins']);
      Except
        inBackupFrequencyMins                   := 1;
        IniData.Values['inBackupFrequencyMins'] := '1';
      End;
    TimerBackup.Interval := inBackupFrequencyMins * 60 * 1000;
//TimerBackup.Interval:=15000;
    If IniData.Values['boAutoBackup'] = 'TRUE' Then
      TimerBackup.Enabled := True;
  End;
  TimerDelayedLoad.Enabled:=True;
end;

procedure TfrmPlantUMLEditor.EdgeWebMessageReceived(Sender: TCustomEdgeBrowser; Args: TWebMessageReceivedEventArgs);
Var
  JsonStr  : PWideChar;
  Json     : TJsonObject;
  ProcName : String;
  sgMessage: String;
  sgTitle  : String;
begin
  ProcName := 'TfrmPlantUMLEditor.EdgeWebMessageReceived';
  Try
    Args.ArgsInterface.TryGetWebMessageAsString(JsonStr);
    If IsJsonValid(JsonStr) Then
    Begin
      if Args.ArgsInterface.TryGetWebMessageAsString(JsonStr) = S_OK then
      begin
        Json    := TJSONValue.ParseJSONValue(JsonStr) as TJsonObject;
        sgTitle := Json.GetValue('Title').AsType<String>;
        If sgTitle = 'File_BackUp' Then
        Begin
          GenTPlantUMLFileFromJSON(PlantUMLFile, JsonStr);
          sgMessage := 'PlantUMLFile=' + #13 + #10 + 'Title=' + PlantUMLFile.Title + #13 + #10 + 'FileName=' + PlantUMLFile.FileName + #13 + #10 + 'Code=' + PlantUMLFile.Code + #13 + #10;
          If Trim(PlantUMLFile.FileName)='' Then PlantUMLFile.FileName:='unknown.puml';
          If Trim(PlantUMLFile.Code)<>'' Then
          Begin
            BackupIfNeeded(PlantUMLFile.Code, PlantUMLFile.FileName, DirBackup);
          End;
          TimerBackup.Enabled := True;
        End Else
        If sgTitle = 'File_Save' Then
        Begin
          GenTPlantUMLFileFromJSON(PlantUMLFile, JsonStr);
          sgMessage := 'PlantUMLFile=' + #13 + #10 + 'Title=' + PlantUMLFile.Title + #13 + #10 + 'FileName=' + PlantUMLFile.FileName + #13 + #10 + 'Code=' + PlantUMLFile.Code + #13 + #10;
          If Trim(PlantUMLFile.FileName)='' Then PlantUMLFile.FileName:='unknown.puml';
          If Trim(PlantUMLFile.Code)<>'' Then
          Begin
            SaveDialog.InitialDir:=DirImages;
            SaveDialog.FileName:=PlantUMLFile.FileName;
            If SaveDialog.Execute() Then
            Begin
              FileLast:=SaveDialog.FileName;
              IniData.Values['FileLast']:=FileLast;
              IniData.SaveToFile(FileIni);
              StrToFile(PlantUMLFile.Code,FileLast);
            End;
          End;
        End Else
        If sgTitle = 'File_SaveAs' Then
        Begin
          GenTPlantUMLFileFromJSON(PlantUMLFile, JsonStr);
          sgMessage := 'PlantUMLFile=' + #13 + #10 + 'Title=' + PlantUMLFile.Title + #13 + #10 + 'FileName=' + PlantUMLFile.FileName + #13 + #10 + 'Code=' + PlantUMLFile.Code + #13 + #10;
          If Trim(PlantUMLFile.FileName)='' Then PlantUMLFile.FileName:='unknown.puml';
          If Trim(PlantUMLFile.Code)<>'' Then
          Begin
            SaveDialog.InitialDir:=DirImages;
            SaveDialog.FileName:=PlantUMLFile.FileName;
            If SaveDialog.Execute() Then
            Begin
              FileLast:=SaveDialog.FileName;
              IniData.Values['FileLast']:=FileLast;
              IniData.SaveToFile(FileIni);
              StrToFile(PlantUMLFile.Code,FileLast);
            End;
          End;
        End;
      end;
    End
    Else
    Begin
      sgMessage := 'Failed IsJsonValid(JsonStr)' + #13 + #10 + JsonStr;
      LogMessage(UnitName, ProcName, sgMessage);
    End;
  Except
    on e: Exception Do
    Begin
      sgMessage := e.Message;
      LogMessage(UnitName, ProcName, sgMessage);
    End;
  End;
end;

procedure TfrmPlantUMLEditor.Exit1Click(Sender: TObject);
begin
  Close;
end;

function TfrmPlantUMLEditor.File_Save: Boolean;
begin
  Result:=RunJavaScript('File_Save();', 'File_Save');
end;

function TfrmPlantUMLEditor.File_SaveAs: Boolean;
begin
  Result:=RunJavaScript('File_SaveAs();', 'File_SaveAs');
end;

Procedure TfrmPlantUMLEditor.FormActivate(Sender: TObject);
Begin
  If Tag = 0 Then
  Begin
    SaveThemedExamplesToDisk(DirImages + 'Examples\');
    SaveDiagramTypesToDisk(DirImages);
    FileLast := '';
    InitHtml(DirCode + 'PlantUmlEditor.html');
    PlantUMLURL := 'file:///' + DirCode + 'PlantUmlEditor.html';
    If IniData.Values['PlantUMLURL'] <> '' Then
    Begin
      PlantUMLURL := IniData.Values['PlantUMLURL'];
    End;
    IniData.Values['PlantUMLURL'] := PlantUMLURL;
    If Trim(IniData.Values['FileLast']) <> '' Then
      FileLast  := IniData.Values['FileLast'];
    WindowState := wsMaximized;
    Edge.Navigate(PlantUMLURL);
    frmPleaseWait.Show;
  End;
  Tag := 1;
End;

procedure TfrmPlantUMLEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IniData.SaveToFile(FileIni);
  FreeAndNil(PlantUMLFile);
end;

procedure TfrmPlantUMLEditor.FormCreate(Sender: TObject);
begin
  PlantUMLFile := TPlantUMLFile.Create;
end;

function TfrmPlantUMLEditor.GenThemes: String;
Var
  Files    : Array [0 .. 3] of String;
  i        : Integer;
  inEnd    : Integer;
  inMid    : Integer;
  inStart  : Integer;
  j        : Integer;
  ProcName : String;
  s        : String;
  Themes   : Array [0 .. 43] of String;
  sgMessage: string;
begin
  ProcName   := 'TfrmPlantUMLEditor.GenThemes';
  Themes[0]  := 'amiga';
  Themes[1]  := 'aws-orange';
  Themes[2]  := 'black-knight';
  Themes[3]  := 'bluegray';
  Themes[4]  := 'blueprint';
  Themes[5]  := 'carbon-gray';
  Themes[6]  := 'cerulean-outline';
  Themes[7]  := 'cerulean';
  Themes[8]  := 'cloudscape-design';
  Themes[9]  := 'crt-amber';
  Themes[10] := 'crt-green';
  Themes[11] := 'cyborg-outline';
  Themes[12] := 'cyborg';
  Themes[13] := 'hacker';
  Themes[14] := 'lightgray';
  Themes[15] := 'mars';
  Themes[16] := 'materia-outline';
  Themes[17] := 'materia';
  Themes[18] := 'metal';
  Themes[19] := 'mimeograph';
  Themes[20] := 'minty';
  Themes[21] := 'mono';
  Themes[22] := 'none';
  Themes[23] := 'plain';
  Themes[24] := 'reddress-darkblue';
  Themes[25] := 'reddress-darkgreen';
  Themes[26] := 'reddress-darkorange';
  Themes[27] := 'reddress-darkred';
  Themes[28] := 'reddress-lightblue';
  Themes[29] := 'reddress-lightgreen';
  Themes[30] := 'reddress-lightorange';
  Themes[31] := 'reddress-lightred';
  Themes[32] := 'sandstone';
  Themes[33] := 'silver';
  Themes[34] := 'sketchy-outline';
  Themes[35] := 'sketchy';
  Themes[36] := 'spacelab-white';
  Themes[37] := 'spacelab';
  Themes[38] := 'Sunlust';
  Themes[39] := 'superhero-outline';
  Themes[40] := 'superhero';
  Themes[41] := 'toy';
  Themes[42] := 'united';
  Themes[43] := 'vibrant';
  inMid      := (Length(Themes) div 4) - 1;
  inStart    := Low(Themes);
  inEnd      := inStart + inMid - 1;
  For j      := 0 To 3 Do
  Begin
    s :=                                              //
      '@startuml' + #13 + #10 +                       //
      '<style>' + #13 + #10 +                         //
      '  title {' + #13 + #10 +                       //
      '    BackGroundColor transparent' + #13 + #10 + //
      '    FontColor black' + #13 + #10 +             //
      '    HorizontalAlignment center' + #13 + #10 +  //
      '  }  ' + #13 + #10 +                           //
      '</style>' + #13 + #10 +                        //
      'label l [' + #13 + #10;                        //
    For i := inStart To inEnd Do
    Begin
      If i = 22 Then
        Continue;
      If i = 38 Then
        Continue;
      If Themes[i] = 'none' Then
        Continue;
      If Themes[i] = 'Sunlust' Then
        Continue;
      s := s +                                                      //
        '{{' + #13 + #10 +                                          //
        '!theme ' + Themes[i] + #13 + #10 +                         //
        'title ' + Themes[i] + #13 + #10 +                          //
        'Alice -> Bob: ' + Themes[i] + #13 + #10 +                  //
        'Bob -> Alice: ' + Themes[i] + #13 + #10 +                  //
        '}}' + #13 + #10 +                                          //
        '{{' + #13 + #10 +                                          //
        'title ___________________________________  ' + #13 + #10 + //
        '}}' + #13 + #10;                                           //
    End;
    s        := s + ']' + #13 + #10 + '@enduml' + #13 + #10;
    Result   := s;
    Files[j] := s;
    StrToFile(s, DirImages + 'PlantUMLThemes' + IntToStr(j + 1) + '.puml');
    inStart := inEnd + 1;
    inEnd   := inStart + inMid - 1;
    If inEnd > High(Themes) Then
      inEnd := High(Themes);
    If j = 2 Then
      inEnd := High(Themes);
  End;

  Result := '''PlantUMLThemes1.puml' + #13 + #10 + Files[0] + #13 + #10 + '''PlantUMLThemes2.puml' + #13 + #10 + Files[1] + #13 + #10 + '''PlantUMLThemes3.puml' + #13 + #10 + Files[2] + #13 + #10 + '''PlantUMLThemes4.puml' + #13 + #10 + Files[3] +
    #13 + #10;
  StrToFile(Result, DirImages + 'PlantUMLThemesAll.puml');
  sgMessage := 'Done';
  LogMessage(UnitName, ProcName, sgMessage);
end;

Function TfrmPlantUMLEditor.GenTPlantUMLFileAsJSON(): String;
var
  Json: String;
begin
  Result := '';
  try
    Json   := TJSON.ObjectToJsonString(PlantUMLFile, [joIndentCaseCamel, joDateIsUTC]);
    Result := Json;
  Except
  end;
end;

procedure TfrmPlantUMLEditor.GenTPlantUMLFileFromJSON(out PlantUMLFile: TPlantUMLFile; Json: String);
begin
  If Trim(Json) = '' Then
    Exit;
  PlantUMLFile := TJSON.JsonToObject<TPlantUMLFile>(Json, []);
end;

function TfrmPlantUMLEditor.Load_File(FileName: String): Boolean;
Var
  JsonStr: string;
begin
  Result:=False;
  If Trim(FileName)='' Then Exit;
  If Not FileExists(FileName) Then Exit;
  FileLast:=FileName;
  IniData.Values['FileLast']:=FileLast;
  IniData.SaveToFile(FileIni);
  edtFileName.Text:=FileLast;
  PlantUMLFile.Title:='File_Load';
  PlantUMLFile.FileName:=FileLast;
  PlantUMLFile.Code:=FileToStr(FileLast);
  JsonStr:=TJson.ObjectToJsonString(PlantUMLFile,[joIndentCasePreserve]);
  RunJavaScript('File_Load('+JsonStr+');', 'File_Load');
  Result:=True;
end;

function TfrmPlantUMLEditor.Load_File: Boolean;
Var
  JsonStr: string;
begin
  Result:=False;
  OpenTextFileDialog.InitialDir:=DirImages;
  If OpenTextFileDialog.Execute() Then
  Begin
    Result:=Load_File(OpenTextFileDialog.FileName);
  End;
end;

procedure TfrmPlantUMLEditor.Panel1Click(Sender: TObject);
begin
  Load_File();
end;

procedure TfrmPlantUMLEditor.Save1Click(Sender: TObject);
begin
  File_Save();
end;

procedure TfrmPlantUMLEditor.SaveAs1Click(Sender: TObject);
begin
  File_SaveAs();
end;

procedure TfrmPlantUMLEditor.ScriptTemplate;
Var
  Script  : String;
  ProcName: String;
begin
  ProcName := 'PasteWith?';
  Script   := 'alert("' + ProcName + '1");' + #13 + #10 +

    'alert("' + ProcName + '2");' + #13 + #10 +

    'alert("' + ProcName + '3");' + #13 + #10;
  RunJavaScript(Script, ProcName);
end;

Function TfrmPlantUMLEditor.RunJavaScript(Script, ProcName: String): Boolean;
var
  sgDt: string;
begin
  Result := False;
  try
    ActiveControl := Edge;
    Application.ProcessMessages;
    sgDt := FormatDateTime('YYYYMMDDHHNNSS', now());
    StrToFile(Script, DirReports + ProcName + sgDt + '.js');
    Edge.ExecuteScript(Script);
    Result := True;
  except
    on e: Exception do
  end;
end;

procedure TfrmPlantUMLEditor.TimerBackupTimer(Sender: TObject);
begin
  TimerBackup.Enabled := False;
  RunJavaScript('File_BackUp();', 'File_BackUp');
end;

procedure TfrmPlantUMLEditor.TimerDelayedLoadTimer(Sender: TObject);
Var
  FileName: String;
begin
  TimerDelayedLoad.Enabled := False;
  frmPleaseWait.Close;
  If ParamCount > 0 Then
  Begin
    FileName := ParamStr(1);
    If FileExists(FileName) Then
    Begin
      Load_File(FileName);
    End;
  End
  Else
  Begin
    FileName := FileLast;
    If (Trim(FileName) <> '') And FileExists(FileName) Then
    Begin
      Load_File(FileName);
    End;
  End;
end;

End.
