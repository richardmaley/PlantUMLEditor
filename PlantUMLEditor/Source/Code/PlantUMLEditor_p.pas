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
    btnLoadFile: TButton;
    btnSave: TButton;
    Edge: TEdgeBrowser;
    edtFileName: TEdit;
    ImageList: TImageList;
    OpenDialog: TOpenDialog;
    pnlFileName: TPanel;
    Timer: TTimer;
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure EdgeNavigationCompleted(Sender: TCustomEdgeBrowser;IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    Procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
  Public
    Function CopyFileContentsToClipboard(const FileName: string): Boolean;
    Function IsValidPlantUML(s: String): Boolean;
    Function LoadFile(FileName: String): Boolean;
    Function SaveCurrentCode(FileName: String): Boolean;
  End;

Var
  frmPlantUMLEditor: TfrmPlantUMLEditor;

Const
  PlantUMLURL='https://plantuml.mseiche.de/';
Implementation
Uses
  ads.Globals,
  ads.Sendkey;

{$R *.dfm}
Function FileToStr(FileName: String): String;
Var
  lst: TStringlist;
Begin
  Result:='';
  if Not FileExists(FileName) Then Exit;
  lst:=TStringlist.Create();
  Try
    lst.LoadFromFile(FileName);
    Result:=lst.Text;
  Finally
    FreeAndNil(lst);
  End;
End;

Function StrToFile(s:String;FileName:String):Boolean;
Var
  lst:TStringlist;
Begin
  Result:=False;
  If FileExists(FileName) Then
  Begin
    DeleteFile(FileName);
    Application.ProcessMessages();
    If FileExists(FileName) Then
      Exit;
  End;
  lst:=TStringlist.Create();
  Try
    lst.SetText(PWideChar(s));
    lst.SaveToFile(FileName);
    Result:=FileExists(FileName);
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

procedure SimulateCtrlC;
begin
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(Ord('C'), 0, 0, 0);
  keybd_event(Ord('C'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
end;

function TfrmPlantUMLEditor.CopyFileContentsToClipboard(const FileName: string): Boolean;
var
  sgData: String;
begin
  Result := False;
  Clipboard.AsText := '@startuml' + #13 + #10 + 'Bob->Alice' + #13 + #10 + '@enduml' + #13 + #10;
  if not FileExists(FileName) then Exit;
  sgData:=FileToStr(FileName);
  If Not IsValidPlantUML(sgData) Then Exit;
  Clipboard.AsText := sgData;
  Result:=True;
end;

Function CloneMenuItem(SourceItem:TMenuItem):TMenuItem;
Var
  i:Integer;
Begin
  With SourceItem Do
  Begin
    Result:=NewItem(Caption,Shortcut,Checked,Enabled,OnClick,HelpContext,Name+'Copy');
    If Action<>Nil Then
      result.Action:=action;
    If imageindex>-1 Then
      result.imageindex:=imageindex;
    For i:=0 To Count-1 Do
      Result.Add(CloneMenuItem(Items[i]));
  End;
End;

Procedure CloneMainMenu(m:TMainmenu;p:TPopupMenu);
Var
  i:integer;
Begin
  p.Items.Clear;
  p.Images:=m.Images;
  For i:=0 To m.Items.Count-1 Do
  Begin
    If m.Items[i].Visible Then
    Begin
      p.Items.Add(CloneMenuItem(m.Items[i]));
    End;
  End;
End;

procedure TfrmPlantUMLEditor.btnSaveClick(Sender: TObject);
begin
  If Trim(edtFileName.text)<>'' Then
  Begin
    SaveCurrentCode(edtFileName.text);
  End
  Else
  Begin
    btnLoadFileClick(Sender);
  End;
end;


procedure TfrmPlantUMLEditor.btnLoadFileClick(Sender: TObject);
begin
  If Trim(FileLast) <> '' Then
    OpenDialog.InitialDir := ExtractFilePath(FileLast);
  If OpenDialog.Execute() Then
  Begin
    FileLast         := OpenDialog.FileName;
    IniData.Values['FileLast']:=FileLast;
    edtFileName.text := FileLast;
    Clipboard.AsText := '@startuml' + #13 + #10 + 'Bob->Alice' + #13 + #10 + '@enduml' + #13 + #10;
    If FileExists(FileLast) Then
    Begin
      edtFileName.text := FileLast;
      CopyFileContentsToClipboard(FileLast);
      ActiveControl := Edge;
      Application.ProcessMessages();
      SetMousePosition(100, 100);
      Application.ProcessMessages();
      Sendkey(VK_LBUTTON);
      Application.ProcessMessages();
      SimulateCtrlA;
      Application.ProcessMessages();
      SimulateCtrlV;
      Application.ProcessMessages();
    End;

    ActiveControl := Edge;
    Application.ProcessMessages();
    SetMousePosition(100, 100);
    Application.ProcessMessages();
    SimulateLeftMouseClick;
    Application.ProcessMessages();
    Sendkey(VK_LBUTTON);
    Application.ProcessMessages();
    SimulateCtrlA;
    Application.ProcessMessages();
    SimulateCtrlV;
    Application.ProcessMessages();
  End;
end;

procedure TfrmPlantUMLEditor.EdgeNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
Var
  sgtemp: String;
begin
  Clipboard.AsText := '@startuml' + #13 + #10 + 'Bob->Alice' + #13 + #10 + '@enduml' + #13 + #10;
  If ParamCount > 0 Then
  Begin
    //sgtemp := ParamStr(1);
    If FileExists(ParamStr(1)) Then
    Begin
      LoadFile(ParamStr(1));
//      FileLast:=sgTemp;
//      IniData.Values['FileLast']:=FileLast;
//      edtFileName.text := FileLast;
//      CopyFileContentsToClipboard(FileLast);
//      ActiveControl := Edge;
//      Application.ProcessMessages();
//      SetMousePosition(100, 100);
//      Application.ProcessMessages();
//      Sendkey(VK_LBUTTON);
//      Application.ProcessMessages();
//      SimulateCtrlA;
//      Application.ProcessMessages();
//      SimulateCtrlV;
//      Application.ProcessMessages();
    End;
  End
  Else
  Begin
    If (Trim(FileLast)<>'') And FileExists(FileLast) Then
    Begin
      LoadFile(FileLast);
//      edtFileName.text := FileLast;
//      CopyFileContentsToClipboard(FileLast);
//      ActiveControl := Edge;
//      Application.ProcessMessages();
//      SetMousePosition(100, 100);
//      Application.ProcessMessages();
//      Sendkey(VK_LBUTTON);
//      Application.ProcessMessages();
//      SimulateCtrlA;
//      Application.ProcessMessages();
//      SimulateCtrlV;
//      Application.ProcessMessages();
    End;
  End;
  ActiveControl := Edge;
  Application.ProcessMessages();
  SetMousePosition(100, 100);
  Application.ProcessMessages();
  SimulateLeftMouseClick;
  Application.ProcessMessages();
  Sendkey(VK_LBUTTON);
  Application.ProcessMessages();
  SimulateCtrlA;
  Application.ProcessMessages();
  SimulateCtrlV;
  Application.ProcessMessages();
end;

Procedure TfrmPlantUMLEditor.FormActivate(Sender: TObject);
Begin
  If Tag = 0 Then
  Begin
    FileLast:='';
    If Trim(IniData.Values['FileLast'])<>'' Then FileLast:=IniData.Values['FileLast'];
    WindowState:=wsMaximized;
    Edge.Navigate(PlantUmlUrl);
  End;
  Tag := 1;
End;

procedure TfrmPlantUMLEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IniData.SaveToFile(FileIni);
end;

function TfrmPlantUMLEditor.IsValidPlantUML(s: String): Boolean;
Var
  inPosStart: Integer;
  inPosEnd: Integer;
begin
  Result:=False;
  If Trim(s)='' Then Exit;
  s:=LowerCase(s);
  inPosStart:=Pos('@startuml',s);
  If inPosStart=0 Then Exit;
  inPosEnd:=Pos('@enduml',s);
  If inPosEnd=0 Then Exit;
  If InPosEnd<=inPosStart Then Exit;
  Result:=True;
end;

function TfrmPlantUMLEditor.LoadFile(FileName: String): Boolean;
begin
  Result:=False;
  If Not FileExists(FileName) Then Exit;
  FileLast:=FileName;
  IniData.Values['FileLast']:=FileLast;
  edtFileName.text := FileLast;
  CopyFileContentsToClipboard(FileLast);
  ActiveControl := Edge;
  Application.ProcessMessages();
  SetMousePosition(100, 100);
  Application.ProcessMessages();
  Sendkey(VK_LBUTTON);
  Application.ProcessMessages();
  SimulateCtrlA;
  Application.ProcessMessages();
  SimulateCtrlV;
  Application.ProcessMessages();
  Result:=True;
end;

function TfrmPlantUMLEditor.SaveCurrentCode(FileName: String): Boolean;
begin
  Timer.Enabled:=True;
  Result:=True;
end;

procedure TfrmPlantUMLEditor.TimerTimer(Sender: TObject);
Var
  sgCode: String;
  FileName: String;
  sgDt: String;
begin
  Timer.Enabled:=False;
  FileName:=edtFileName.Text;
  sgDt := FormatDateTime('YYYYMMDDHHNNSS',now());
  ActiveControl:=Edge;
  Application.ProcessMessages();
  SetMousePosition(100,100);
  Application.ProcessMessages();
  SimulateLeftMouseClick;
  Application.ProcessMessages();
  SendKey(VK_LBUTTON);
  Application.ProcessMessages();
  SimulateCtrlA;
  Application.ProcessMessages();
  SimulateCtrlC;
  Application.ProcessMessages();
  sgCode:=Clipboard.AsText;
  SetMousePosition(100,100);
  Application.ProcessMessages();
  SimulateLeftMouseClick;
  Application.ProcessMessages();

  If Trim(sgCode)<>'' Then
  Begin
    If FileExists(FileName) Then
    Begin
      CopyFile(PWideChar(FileName),PWideChar(FileName+sgDt+'.bak'),False);
    End;
    StrToFile(sgCode,FileName);
  End
end;

End.
