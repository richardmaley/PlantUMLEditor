Unit ads.Globals;
{Copyright(c)2023 Advanced Delphi Systems

  Richard Maley
  Advanced Delphi Systems
  12613 Maidens Bower Drive
  Potomac, MD 20854 USA
  phone 301-840-1554
  dickmaley@advdelphisys.com

  The code herein can be used or modified by anyone.  Please retain references
  to Richard Maley at Advanced Delphi Systems.  If you make improvements to the
  code please send your improvements to dickmaley@advdelphisys.com so that the
  entire Delphi community can benefit.  All comments are welcome.
}

Interface

Uses
  System.Classes,
  System.SysUtils,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

Var
  { (* }
  boAllProjDirRSubDir   : Boolean = False;
  boActivateProfiler    : Boolean = False;
  boDebug               : Boolean = False;
  boDirBackup           : Boolean = False;
  boDirBin              : Boolean = False;
  boDirCode             : Boolean = True;
  boDirDB               : Boolean = False;
  boDirDest             : Boolean = False;
  boDirDFMInfo          : Boolean = False;
  boDirDFMInfoCOMERCIAL : Boolean = False;
  boDirDFMInfoCONTA     : Boolean = False;
  boDirDFMInfoPOSVENTA  : Boolean = False;
  boDirDFMInfoTEST      : Boolean = False;
  boDirHelp             : Boolean = False;
  boDirImages           : Boolean = False;
  boDirPersist          : Boolean = False;
  boDirReports          : Boolean = False;
  boDirResources        : Boolean = False;
  boDirResUtilities     : Boolean = False;
  boDirSearches         : Boolean = False;
  boDirSource           : Boolean = False;
  boDirSQL              : Boolean = False;
  boDirTestData         : Boolean = False;
  boDirToolbar          : Boolean = False;
  boDirWorking          : Boolean = False;
  boDirXMLDocs          : Boolean = False;
  boLoadTestData        : Boolean = False;
  boLog                 : Boolean = False;
  boPersistDFMInfoToDB  : Boolean = False;
  boPersistDFMInfoToFile: Boolean = False;
  boRunDFMInfoTests     : Boolean = False;
  boUseAnlyzdDFMInfoData: Boolean = False;
  DirAppDataCommon      : String  = '';
  DirAppDataLocal       : String  = '';
  DirCommonFiles        : String  = '';
  DirBackup             : String  = '';
  DirBin                : String  = '';
  DirCode               : String  = '';
  DirDB                 : String  = '';
  DirDest               : String  = '';
  DirDFMInfo            : String  = '';
  DirDFMInfoCOMERCIAL   : String  = '';
  DirDFMInfoCONTA       : String  = '';
  DirDFMInfoPOSVENTA    : String  = '';
  DirDFMInfoTEST        : String  = '';
  DirHistory            : String  = '';
  DirHelp               : String  = '';
  DirImages             : String  = '';
  DirInternetCache      : String  = '';
  DirInternetCookies    : String  = '';
  DirLast               : String  = '';
  DirMyMusic            : String  = '';
  DirMyDocuments        : String  = '';
  DirMyPictures         : String  = '';
  DirPersist            : String  = '';
  DirProgFiles          : String  = '';
  DirProgramFiles       : String  = '';
  DirProgramFilesCommon : String  = '';
  DirReports            : String  = '';
  DirResources          : String  = '';
  DirResUtilities       : String  = '';
  DirSearches           : String  = '';
  DirSource             : String  = '';
  DirSQL                : String  = '';
  DirSystem32           : String  = '';
  DirTestData           : String  = '';
  DirToolbar            : String  = '';
  DirWindows            : String  = '';
  DirWorking            : String  = '';
  DirXMLDocs            : String  = '';
  Exceptions            : String  = '';
  ExeName               : String  = '';
  ExePath               : String  = '';
  FileNameDB            : String  = '';
  FileSQLiteStudio      : String  = '';
  FileIni               : String  = '';
  FileLast              : String  = '';
  FileLastHTML          : String  = '';
  inTestDataFilterCount : Integer = 1;
  IniData               : TStringList;
  Log                   : TStringList;
  { *) }
Function FindUnusedUnits(CodeDir, DCUDir: String): Boolean;
Function LogException(UnitName, ProcName, sgMessage: String): Boolean;
Function LogMessage(UnitName, ProcName, sgMessage: String): Boolean;
Function Sort(s: String): String;
Function SortDesc(s: String): String;
Function SortNoDups(s: String): String;
Function UpdateIniFromVar(v: TCustomEdit; ini: TStringList): String; OverLoad;
Function UpdateIniFromVar(v: TRadioGroup; ini: TStringList): String; OverLoad;
Function UpdateIniFromVar(Var v: Boolean; VarName: String; ini: TStringList): String; OverLoad;
Function UpdateIniFromVar(Var v: Integer; VarName: String; ini: TStringList): String; OverLoad;
Function UpdateIniFromVar(Var v: String; VarName: String; ini: TStringList): String; OverLoad;
Function UpdateVarFromIni(v: TCustomEdit; ini: TStringList): String; OverLoad;
Function UpdateVarFromIni(v: TRadioGroup; ini: TStringList): String; OverLoad;
Function UpdateVarFromIni(Var v: Boolean; VarName: String; ini: TStringList): String; OverLoad;
Function UpdateVarFromIni(Var v: Integer; VarName: String; ini: TStringList): String; OverLoad;
Function UpdateVarFromIni(Var v: String; VarName: String; ini: TStringList): String; OverLoad;

Implementation

Uses
  ads.FileNew,
  System.Diagnostics,
  System.IOUtils,
  System.DateUtils,
  Vcl.Dialogs,
  Vcl.Forms,
  WinApi.ShlObj,
  WinApi.Windows;

Var
  dtWas: TDateTime=0.0;

Const
  UnitName = 'ads.Globals';

Function StrToFile(s: String; FileName: String): Boolean;
Var
  lst: TStringList;
Begin
  Result := False;
  If FileExists(FileName) Then
  Begin
    DeleteFile(PWideChar(FileName));
    If FileExists(FileName) Then Exit;
  End;
  lst := TStringList.Create();
  Try
    lst.SetText(PWideChar(s));
    lst.SaveToFile(FileName);
    Result := FileExists(FileName);
  Finally
    FreeAndNil(lst);
  End;
End;

Function PathOfSpecialFolder(Folder: Integer): String;
Var
  FilePath: Array [0 .. MAX_PATH] Of char;
Begin
  SHGetFolderPath(0, Folder, 0, 0, FilePath);
  Result := FilePath;
End;
{ (* }
{$WARNINGS OFF}

Function PathOfAppDataCommon(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(35));
End;

Function PathOfAppDataLocal(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(28));
End;

Function PathOfHistory(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(34));
End;

Function PathOfInternetCache(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(32));
End;

Function PathOfInternetCookies(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(33));
End;

Function PathOfMyDocuments(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(5));
End;

Function PathOfMyMusic(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(CSIDL_MYMUSIC));
End;

Function PathOfMyPictures(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(39));
End;

Function PathOfProgramFiles(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(38));
End;

Function PathOfProgramFilesCommon(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(43));
End;

Function PathOfSystem32(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(37));
End;

Function PathOfWindows(): String;
Begin
  Result := System.SysUtils.IncludeTrailingBackslash(PathOfSpecialFolder(36));
End;
{$WARNINGS ON}
{ *) }

Function UpdateProjDirVarFromIni(Var v: String; VarName: String; ini: TStringList; MustBeSubDir: Boolean): String;
Var
  sgTemp: String;
Begin
  Result  := '';
  VarName := Trim(VarName);
  If VarName = '' Then Exit;
  If ini = Nil Then Exit;
  If Trim(v) = '' Then Exit;
  If ini.Values[VarName] = '' Then
  Begin
    // the value of v remains the same
  End
  Else
  Begin
    If MustBeSubDir Then
    Begin
      // the value of v remains the same
    End
    Else
    Begin
      v := ini.Values[VarName];
    End;
  End;
  sgTemp              := Trim(v);
  ini.Values[VarName] := sgTemp;
  If sgTemp = '' Then
  Begin
    // Empty values are not stored in the ini normally.
    // However, I want the variable name in the ini so that
    // a reader of the ini can see what varibles are controllable.
    ini.Add(VarName + '=');
    ini.Sort();
  End;
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateVarFromIni(Var v: String; VarName: String; ini: TStringList): String; Overload;
Var
  sgTemp: String;
Begin
  Result  := '';
  VarName := Trim(VarName);
  If VarName = '' Then Exit;
  If ini = Nil Then Exit;
  If ini.Values[VarName] <> '' Then v := ini.Values[VarName];
  sgTemp                              := Trim(v);
  ini.Values[VarName]                 := sgTemp;
  If sgTemp = '' Then
  Begin
    // Empty values are not stored in the ini normally.
    // However, I want the variable name in the ini so that
    // a reader of the ini can see what varibles are controllable.
    ini.Add(VarName + '=');
    ini.Sort();
  End;
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateVarFromIni(v: TCustomEdit; ini: TStringList): String; OverLoad;
Var
  sgTemp: String;
  VarName: String;
Begin
  Result  := '';
  if v=nil then Exit;
  VarName := v.Name+'.Text';
  If VarName = '' Then Exit;
  If ini = Nil Then Exit;
  If ini.Values[VarName] <> '' Then v.text := ini.Values[VarName];
  sgTemp                              := Trim(v.text);
  ini.Values[VarName]                 := sgTemp;
  If sgTemp = '' Then
  Begin
    // Empty values are not stored in the ini normally.
    // However, I want the variable name in the ini so that
    // a reader of the ini can see what varibles are controllable.
    ini.Add(VarName + '=');
    ini.Sort();
  End;
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateVarFromIni(Var v: Integer; VarName: String; ini: TStringList): String; Overload;
Var
  sgTemp: String;
Begin
  Result  := '';
  VarName := Trim(VarName);
  If VarName = '' Then Exit;
  If ini = Nil Then Exit;
  If ini.Values[VarName] <> '' Then v := StrToInt(ini.Values[VarName]);
  sgTemp                              := Trim(IntToStr(v));
  ini.Values[VarName]                 := sgTemp;
  If sgTemp = '' Then
  Begin
    // Empty values are not stored in the ini normally.
    // However, I want the variable name in the ini so that
    // a reader of the ini can see what varibles are controllable.
    ini.Add(VarName + '=');
    ini.Sort();
  End;
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateVarFromIni(Var v: Boolean; VarName: String; ini: TStringList): String; Overload;
Var
  sgTemp: String;
Begin
  Result  := '';
  VarName := Trim(VarName);
  If VarName = '' Then Exit;
  If ini = Nil Then Exit;
  If ini.Values[VarName] <> '' Then v := (ini.Values[VarName] = 'TRUE');
  If v Then sgTemp                    := 'TRUE'
  Else sgTemp                         := 'FALSE';
  ini.Values[VarName]                 := sgTemp;
  ini.Sort();
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateIniFromVar(Var v: String; VarName: String; ini: TStringList): String; Overload;
Begin
  ini.Values[VarName] := v;
  If Trim(v) = '' Then ini.Add(VarName + '=');
  ini.Sort();
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateIniFromVar(v: TCustomEdit; ini: TStringList): String; OverLoad;
Var
  VarName: String;
Begin
  Result:='';
  if v=nil then Exit;
  VarName:=v.name+'.Text';
  ini.Values[VarName] := v.Text;
  If Trim(v.text) = '' Then ini.Add(VarName + '=');
  ini.Sort();
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateIniFromVar(v: TRadioGroup; ini: TStringList): String; OverLoad;
Var
  VarName: String;
Begin
  Result:='';
  if v=nil then Exit;
  VarName:=v.name+'.ItemIndex';
  ini.Values[VarName] := IntToStr(v.ItemIndex);
  ini.Sort();
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateVarFromIni(v: TRadioGroup; ini: TStringList): String; OverLoad;
Var
  sgTemp: String;
  VarName: String;
Begin
  Result  := '';
  if v=nil then Exit;
  VarName := v.Name+'.ItemIndex';
  If VarName = '' Then Exit;
  If ini = Nil Then Exit;
  If ini.Values[VarName] <> '' Then
  Begin
    try
      v.ItemIndex := StrToInt(ini.Values[VarName]);
    except on E: Exception do
    end;
  End;
  sgTemp                              := Trim(ini.Values[VarName]);
  ini.Values[VarName]                 := sgTemp;
  If sgTemp = '' Then
  Begin
    // Empty values are not stored in the ini normally.
    // However, I want the variable name in the ini so that
    // a reader of the ini can see what varibles are controllable.
    ini.Add(VarName + '=');
    ini.Sort();
  End;
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateIniFromVar(Var v: Integer; VarName: String; ini: TStringList): String; Overload;
Begin
  ini.Values[VarName] := IntToStr(v);
  ini.Sort();
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function UpdateIniFromVar(Var v: Boolean; VarName: String; ini: TStringList): String; Overload;
Var
  sgBool: String;
Begin
  If v Then sgBool    := 'TRUE'
  Else sgBool         := 'FALSE';
  ini.Values[VarName] := sgBool;
  ini.Sort();
  ini.SaveToFile(FileIni);
  Result := ini.Values[VarName];
End;

Function FindUnusedUnits(CodeDir, DCUDir: String): Boolean;
Var
  i             : Integer;
  inIndex       : Integer;
  lstDCU        : TStringList;
  lstDFM        : TStringList;
  lstPas        : TStringList;
  ProcName      : String;
  sgCaptionWas  : String;
  sgDCUList     : String;
  sgDFMList     : String;
  sgMsg         : String;
  sgPasList     : String;
  UnUsedUnitsDir: String;
Begin
  Result       := False;
  sgCaptionWas := Application.MainForm.Caption;
  ProcName     := 'FindUnusedUnits';
  Try
    sgDCUList := '';
    sgPasList := '';
    sgDFMList := '';
    If Not System.SysUtils.DirectoryExists(DCUDir) Then
    Begin
      sgMsg := 'The DCUDir "' + DCUDir + '" does not exist. Aborting!' + '~' + 'Please create the DCUDir directory.' + '~' + 'Make sure that dcus are sent to this directory.' + '~' + 'Do a build All of the project before running this function.' + '~' + 'Result=' + BoolToStr(Result, True);
      If boLog Then LogMessage(UnitName, ProcName, sgMsg);
      sgMsg := StringReplace(sgMsg, '~', #13 + #10, [rfReplaceAll]);
      ShowMessage(sgMsg);
      Exit;
    End;
    If Not System.SysUtils.DirectoryExists(CodeDir) Then
    Begin
      sgMsg := 'The CodeDir "' + CodeDir + '" does not exist. Aborting!' + '~' + 'Please create the CoderDir directory.' + '~' + 'Make sure that the project source (*.pas,*.dfm) is in this directory.' + '~' + 'Do a build All of the project before running this function.' + '~' + 'Result=' + BoolToStr(Result, True);
      If boLog Then LogMessage(UnitName, ProcName, sgMsg);
      sgMsg := StringReplace(sgMsg, '~', #13 + #10, [rfReplaceAll]);
      ShowMessage(sgMsg);
      Exit;
    End;

    sgDCUList := FilesInDir(DCUDir, '*.dcu');
    If Trim(sgDCUList) = '' Then
    Begin
      sgMsg := 'No *.dcu files were found. Aborting!' + '~' + 'Result=' + BoolToStr(Result, True);
      If boLog Then LogMessage(UnitName, ProcName, sgMsg);
      sgMsg := StringReplace(sgMsg, '~', #13 + #10, [rfReplaceAll]);
      ShowMessage(sgMsg);
      Exit;
    End;
    sgPasList := FilesInDir(CodeDir, '*.pas');
    If Trim(sgPasList) = '' Then
    Begin
      sgMsg := 'No *.pas files were found. Aborting!' + '~' + 'Result=' + BoolToStr(Result, True);
      If boLog Then LogMessage(UnitName, ProcName, sgMsg);
      sgMsg := StringReplace(sgMsg, '~', #13 + #10, [rfReplaceAll]);
      ShowMessage(sgMsg);
      Exit;
    End;
{$WARNINGS OFF}
    CodeDir        := System.SysUtils.IncludeTrailingBackslash(CodeDir);
    UnUsedUnitsDir := CodeDir + 'UnUsedUnits\';
    UnUsedUnitsDir := System.SysUtils.IncludeTrailingBackslash(UnUsedUnitsDir);
    If Not System.SysUtils.DirectoryExists(UnUsedUnitsDir) Then System.SysUtils.ForceDirectories(UnUsedUnitsDir);
    DCUDir    := System.SysUtils.IncludeTrailingBackslash(DCUDir);
    sgDFMList := FilesInDir(CodeDir, '*.dfm');
{$WARNINGS On}
    lstDCU := TStringList.Create();
    lstPas := TStringList.Create();
    lstDFM := TStringList.Create();
    Try
      lstDCU.SetText(PWideChar(sgDCUList));
      lstPas.SetText(PWideChar(sgPasList));
      lstDFM.SetText(PWideChar(sgDFMList));
      lstDCU.Sort();
      lstPas.Sort();
      lstDFM.Sort();
      For i := 0 To lstDCU.Count - 1 Do lstDCU[i] := System.IOUtils.TPath.GetFileNameWithoutExtension(lstDCU[i]);
      For i := 0 To lstPas.Count - 1 Do lstPas[i] := System.IOUtils.TPath.GetFileNameWithoutExtension(lstPas[i]);
      For i := 0 To lstDFM.Count - 1 Do lstDFM[i] := System.IOUtils.TPath.GetFileNameWithoutExtension(lstDFM[i]);
      For i := 0 To lstDCU.Count - 1 Do
      Begin
        inIndex := lstPas.IndexOf(lstDCU[i]);
        If inIndex <> -1 Then
        Begin
          If inIndex < 0 Then Continue;
          If inIndex > (lstPas.Count - 1) Then Continue;
          lstPas.Delete(inIndex);
          inIndex := lstDFM.IndexOf(lstDCU[i]);
          If inIndex < 0 Then Continue;
          If inIndex > (lstDFM.Count - 1) Then Continue;
          If inIndex <> -1 Then lstDFM.Delete(inIndex);
        End;
      End;
      For i := 0 To lstPas.Count - 1 Do MoveFile(PWideChar(CodeDir + lstPas[i] + '.pas'), PWideChar(UnUsedUnitsDir + lstPas[i] + '.pas'));
      For i := 0 To lstDFM.Count - 1 Do MoveFile(PWideChar(CodeDir + lstPas[i] + '.dfm'), PWideChar(UnUsedUnitsDir + lstPas[i] + '.dfm'));

      Result := True;
      sgMsg  := IntToStr(lstPas.Count) + ' *.pas files were moved to "' + UnUsedUnitsDir + '".' + '~' + IntToStr(lstDFM.Count) + ' *.dfm files were moved to "' + UnUsedUnitsDir + '".' + '~' + 'Result=' + BoolToStr(Result, True);
      If boLog Then LogMessage(UnitName, ProcName, sgMsg);
      sgMsg := StringReplace(sgMsg, '~', #13 + #10, [rfReplaceAll]);
      ShowMessage(sgMsg);
    Finally
      FreeAndNil(lstDCU);
      FreeAndNil(lstPas);
      FreeAndNil(lstDFM);
    End;
  Finally
    Application.MainForm.Caption := sgCaptionWas;
  End;
End;

Function LogException(UnitName, ProcName, sgMessage: String): Boolean;
Var
  ts  : Int64;
  sgTs: String;
Begin
  ts        := TStopWatch.GetTimeStamp;
  sgTs      := IntToStr(ts);
  sgTs      := Copy(sgTs, 6, length(sgTs) - 6 + 1);
  sgMessage := StringReplace(sgMessage, #13, '', [rfReplaceAll]);
  sgMessage := StringReplace(sgMessage, #10, '', [rfReplaceAll]);
  Log.Add(FormatDateTime('yyyymmddhhnnss', now()) + sgTs + ' ' + UnitName + '.' + ProcName + ' error: ' + sgMessage);
  Exceptions := Exceptions + FormatDateTime('yyyymmddhhnnss', now()) + sgTs + ' ' + UnitName + '.' + ProcName + ' error: ' + sgMessage + #13 + #10;
  Result     := True;
End;

Function LogMessage(UnitName, ProcName, sgMessage: String): Boolean;
Var
  ts  : Int64;
  sgTs: String;
  dtIs: TDateTime;
  inMinutes: Int64;
Begin
  dtIs      :=now();
  ts        := TStopWatch.GetTimeStamp;
  sgTs      := IntToStr(ts);
  sgTs      := Copy(sgTs, 6, length(sgTs) - 6 + 1);
  sgMessage := StringReplace(sgMessage, #13, '', [rfReplaceAll]);
  sgMessage := StringReplace(sgMessage, #10, '', [rfReplaceAll]);
  Log.Add(FormatDateTime('yyyymmddhhnnss', dtIs) + sgTs + ' ' + UnitName + '.' + ProcName + ' message: ' + sgMessage);
  inMinutes:=MinutesBetween(dtIs,dtWas);
  Result := True;
  If inMinutes<4 Then Exit;
  dtWas:=dtIs;
  Log.Sort;
  Log.SaveToFile(ExePath + 'log.txt');
End;

Function Sort(s: String): String;
Var
  lst: TStringList;
Begin
  Result := s;
  If Trim(s) = '' Then Exit;
  lst := TStringList.Create();
  Try
    lst.SetText(PWideChar(s));
    lst.Sort;
    Result := lst.Text;
  Finally
    FreeAndNil(lst);
  End;
End;

Function SortDesc(s: String): String;
Var
  lst: TStringList;
  i  : Integer;
Begin
  Result := s;
  If Trim(s) = '' Then Exit;
  lst := TStringList.Create();
  Try
    lst.SetText(PWideChar(s));
    lst.Sort;
    Result := '';
    For i  := (lst.Count - 1) Downto 0 Do Result := Result + lst[i] + #13 + #10;
  Finally
    FreeAndNil(lst);
  End;
End;

Function SortNoDups(s: String): String;
Var
  lst: TStringList;
Begin
  Result := s;
  If Trim(s) = '' Then Exit;
  lst := TStringList.Create();
  Try
    lst.Duplicates := dupIgnore;
    lst.Sorted     := True;
    lst.SetText(PWideChar(s));
    Result := lst.Text;
  Finally
    FreeAndNil(lst);
  End;
End;

Initialization

{ (* }
IniData := TStringList.Create();
Log     := TStringList.Create();
If FileExists(ExePath + 'log.txt') Then DeleteFile(PWideChar(ExePath + 'log.txt'));
If FileExists(ExePath + 'Exceptions.txt') Then DeleteFile(PWideChar(ExePath + 'Exceptions.txt'));
FileLast              := '';
// Start Directory Modifications
DirLast               := '';
DirAppDataCommon      := PathOfAppDataCommon();
DirAppDataLocal       := PathOfAppDataLocal();
DirHistory            := PathOfHistory();
DirInternetCache      := PathOfInternetCache();
DirInternetCookies    := PathOfInternetCookies();
DirMyDocuments        := PathOfMyDocuments();
DirMyMusic            := PathOfMyMusic();
DirMyPictures         := PathOfMyPictures();
DirProgramFiles       := PathOfProgramFiles();
DirProgramFilesCommon := PathOfProgramFilesCommon();
DirSystem32           := PathOfSystem32();
DirWindows            := PathOfWindows();
ExeName               := ExtractFileName(ParamStr(0));
ExeName               := LowerCase(ExeName);
ExeName               := UpperCase(Copy(ExeName, 1, 1)) + Copy(ExeName, 2, length(ExeName) - 5);
ExePath               := ExtractFilePath(ParamStr(0));
DirPersist            := DirAppDataLocal + ExeName + '\';
DirPersist            := ExePath;
If Not DirectoryExists(DirPersist) Then ForceDirectories(DirPersist);
FileIni := DirPersist + ExeName + '.ini';

DirCommonFiles                                                                := DirAppDataCommon;
If DirCommonFiles = '' Then DirCommonFiles                                    := 'C:\Program Files\Common Files\';
If Copy(DirCommonFiles, length(DirCommonFiles), 1) <> '\' Then DirCommonFiles := DirCommonFiles + '\';
DirBackup                                                                     := DirPersist + 'Backup\';
DirBin                                                                        := DirPersist + 'Bin\';
DirDB                                                                         := DirPersist + 'data\';
DirDest                                                                       := DirPersist + 'Dest\';
DirHelp                                                                       := DirPersist + 'Help\';
DirImages                                                                     := DirPersist + 'images\';
DirProgFiles                                                                  := DirProgramFiles;
If DirProgFiles = '' Then DirProgFiles                                        := 'C:\Program Files\';
If Copy(DirProgFiles, length(DirProgFiles), 1) <> '\' Then DirProgFiles       := DirProgFiles + '\';
DirReports                                                                    := DirPersist + 'Reports\';
DirResources                                                                  := DirPersist + 'Resources\';
DirResUtilities                                                               := DirResources+'Utilities\';
DirSearches                                                                   := DirPersist + 'Searches\';
DirSource                                                                     := ExePath + 'Source\';
DirCode                                                                       := DirSource + 'Code\';
DirSQL                                                                        := ExePath + 'SQL\';
DirTestData                                                                   := ExePath + 'TestData\';
DirToolbar                                                                    := 'c:\Toolbar\';
DirWorking                                                                    := DirPersist + 'Working\';
DirXMLDocs                                                                    := ExePath + 'XMLDocs\';
DirDFMInfo                                                                    := DirResources + 'DFMInfo\';
DirDFMInfoCOMERCIAL                                                           := DirDFMInfo + 'COMERCIAL\';
DirDFMInfoCONTA                                                               := DirDFMInfo + 'CONTA\';
DirDFMInfoPOSVENTA                                                            := DirDFMInfo + 'POSVENTA\';
DirDFMInfoTEST                                                                := DirDFMInfo + 'TEST\';

// End Directory Modifications
// Start Directory Creation Booleans
{ example set boDirDB:=True to create DirDB directory }
boDirCode:=True;
boDirImages:=True;
// boDirSQL:=True;
// boDirTestData:=True;
// boDirToolbar:=True;
// boDirXMLDocs:=True;
// boDirXMLDocs:=True;
//boDirDB           := True;
//boDirBin            := True;
//boDirHelp         := True;
boDirReports      := True;
//boDirResources    := True;
//boDirResUtilities := True;
//boDirSearches     := True;
boDirSource       := True;
//boDirSQL          := True;
//boDirTestData     := True;
// Start Directory Creation Booleans

If boDirBackup           Then If Not DirectoryExists(DirBackup            ) Then ForceDirectories(DirBackup          );//
If boDirDB               Then If Not DirectoryExists(DirDB                ) Then ForceDirectories(DirDB              );//
If boDirBin              Then If Not DirectoryExists(DirBin               ) Then ForceDirectories(DirBin             );//
If boDirCode             Then If Not DirectoryExists(DirCode              ) Then ForceDirectories(DirCode            );//
If boDirDest             Then If Not DirectoryExists(DirDest              ) Then ForceDirectories(DirDest            );//
If boDirDFMInfo          Then If Not DirectoryExists(DirDFMInfo           ) Then ForceDirectories(DirDFMInfo         );//
If boDirDFMInfoCOMERCIAL Then If Not DirectoryExists(DirDFMInfoCOMERCIAL  ) Then ForceDirectories(DirDFMInfoCOMERCIAL);//
If boDirDFMInfoCONTA     Then If Not DirectoryExists(DirDFMInfoCONTA      ) Then ForceDirectories(DirDFMInfoCONTA    );//
If boDirDFMInfoPOSVENTA  Then If Not DirectoryExists(DirDFMInfoPOSVENTA   ) Then ForceDirectories(DirDFMInfoPOSVENTA );//
If boDirDFMInfoTEST      Then If Not DirectoryExists(DirDFMInfoTEST       ) Then ForceDirectories(DirDFMInfoTEST     );//
If boDirHelp             Then If Not DirectoryExists(DirHelp              ) Then ForceDirectories(DirHelp            );//
If boDirImages           Then If Not DirectoryExists(DirImages            ) Then ForceDirectories(DirImages          );//
If boDirPersist          Then If Not DirectoryExists(DirPersist           ) Then ForceDirectories(DirPersist         );//
If boDirReports          Then If Not DirectoryExists(DirReports           ) Then ForceDirectories(DirReports         );//
If boDirResources        Then If Not DirectoryExists(DirResources         ) Then ForceDirectories(DirResources       );//
If boDirResUtilities     Then If Not DirectoryExists(DirResUtilities      ) Then ForceDirectories(DirResUtilities    );//
If boDirSearches         Then If Not DirectoryExists(DirSearches          ) Then ForceDirectories(DirSearches        );//
If boDirSource           Then If Not DirectoryExists(DirSource            ) Then ForceDirectories(DirSource          );//
If boDirSQL              Then If Not DirectoryExists(DirSQL               ) Then ForceDirectories(DirSQL             );//
If boDirTestData         Then If Not DirectoryExists(DirTestData          ) Then ForceDirectories(DirTestData        );//
If boDirToolbar          Then If Not DirectoryExists(DirToolbar           ) Then ForceDirectories(DirToolbar         );//
If boDirWorking          Then If Not DirectoryExists(DirWorking           ) Then ForceDirectories(DirWorking         );//
If boDirXMLDocs          Then If Not DirectoryExists(DirXMLDocs           ) Then ForceDirectories(DirXMLDocs         );//

If Not FileExists(FileIni) Then IniData.SaveToFile(FileIni);
IniData.LoadFromFile(FileIni);
// Update From Ini - not project directories
UpdateVarFromIni(boActivateProfiler, 'boActivateProfiler', IniData);
UpdateVarFromIni(boAllProjDirRSubDir, 'boAllProjDirRSubDir', IniData);
UpdateVarFromIni(boDebug, 'boDebug', IniData);
UpdateVarFromIni(boDirBackup, 'boDirBackup', IniData);
UpdateVarFromIni(boDirDB, 'boDirDB', IniData);
UpdateVarFromIni(boDirDB, 'boDirBin', IniData);
UpdateVarFromIni(boDirDest, 'boDirDest', IniData);
UpdateVarFromIni(boDirHelp, 'boDirHelp', IniData);
UpdateVarFromIni(boDirImages, 'boDirImages', IniData);
UpdateVarFromIni(boDirPersist, 'boDirPersist', IniData);
UpdateVarFromIni(boDirReports, 'boDirReports', IniData);
UpdateVarFromIni(boDirResources, 'boDirResources', IniData);
UpdateVarFromIni(boDirResUtilities     ,'boDirResUtilities'     ,IniData);
UpdateVarFromIni(boDirSearches, 'boDirSearches', IniData);
UpdateVarFromIni(boDirSource, 'boDirSource', IniData);
UpdateVarFromIni(boDirSQL, 'boDirSQL', IniData);
UpdateVarFromIni(boDirTestData, 'boDirTestData', IniData);
UpdateVarFromIni(boDirToolbar, 'boDirToolbar', IniData);
UpdateVarFromIni(boDirWorking, 'boDirWorking', IniData);
UpdateVarFromIni(boDirXMLDocs, 'boDirXMLDocs', IniData);
UpdateVarFromIni(boLoadTestData, 'boLoadTestData', IniData);
UpdateVarFromIni(boLog, 'boLog', IniData);
UpdateVarFromIni(boPersistDFMInfoToDB, 'boPersistDFMInfoToDB', IniData);
UpdateVarFromIni(boPersistDFMInfoToFile, 'boPersistDFMInfoToFile', IniData);
UpdateVarFromIni(boRunDFMInfoTests, 'boRunDFMInfoTests', IniData);
UpdateVarFromIni(boUseAnlyzdDFMInfoData, 'boUseAnlyzdDFMInfoData', IniData);
UpdateVarFromIni(DirAppDataCommon, 'DirAppDataCommon', IniData);
UpdateVarFromIni(DirAppDataLocal, 'DirAppDataLocal', IniData);
UpdateVarFromIni(DirCommonFiles, 'DirCommonFiles', IniData);
UpdateVarFromIni(DirInternetCache, 'DirInternetCache', IniData);
UpdateVarFromIni(DirInternetCookies, 'DirInternetCookies', IniData);
UpdateVarFromIni(DirMyDocuments, 'DirMyDocuments', IniData);
UpdateVarFromIni(DirMyPictures, 'DirMyPictures', IniData);
UpdateVarFromIni(DirPersist, 'DirPersist', IniData);
UpdateVarFromIni(DirProgFiles, 'DirProgFiles', IniData);
UpdateVarFromIni(DirProgramFiles, 'DirProgramFiles', IniData);
UpdateVarFromIni(DirProgramFilesCommon, 'DirProgramFilesCommon', IniData);
UpdateVarFromIni(DirSearches, 'DirSearches', IniData);
UpdateVarFromIni(DirSystem32, 'DirSystem32', IniData);
UpdateVarFromIni(DirWindows, 'DirWindows', IniData);
UpdateVarFromIni(FileLast, 'FileLast', IniData);
UpdateVarFromIni(inTestDataFilterCount, 'inTestDataFilterCount', IniData);

// Update From Ini - project directories
UpdateProjDirVarFromIni(DirDB, 'DirDB', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirDB, 'DirBin', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirDest, 'DirDest', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirHistory, 'DirHistory', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirHelp, 'DirHelp', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirImages, 'DirImages', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirLast, 'DirLast', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirReports, 'DirReports', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirResources, 'DirResources', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirResUtilities,'DirResUtilities'       ,IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirSearches, 'DirSearches', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirSource, 'DirSource', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirSQL, 'DirSQL', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirTestData, 'DirTestData', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirTestData, 'DirToolbar', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirWorking, 'DirWorking', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(DirXMLDocs, 'DirXMLDocs', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(FileNameDB, 'FileNameDB', IniData, boAllProjDirRSubDir);
UpdateProjDirVarFromIni(FileSQLiteStudio, 'FileSQLiteStudio', IniData, boAllProjDirRSubDir);

// Update Ini: These are set not read
UpdateIniFromVar(ExeName, 'ExeName', IniData);
UpdateIniFromVar(ExePath, 'ExePath', IniData);
UpdateIniFromVar(FileIni, 'FileIni', IniData);
UpdateIniFromVar(DirAppDataCommon, '//DirAppDataCommon', IniData);
UpdateIniFromVar(DirAppDataLocal, '//DirAppDataLocal', IniData);
UpdateIniFromVar(DirHistory, '//DirHistory', IniData);
UpdateIniFromVar(DirInternetCache, '//DirInternetCache', IniData);
UpdateIniFromVar(DirInternetCookies, '//DirInternetCookies', IniData);
UpdateIniFromVar(DirMyDocuments, '//DirMyDocuments', IniData);
UpdateIniFromVar(DirMyPictures, '//DirMyPictures', IniData);
UpdateIniFromVar(DirProgramFiles, '//DirProgramFiles', IniData);
UpdateIniFromVar(DirProgramFilesCommon, '//DirProgramFilesCommon', IniData);
UpdateIniFromVar(DirSystem32, '//DirSystem32', IniData);
UpdateIniFromVar(DirWindows, '//DirWindows', IniData);

// Update Ini:
UpdateIniFromVar(boLoadTestData, 'boLoadTestData', IniData);
UpdateIniFromVar(boLog, 'boLog', IniData);
UpdateIniFromVar(inTestDataFilterCount, 'inTestDataFilterCount', IniData);
{ *) }
IniData.Sort();
IniData.SaveToFile(FileIni);

Finalization

IniData.Sort;
IniData.SaveToFile(FileIni);
IniData.Free;
If Exceptions <> '' Then StrToFile(Exceptions, ExePath + 'Exceptions.txt');
If Log.Text <> '' Then
Begin
  Log.Sort;
  Log.SaveToFile(ExePath + 'log.txt');
End;

End.
