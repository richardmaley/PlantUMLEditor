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
  Winapi.WebView2;

Type
  TfrmPlantUMLEditor = Class(TForm)
    Edge: TEdgeBrowser;
    edtFileName: TEdit;
    pnlFileName: TPanel;
    Timer: TTimer;
    TimerRestoreClipboard: TTimer;
    procedure EdgeNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    Procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TimerRestoreClipboardTimer(Sender: TObject);
  Public
    PlantUMLURL   : String;
    sgClipboardWas: String;
    TimeElapsed   : Integer;
    Function GenThemes(): String;
    Function LoadDiagram(FileName: String): Boolean;
    Function RunJavaScript(Script, ProcName: String): Boolean;
    Procedure ScriptTemplate();
  End;

Var
  frmPlantUMLEditor: TfrmPlantUMLEditor;

  // Const
  // PlantUMLURL='https://plantuml.mseiche.de/';
Implementation

Uses
  PUmlExamples,
  ads.Globals,
  ads.Sendkey,
  PlantUmlHtml,
  PleaseWait;

{$R *.dfm}

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

procedure TfrmPlantUMLEditor.EdgeNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
Var
  FileName: String;
begin
  frmPleaseWait.Close;
  If ParamCount > 0 Then
  Begin
    FileName := ParamStr(1);
    If FileExists(FileName) Then
    Begin
      LoadDiagram(FileName);
    End;
  End
  Else
  Begin
    FileName := FileLast;
    If (Trim(FileName) <> '') And FileExists(FileName) Then
    Begin
      LoadDiagram(FileName);
    End;
  End;
  ActiveControl := Edge;
end;

Procedure TfrmPlantUMLEditor.FormActivate(Sender: TObject);
Begin
  If Tag = 0 Then
  Begin
    SaveThemedExamplesToDisk(DirImages + 'Examples\');
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
end;

procedure TfrmPlantUMLEditor.FormCreate(Sender: TObject);
begin
  TimeElapsed := 0;
end;

function TfrmPlantUMLEditor.GenThemes: String;
Var
  s      : String;
  Themes : Array [0 .. 43] of String;
  Files  : Array [0 .. 3] of String;
  i      : Integer;
  j      : Integer;
  inMid  : Integer;
  inStart: Integer;
  inEnd  : Integer;
begin
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
  ShowMessage('Done');
end;

function TfrmPlantUMLEditor.LoadDiagram(FileName: String): Boolean;
Var
  Script: String;
  Path  : String;
begin
  Result := False;
  If Trim(FileName) = '' Then
    Exit;
  If Not FileExists(FileName) Then
    Exit;
  edtFileName.Text := FileName;
  // Clipboard.AsText:=ExtractFileName(FileName);
  sgClipboardWas := Clipboard.AsText;
  // ShowMessage(sgClipboardWas);
  Clipboard.AsText := FileName;
  Path             := ExtractFilePath(FileName);
  Path             := StringReplace(Path, '\', '/', [rfReplaceAll]);
  FileName         := StringReplace(FileName, '\', '/', [rfReplaceAll]);
  Script           := '  let msg="loadPlantUMLDiagram";' + #13 + #10 +    //
    '  let succeed=false;' + #13 + #10 +                                  //
    '  try {' + #13 + #10 +                                               //
    '    document.getElementById("load-file-btn").click();' + #13 + #10 + //
    '    loadPlantUMLDiagram("");' + #13 + #10 +                          //
  // '    alert("After loadPlantUMLDiagram");'+#13+#10+//
    '    msg=msg+" SUCCEEDED";' + #13 + #10 +                              //
    '    succeed=true;' + #13 + #10 +                                      //
    '  } catch (error) {' + #13 + #10 +                                    //
    '    msg=msg=msg+" FAILED";' + #13 + #10 +                             //
    '    console.error(msg, error);' + #13 + #10 +                         //
    '    console.error(msg+"ErrorName:", error.name);' + #13 + #10 +       //
    '    console.error(msg+"ErrorMessage:", error.message);' + #13 + #10 + //
    '    console.error(msg+"ErrorStack:", error.stack);' + #13 + #10 +     //
    '    msg=msg+";Error="+error.message;' + #13 + #10 +                   //
    '  }' + #13 + #10;                                                     //
  Timer.Enabled := True;
  Result        := RunJavaScript(Script, 'loadPlantUMLDiagram');
  // Clipboard.AsText:=sgClipboardWas;
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
    on E: Exception do
  end;
end;

procedure TfrmPlantUMLEditor.TimerRestoreClipboardTimer(Sender: TObject);
begin
  TimerRestoreClipboard.Enabled := False;
  If Trim(sgClipboardWas) <> '' Then
    Clipboard.AsText := sgClipboardWas;
end;

procedure TfrmPlantUMLEditor.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  SimulateCtrlV;
  SimulateEnter;
  Application.ProcessMessages;
  TimerRestoreClipboard.Enabled := True;
end;

End.
