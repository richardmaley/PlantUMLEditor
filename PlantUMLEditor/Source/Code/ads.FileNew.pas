Unit ads.FileNew;

{ Copyright(c)2023 Advanced Delphi Systems

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
  System.Classes;

Function DelTree(DirectoryName: String): Boolean;
Function EmptyDirectory(Directory: String): Boolean;
Function ExecuteKnownFileType(Handle: THandle; FileName: String): Boolean;
Function ExecuteNewProcess(FileName: String;Visibility: integer): integer;
Function ExecuteProcessAndWait(FileName: String;Visibility: integer): integer;
Function File_DirOperations_Detail(Action: String; RenameOnCollision, NoConfirmation, Silent, ShowProgress: Boolean; FromDir, ToDir: String): Boolean;
Function FileNextNumberName(Directory, Mask: String): String;
Function FileReNameNDate(FileName: String; FileDateNew: TDateTime; ChangeDate, ChangeName: Boolean): Boolean;
Function FileReNameToDate(FileName: String): Boolean;
Function FilesInDir(Dir, Mask: String): String;
Function FilesInDirDetail(FileList: TStrings; Directory, Mask: String): Boolean; Overload;
Function FilesInDirDetail(FileList: TStrings; Directory, Mask: String; Intersection, IsReadOnly, IsHidden, IsSystem, IsVolumeID, IsDirectory, IsArchive, IsNormal, InclDotFiles: Boolean): Boolean; Overload;
Function FileSize(Const aFilename: String): Int64;
Function FindDuplicateFilesinDir(Dir, Mask: String): String;
Function FindFilesInDirectories(Mask, Path: String): String; Overload;
Function FindFilesInDirectories(Mask, Path: String; IncludeSubDirs: Boolean): String; Overload;
Function FindFilesInDirectory(Mask, Path: String): String;
Function FindFilesInDirectoryWithCompoundMask(Dir, Mask: String): String; Overload;
Function GetDirectories(Dir, Mask: String): String; Overload;
Function GetDirectories(Dir, Mask: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetDirectories(Dir, Mask: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetDirectories(Dir: String): String; Overload;
Function GetDirectories(Dir: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetDirectories(Dir: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetSubDirectories(Dir, Mask: String): String; Overload;
Function GetSubDirectories(Dir, Mask: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetSubDirectories(Dir, Mask: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetSubDirectories(Dir: String): String; Overload;
Function GetSubDirectories(Dir: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function GetSubDirectories(Dir: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Function NumbersOnlyAbsolute(InputString: String): String; Overload;
Function NumbersOnlyAbsolute(InputString: String; KeepLeadingZeros: Boolean): String; OverLoad;
Function PathOfAppDataLocal(): String;
Function PathOfSpecialFolder(Folder: Integer): String;
Function SelectDirectory(InitialDir: String): String;
Function SetFileDate(Const FileName: String;Const FileDate: TDateTime): Boolean;
Function SetFileDates(Const FileName: String;Const CreationDate: TDateTime;Const AccessedDate: TDateTime;Const ModifiedDate: TDateTime): Boolean;
Function StringPad(InputStr, FillChar: String; StrLen: Integer; StrJustify: Boolean): String;
Procedure KeyPressOnlyNumbers(Var Key: Char);
Procedure NumberDirFiles(Directory: String; StartNumber: Integer);
Function FileDate(FileString: String): TDateTime;
Function DeleteFilesInDirectories(mask, Path: String): Boolean;

Implementation

Uses
  Vcl.FileCtrl,
  System.IOUtils,
  System.Types,
  System.SysUtils,
  Winapi.ShellAPI,
  Winapi.ShlObj,
  Winapi.Windows,
  Winapi.ActiveX,
  Vcl.Dialogs,
  Vcl.Forms;

Function DelTree(DirectoryName: String): Boolean;
Begin
  Result := File_DirOperations_Detail('DELETE', // Action            : String;  //COPY, DELETE, MOVE, RENAME
    False,                                      // RenameOnCollision : Boolean; //Renames if directory exists
    True,                                       // NoConfirmation    : Boolean; //Responds "Yes to All" to any dialogs
    True,                                       // Silent            : Boolean; //No progress dialog is shown
    False,                                      // ShowProgress      : Boolean; //displays progress dialog but no file names
    DirectoryName,                              // FromDir : String;  //From directory
    ''                                          // ToDir   : String   //To directory
    );
End;

Function EmptyDirectory(Directory: String): Boolean;
Var
  T: TStringList;
  i: Integer;
Begin
  T := TStringList.Create();
  Try
    Result    := False;
    Directory := IncludeTrailingPathDelimiter(Directory);
    If Not DirectoryExists(Directory) Then Exit;
    FilesInDirDetail(T, Directory, '*.*');
    Result := True;
    For i  := 0 To T.Count - 1 Do
    Begin
      Try
        If FileExists(Directory + T[i]) Then DeleteFile(PWideChar(Directory + T[i]));
      Except
        Result := False;
      End;
    End;
  Finally
    T.Free;
  End;
End;

Function ExecuteKnownFileType(Handle: THandle; FileName: String): Boolean;
{ !~ ExecuteKnownFileType
  Loads a known file type using the appropriate
  executable, e.g., WinWord for *.Doc, Paradox for *.db. }
Var
  PFileName: Array [0 .. 128] Of Char;
  PFilePath: Array [0 .. 128] Of Char;
  FilePath : String;
Begin
  Result := False;
  Try
    If Not FileExists(FileName) Then Exit;
    FilePath := ExtractFilePath(FileName);
    StrPCopy(PFileName, FileName);
    StrPCopy(PFilePath, FilePath);
    ShellExecute(Handle, Nil, PFileName, Nil, PFilePath, SW_SHOWNORMAL);
    Result := True;
  Except
  End;
End;

Function File_DirOperations_Detail(Action: String; // COPY, DELETE, MOVE, RENAME
  RenameOnCollision: Boolean;                      // Renames if directory exists
  NoConfirmation: Boolean;                         // Responds "Yes to All" to any dialogs
  Silent: Boolean;                                 // No progress dialog is shown
  ShowProgress: Boolean;                           // displays progress dialog but no file names
  FromDir: String;                                 // From directory
  ToDir: String                                    // To directory
  ): Boolean;
Var
  SHFileOpStruct: TSHFileOpStruct;
  FromBuf, ToBuf: Array [0 .. 255] Of Char;
Begin
  Try
    If Not System.SysUtils.DirectoryExists(FromDir) Then
    Begin
      Result := False;
      Exit;
    End;
    FillChar(SHFileOpStruct, Sizeof(SHFileOpStruct), 0);
    FillChar(FromBuf, Sizeof(FromBuf), 0);
    FillChar(ToBuf, Sizeof(ToBuf), 0);
    StrPCopy(FromBuf, FromDir);
    StrPCopy(ToBuf, ToDir);
    With SHFileOpStruct Do
    Begin
      Wnd                                        := 0;
      If UpperCase(Action) = 'COPY' Then wFunc   := FO_COPY;
      If UpperCase(Action) = 'DELETE' Then wFunc := FO_DELETE;
      If UpperCase(Action) = 'MOVE' Then wFunc   := FO_MOVE;
      If UpperCase(Action) = 'RENAME' Then wFunc := FO_RENAME;
{$WARNINGS OFF}
      pFrom := @FromBuf;
      pTo   := @ToBuf;
{$WARNINGS ON}
      fFlags                           := FOF_ALLOWUNDO;
      If RenameOnCollision Then fFlags := fFlags Or FOF_RENAMEONCOLLISION;
      If NoConfirmation Then fFlags    := fFlags Or FOF_NOCONFIRMATION;
      If Silent Then fFlags            := fFlags Or FOF_SILENT;
      If ShowProgress Then fFlags      := fFlags Or FOF_SIMPLEPROGRESS;
    End;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  Except
    Result := False;
  End;
End;

Function FileNextNumberName(Directory, Mask: String): String;
Var
  StringList: TStringList;
  CurLast_I : Integer;
  i         : Integer;
Begin
  Result     := '';
  StringList := TStringList.Create();
  Try
    StringList.Clear;
    FilesInDirDetail(StringList, Directory, Mask);
    For i := (StringList.Count - 1) Downto 0 Do
    Begin
      StringList[i] := NumbersOnlyAbsolute(StringList[i]);
      If StringList[i] = '' Then
      Begin
        StringList.Delete(i);
        Continue;
      End;
      StringList[i] := IntToStr(StrToInt(StringList[i]));
      StringList[i] := StringPad(StringList[i], '0', 8, False);
    End;
    StringList.Sorted := True;
    Try
      If StringList.Count = 0 Then
      Begin
        CurLast_I := 0;
      End
      Else
      Begin
        CurLast_I := StrToInt(TPath.GetFileNameWithoutExtension(StringList[StringList.Count - 1]));
      End;
    Except
      CurLast_I := 0;
    End;
    Result := StringPad(IntToStr(CurLast_I + 1), '0', 8, False);
  Finally
    StringList.Free;
  End;
End;

Function FileReNameNDate(FileName: String; FileDateNew: TDateTime; ChangeDate, ChangeName: Boolean): Boolean;
Var
  FileDateOld: TDateTime;
  FileExt: String;
  FilePath: String;
Begin
  Result := False;
  Try
    If FileName = '' Then Exit;
    If Not FileExists(FileName) Then Exit;
    If Not (ChangeDate And ChangeName) Then Exit;
    FilePath := ExtractFilePath(Filename);
    FileExt := ExtractFileExt(Filename);
    FileDateOld := FileDate(FileName);
    If ChangeDate Then
    Begin
      If FileDateOld <> FileDateNew Then
      Begin
        SetFileDate(
          FileName, //Const FileName : String;
          FileDateNew //Const FileDate : TDateTime
          ); //): Boolean;
      End;
    End;
    If Not ChangeName Then
    Begin
      Result := True;
      Exit;
    End;
    Result := FileReNameToDate(FileName);
  Except
    Result := False;
  End;
End;

Function FileReNameToDate(FileName: String): Boolean;
Var
  FileBase: String;
  File_Date: TDateTime;
  FileExt: String;
  FileNameNew: String;
  FilePath: String;
  i: Integer;
  sgPad: String;
Begin
  Result := False;
  Try
    If FileName = '' Then Exit;
    If Not FileExists(FileName) Then Exit;
    FilePath := ExtractFilePath(Filename);
    FileExt := ExtractFileExt(Filename);
    File_Date := FileDate(FileName);
    FileBase := FormatDateTime('yyyymmdd', File_Date);
    If Not FileExists(FilePath + FileBase + '000000' + FileExt) Then
    Begin
      ReNameFile(FileName, FilePath + FileBase + '000000' + FileExt);
      Result := True;
      Exit;
    End;
    For i := 1 To 999999 Do
    Begin
      sgPad := '000000' + IntToStr(i);
      sgPad := Copy(sgPad, Length(sgPad) - 5, 6);
      FileNameNew := FilePath + FileBase + sgPad + FileExt;
      If FileExists(FileNameNew) Then Continue;
      ReNameFile(FileName, FileNameNew);
      Break;
    End;
    Result := True;
  Except
    Result := False;
  End;
End;

Function FilesInDir(Dir, Mask: String): String;
Begin
  Result := FindFilesInDirectories(Mask, Dir, False);
End;

Function FilesInDirDetail(FileList: TStrings; Directory: String; Mask: String; Intersection: Boolean; IsReadOnly: Boolean; IsHidden: Boolean; IsSystem: Boolean; IsVolumeID: Boolean; IsDirectory: Boolean; IsArchive: Boolean; IsNormal: Boolean; InclDotFiles: Boolean): Boolean;
Begin
  Result := FilesInDirDetail(FileList, Directory, Mask);
End;

Function FilesInDirDetail(FileList: TStrings; Directory: String; Mask: String): Boolean; Overload;
Begin
  Result    := False;
  Directory := Trim(Directory);
  If Not DirectoryExists(Directory) Then Exit;
  If Trim(Mask) = '' Then Mask := '*';
{$WARNINGS OFF}
  If FileList = Nil Then FileList := TStrings.Create();
{$WARNINGS ON}
  FileList.SetText(PWideChar(FindFilesInDirectories(Mask, Directory, False)));
  Result := True;
End;

Function FileSize(Const aFilename: String): Int64;
Var
  info: TWin32FileAttributeData;
Begin
  Result := -1;

  If Not GetFileAttributesEx(PWideChar(aFilename), GetFileExInfoStandard, @info) Then Exit;

  Result := Int64(info.nFileSizeLow) Or Int64(info.nFileSizeHigh Shl 32);
End;

Function FindDuplicateFilesinDir(Dir, Mask: String): String;
Var
  FileList  : String;
  lst       : TStringList;
  lstDups   : TStringList;
  i         : Integer;
  inIndex   : Integer;
  inSize    : Integer;
  sgSize    : String;
  sgFile    : String;
  sgSizePrev: String;
  sgFilePrev: String;
  inMaxLen  : Integer;
  sgDups    : String;
Begin
  Result := '';
  If Trim(Dir) = '' Then Exit;
  If Not System.SysUtils.DirectoryExists(Dir) Then Exit;
  // FileList:=FindFilesInDirectory('*.*',Dir);
  FileList := FindFilesInDirectoryWithCompoundMask(Dir, Mask);
  lst      := TStringList.Create();
  lstDups  := TStringList.Create();
  Try
    lst.SetText(PWideChar(FileList));
    inMaxLen := 5;
    For i    := 0 To lst.Count - 1 Do
    Begin
      inSize                                     := FileSize(lst[i]);
      inSize                                     := inSize Div 10;
      sgSize                                     := IntToStr(inSize);
      If Length(sgSize) > inMaxLen Then inMaxLen := Length(sgSize);
    End;
    For i := 0 To lst.Count - 1 Do
    Begin
      inSize := FileSize(lst[i]);
      inSize := inSize Div 10;
      sgSize := IntToStr(inSize);
      sgSize := StringPad(sgSize, '0', inMaxLen, False);
      lst[i] := sgSize + '|' + lst[i];
    End;
    lst.Sort();
    sgSizePrev := '';
    sgFilePrev := '';
    sgDups     := '';
    For i      := 0 To lst.Count - 1 Do
    Begin
      sgSize := Copy(lst[i], 1, inMaxLen);
      sgFile := Copy(lst[i], inMaxLen + 2, Length(lst[i]) - (inMaxLen + 2) + 1);
      If sgSize = sgSizePrev Then
      Begin
        inIndex := lstDups.IndexOf(sgFilePrev);
        If inIndex = -1 Then lstDups.Append(sgFilePrev);
        inIndex := lstDups.IndexOf(sgFile);
        If inIndex = -1 Then lstDups.Append(sgFile);
      End;
      sgSizePrev := sgSize;
      sgFilePrev := sgFile;
    End;
    Result := lstDups.Text;
  Finally
    FreeAndNil(lst);
    FreeAndNil(lstDups);
  End;
End;

Function FindFilesInDirectories(Mask, Path: String): String;
Begin
  Result := FindFilesInDirectories(Mask, Path, True);
End;

Function FindFilesInDirectories(Mask, Path: String; IncludeSubDirs: Boolean): String; Overload;
Var
  lst         : TStringList;
  MaskList    : TStringList;
  s           : String;
  SearchOption: TSearchOption;
  sgMask      : String;
  sgFileList: String;
  i: Integer;
Begin
  Result:='';
  If Trim(Mask)='' Then Exit;
  If Trim(Path)='' Then Exit;
  If Not DirectoryExists(Path) Then Exit;
  Mask:=StringReplace(Mask,';',#13+#10,[rfReplaceAll]);
  MaskList := TStringList.Create;
  lst := TStringList.Create;
  Try
    MaskList.Text:=Mask;
    For i:=0 To MaskList.count-1 Do
    Begin
      sgMask:=MaskList[i];
      If IncludeSubDirs Then
      Begin
        SearchOption := TSearchOption.soAllDirectories;
      End
      Else
      Begin
        SearchOption := TSearchOption.soTopDirectoryOnly;
      End;
      For s In TDirectory.GetFiles(Path, sgMask, SearchOption) Do lst.Add(s);
    End;
    lst.Sort;
    sgFileList:=lst.text;
    lst.clear;
    lst.Duplicates:=dupIgnore;
    lst.Sorted:=True;
    lst.text:=sgFileList;
    Result := lst.Text;
  Finally
    FreeAndNil(lst);
    FreeAndNil(MaskList);
  End;
End;

Function FindFilesInDirectory(Mask, Path: String): String;
Begin
  Result := FindFilesInDirectories(Mask, Path, False);
End;

Function FindFilesInDirectoryWithCompoundMask(Dir, Mask: String): String;
Var
  lst: TStringList;
  i  : Integer;
Begin
  Result := '';
  If Trim(Mask) = '' Then Exit;
  If Trim(Dir) = '' Then Exit;
  If Not System.SysUtils.DirectoryExists(Dir) Then Exit;
  lst := TStringList.Create();
  Try
    Mask := StringReplace(Mask, ';', #13 + #10, [rfReplaceAll]);
    lst.SetText(PWideChar(Mask));
    For i := 0 To lst.Count - 1 Do Result := Result + FindFilesInDirectory(lst[i], Dir);
  Finally
    FreeAndNil(lst);
  End;
End;

Function GetDirectories(Dir, Mask: String): String; Overload;
Var
  TopSubDirsOnly                : Boolean;
  boIncludeTrailingPathDelimiter: Boolean;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  TopSubDirsOnly                 := False;
  boIncludeTrailingPathDelimiter := True;
  If boIncludeTrailingPathDelimiter Then
  Begin
    Dir := IncludeTrailingPathDelimiter(Dir);
  End
  Else
  Begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
  End;
  Result := GetSubDirectories(Dir, Mask, TopSubDirsOnly, boIncludeTrailingPathDelimiter);
  Result := Result + #13 + #10 + Dir;
End;

Function GetDirectories(Dir, Mask: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Var
  TopSubDirsOnly: Boolean;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  TopSubDirsOnly := False;
  If boIncludeTrailingPathDelimiter Then
  Begin
    Dir := IncludeTrailingPathDelimiter(Dir);
  End
  Else
  Begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
  End;
  Result := GetSubDirectories(Dir, Mask, TopSubDirsOnly, boIncludeTrailingPathDelimiter);
  Result := Result + #13 + #10 + Dir;
End;

Function GetDirectories(Dir, Mask: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  If boIncludeTrailingPathDelimiter Then
  Begin
    Dir := IncludeTrailingPathDelimiter(Dir);
  End
  Else
  Begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
  End;
  Result := GetSubDirectories(Dir, Mask, TopSubDirsOnly, boIncludeTrailingPathDelimiter);
  Result := Result + #13 + #10 + Dir;
End;

Function GetDirectories(Dir: String): String;
Var
  Mask                          : String;
  TopSubDirsOnly                : Boolean;
  boIncludeTrailingPathDelimiter: Boolean;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  Mask                           := '*.*';
  TopSubDirsOnly                 := False;
  boIncludeTrailingPathDelimiter := True;
  If boIncludeTrailingPathDelimiter Then
  Begin
    Dir := IncludeTrailingPathDelimiter(Dir);
  End
  Else
  Begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
  End;
  Result := GetSubDirectories(Dir, Mask, TopSubDirsOnly, boIncludeTrailingPathDelimiter);
  Result := Result + #13 + #10 + Dir;
End;

Function GetDirectories(Dir: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Var
  Mask          : String;
  TopSubDirsOnly: Boolean;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  Mask           := '*.*';
  TopSubDirsOnly := False;
  If boIncludeTrailingPathDelimiter Then
  Begin
    Dir := IncludeTrailingPathDelimiter(Dir);
  End
  Else
  Begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
  End;
  Result := GetSubDirectories(Dir, Mask, TopSubDirsOnly, boIncludeTrailingPathDelimiter);
  Result := Result + #13 + #10 + Dir;
End;

Function GetDirectories(Dir: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Var
  Mask: String;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  Mask := '*.*';
  If boIncludeTrailingPathDelimiter Then
  Begin
    Dir := IncludeTrailingPathDelimiter(Dir);
  End
  Else
  Begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
  End;
  Result := GetSubDirectories(Dir, Mask, TopSubDirsOnly, boIncludeTrailingPathDelimiter);
  Result := Result + #13 + #10 + Dir;
End;

Function GetSubDirectories(Dir, Mask: String): String; Overload;
Begin
  Result := GetSubDirectories(Dir, Mask, False, True);
End;

Function GetSubDirectories(Dir, Mask: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Begin
  Result := GetSubDirectories(Dir, Mask, False, boIncludeTrailingPathDelimiter);
End;

Function GetSubDirectories(Dir, Mask: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Var
  a             : TStringDynArray;
  i             : Integer;
  lst           : TStringList;
  inSearchOption: Integer;
  s             : String;
Begin
  Result := '';
  Dir    := Trim(Dir);
  If Not DirectoryExists(Dir) Then Exit;
  Dir                                   := IncludeTrailingPathDelimiter(Dir);
  inSearchOption                        := 1;
  If Trim(Mask) = '' Then Mask          := '*.*';
  If TopSubDirsOnly Then inSearchOption := 0;
  lst                                   := TStringList.Create();
  Try
    lst.Duplicates := dupIgnore;
    lst.Sorted     := True;
    a              := TDirectory.GetDirectories(Dir, Mask, TSearchOption(inSearchOption));
    If Length(a) = 0 Then Exit;
    For i := Low(a) To High(a) Do
    Begin
      s := a[i];
      If boIncludeTrailingPathDelimiter Then
      Begin
        s := IncludeTrailingPathDelimiter(s);
      End
      Else
      Begin
        s := ExcludeTrailingPathDelimiter(s);
      End;
      lst.Add(s);
    End;
    lst.Add(Dir);
    lst.Sort();
    Result := lst.Text;
  Finally
    FreeAndNil(lst);
  End;
End;

Function GetSubDirectories(Dir: String): String;
Begin
  Result := GetSubDirectories(Dir, '*.*', False, True);
End;

Function GetSubDirectories(Dir: String; boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Begin
  Result := GetSubDirectories(Dir, '*.*', False, boIncludeTrailingPathDelimiter);
End;

Function GetSubDirectories(Dir: String; TopSubDirsOnly, boIncludeTrailingPathDelimiter: Boolean): String; Overload;
Begin
  Result := GetSubDirectories(Dir, '*.*', TopSubDirsOnly, boIncludeTrailingPathDelimiter);
End;

Function NumbersOnlyAbsolute(InputString: String): String; Overload;
Begin
  Result := NumbersOnlyAbsolute(InputString, False);
End;

Function NumbersOnlyAbsolute(InputString: String; KeepLeadingZeros: Boolean): String; Overload;
Var
  NewString: String;
  L        : Integer;
  i        : Integer;
  C        : Char;
Begin
  Result    := InputString;
  NewString := '';
  L         := Length(InputString);
  For i     := 1 To L Do
  Begin
    C := InputString[i];
    If Not((C = '+') Or (C = '-') Or (C = '.') Or (C = ',')) Then
    Begin
      KeyPressOnlyNumbers(C);
      If Not(C = #0) Then
      Begin
        If NewString = '0' Then
        Begin
          If Not KeepLeadingZeros Then NewString := '';
        End;
        NewString := NewString + C;
      End;
    End;
  End;
  Result := NewString;
End;

Function SelectDirectory(InitialDir: String): String;
Const
  SELDIRHELP = 1000;
Var
  Dir: String;
Begin
  Dir                                                                                                      := InitialDir;
  If Vcl.FileCtrl.SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt], SELDIRHELP) Then Result := Dir;
End;

Function SetFileDate(Const FileName: String;Const FileDate: TDateTime): Boolean;
Begin
  Result :=
    SetFileDates(
      FileName, //Const FileName : String;
      FileDate, //Const CreationDate : TDateTime;
      FileDate, //Const AccessedDate : TDateTime;
      FileDate //Const ModifiedDate : TDateTime
      ); //): Boolean;
End;

Function SetFileDates(Const FileName: String;Const CreationDate: TDateTime;Const AccessedDate: TDateTime;Const ModifiedDate: TDateTime): Boolean;
Var
  FileHandle: THandle;
  FileDateTime: TFileTime;
  TimeInt: Integer;
  TimeLocal: TFileTime;
Begin
  FileHandle := 0;
  Result := False;
  Try
    Try
      FileHandle := FileOpen(FileName, fmOpenWrite Or fmShareDenyNone);
      If FileHandle > 0 Then
      Begin
        TimeInt := DateTimeToFileDate(CreationDate);
        If DosDateTimeToFileTime(LongRec(TimeInt).Hi, LongRec(TimeInt).Lo, TimeLocal) Then
        Begin
          If Winapi.Windows.LocalFileTimeToFileTime(TimeLocal, FileDateTime) Then
          Begin
            SetFileTime(FileHandle, @FileDateTime, Nil, Nil);
            Result := True;
          End;
        End;
        TimeInt := DateTimeToFileDate(AccessedDate);
        If DosDateTimeToFileTime(LongRec(TimeInt).Hi, LongRec(TimeInt).Lo, TimeLocal) Then
        Begin
          If Winapi.Windows.LocalFileTimeToFileTime(TimeLocal, FileDateTime) Then
          Begin
            SetFileTime(FileHandle, Nil, @FileDateTime, Nil);
            Result := True;
          End;
        End;
        TimeInt := DateTimeToFileDate(ModifiedDate);
        If DosDateTimeToFileTime(LongRec(TimeInt).Hi, LongRec(TimeInt).Lo, TimeLocal) Then
        Begin
          If Winapi.Windows.LocalFileTimeToFileTime(TimeLocal, FileDateTime) Then
          Begin
            SetFileTime(FileHandle, Nil, Nil, @FileDateTime);
            Result := True;
          End;
        End;
      End;
    Except
      Result := False;
    End;
  Finally
    FileClose(FileHandle);
  End;
End;

Function StringPad(InputStr, FillChar: String; StrLen: Integer; StrJustify: Boolean): String;
{ !~ File_DirOperations_Detail
  This is the directory management engine that is used by a number of other
  file management functions.  This function can COPY, DELETE, MOVE, and RENAME
  directories. }
Var
  TempFill: String;
  Counter : Integer;
Begin
  If Not(Length(InputStr) = StrLen) Then
  Begin
    If Length(InputStr) > StrLen Then
    Begin
      InputStr := Copy(InputStr, 1, StrLen);
    End
    Else
    Begin
      TempFill    := '';
      For Counter := 1 To StrLen - Length(InputStr) Do
      Begin
        TempFill := TempFill + FillChar;
      End;
      If StrJustify Then
      Begin
        { Left Justified }
        InputStr := InputStr + TempFill;
      End
      Else
      Begin
        { Right Justified }
        InputStr := TempFill + InputStr;
      End;
    End;
  End;
  Result := InputStr;
End;

Procedure KeyPressOnlyNumbers(Var Key: Char);
Begin
  Case Key Of
    '0': Exit;
    '1': Exit;
    '2': Exit;
    '3': Exit;
    '4': Exit;
    '5': Exit;
    '6': Exit;
    '7': Exit;
    '8': Exit;
    '9': Exit;
    '-': Exit;
    '+': Exit;
    '.': Exit;
    #8: Exit; { Backspace }
  End;
  Key := #0; { Throw the key away }
End;

Procedure NumberDirFiles(
  Directory: String;
  StartNumber: Integer);
Var
  i: Integer;
  lstOriginal: TStringList;
  lstNewNames: TStringList;
  sgExt: String;
  sgZeros: String;
  inLen: Integer;
  sgFile: String;
  inCounter: Integer;
  inNum: Integer;
  destFile: String;
  TempFile: String;
  SrcFile: String;
  inCount: Integer;
  inMax: Integer;
  inIndex: Integer;
  inSigFigs: Integer;
Begin
  lstOriginal := TStringList.Create();
  lstNewNames := TStringList.Create();
  Try
    If Copy(Directory, Length(Directory), 1) <> '\' Then
      Directory := Directory + '\';
    //sgZeros   := '00000000';
    FilesInDirDetail(
      lstOriginal, //FileList    : TStrings;
      Directory, //Directory   : String;
      '*.*', //Mask        : String;
      False, //Intersection: Boolean;
      False, //IsReadOnly  : Boolean;
      False, //IsHidden    : Boolean;
      False, //IsSystem    : Boolean;
      False, //IsVolumeID  : Boolean;
      False, //IsDirectory : Boolean;
      False, //IsArchive   : Boolean;
      True, //IsNormal    : Boolean;
      False); //InclDotFiles: Boolean): Boolean;
    inSigFigs := Length(IntToStr(lstOriginal.Count + StartNumber - 1));
    sgZeros := '';
    For i := 1 To inSigFigs Do
      sgZeros := sgZeros + '0';
    lstNewNames.Clear;
    inNum := StartNumber;
    For inCounter := 0 To lstOriginal.Count - 1 Do
    Begin
      lstNewNames.Add('');
      sgFile := IntToStr(inNum);
      inLen := Length(sgFile);
      sgFile := Copy(sgZeros, 1, inSigFigs - inLen) + sgFile;
      sgExt := ExtractFileExt(lstOriginal[inCounter]);
      sgFile := sgFile + sgExt;
      lstNewNames[inCounter] := sgFile;
      inc(inNum);
    End;
    inMax := lstOriginal.Count - 1;
    For inCount := 0 To inMax Do
    Begin
      For inCounter := (lstOriginal.Count - 1) Downto 0 Do
      Begin
        destFile := Directory + lstNewNames[inCounter];
        SrcFile := Directory + lstOriginal[inCounter];
        If Not FileExists(DestFile) Then
        Begin
          ReNameFile(SrcFile, destFile);
          lstNewNames.Delete(inCounter);
          lstOriginal.Delete(inCounter);
          Continue;
        End;
      End;
      If lstOriginal.Count = 0 Then Break;
    End;
    For inCounter := (lstOriginal.Count - 1) Downto 0 Do
    Begin
      destFile := Directory + lstNewNames[inCounter];
      SrcFile := Directory + lstOriginal[inCounter];
      If UpperCase(DestFile) = UpperCase(SrcFile) Then
      Begin
        lstNewNames.Delete(inCounter);
        lstOriginal.Delete(inCounter);
        Continue;
      End;
      If Not FileExists(DestFile) Then
      Begin
        ReNameFile(SrcFile, destFile);
        lstNewNames.Delete(inCounter);
        lstOriginal.Delete(inCounter);
        Continue;
      End
      Else
      Begin
        TempFile := FormatDateTime('yyyymmddhhnnss', now());
        inIndex := lstOriginal.IndexOf(lstNewNames[inCounter]);
        If inIndex <> -1 Then
        Begin
          ReNameFile(
            Directory + lstOriginal[inIndex],
            Directory + TempFile);
          lstOriginal[inIndex] := TempFile;
          If Not FileExists(DestFile) Then
          Begin
            ReNameFile(SrcFile, destFile);
            lstNewNames.Delete(inCounter);
            lstOriginal.Delete(inCounter);
            Continue;
          End
        End;
      End;
    End;
    If lstOriginal.Count <> 0 Then
    Begin
      ShowMessage('Not all files were renumbered');
    End;
  Finally
    lstOriginal.Free;
    lstNewNames.Free;
  End;
End;

Function FileDate(FileString: String): TDateTime;
Begin
  Result := 0.00;
  Try
    Result := 0;
    Try
      If Not FileExists(FileString) Then Exit;
{$WARNINGS OFF}
      Result := FileDateToDateTime(FileAge(FileString));
{$WARNINGS ON}
    Except
      Result := 0;
    End;
  Except
  End;
End;

Function DeleteFilesInDirectories(mask, Path: String): Boolean;
Var
  lst: TStringList;
  Files: String;
  inCounter: Integer;
  boRetVal: Boolean;
Begin
  Result := True;
  lst := TStringList.Create();
  Try
    lst.Clear;
    Files := FindFilesInDirectories(mask, Path);
    If Files = '' Then Exit;
    //lst.SetText(PWideChar(Files));
    lst.SetText(PChar(Files));
    For inCounter := 0 To lst.Count - 1 Do
    Begin
      If FileExists(lst[inCounter]) Then
      Begin
        boRetVal := DeleteFile(PWideChar(lst[inCounter]));
        If Not boRetVal Then Result := False;
      End;
    End;
  Finally
    lst.Free;
  End;
End;

Function ExecuteProcessAndWait(FileName: String;Visibility: integer): integer;
Var
  zAppName: Array[0..512] Of char;
  zCurDir: Array[0..255] Of char;
  WorkDir: String;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
Begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  If Not CreateProcess(Nil,
    zAppName, { pointer to command line string }
    Nil, { pointer to process security attributes}
    Nil, { pointer to thread security attributes }
    false, { handle inheritance flag }
    CREATE_NEW_CONSOLE Or NORMAL_PRIORITY_CLASS,
    Nil, { pointer to new environment block }
    Nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo) Then
  Begin
    Result := 0;
  End
  Else
  Begin
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
  End;
End;

Function PathOfSpecialFolder(Folder: Integer): String;
Var
  ppidl: PItemIdList;
  shellMalloc: IMalloc;
Begin
  ppidl := Nil;
  Try
    If SHGetMalloc(shellMalloc) = NOERROR Then
    Begin
      SHGetSpecialFolderLocation(Application.Handle, Folder, ppidl);
      SetLength(Result, MAX_PATH);
      //If Not SHGetPathFromIDList(ppidl, PWideChar(Result)) Then
      If Not SHGetPathFromIDList(ppidl, PChar(Result)) Then
        Raise exception.create('SHGetPathFromIDList failed : invalid pidl');
      //SetLength(Result, lStrLen(PWideChar(Result)));
      SetLength(Result, lStrLen(PChar(Result)));
      If Result <> '' Then
      Begin
        If Copy(Result, Length(Result), 1) <> '\' Then
          Result := Result + '\';
      End;
    End;
  Finally
    If ppidl <> Nil Then shellMalloc.free(ppidl);
  End;
End;

Function PathOfAppDataLocal(): String;
Begin
  Result := PathOfSpecialFolder(28);
End;

Function ExecuteNewProcess(FileName: String;Visibility: integer): integer;
Var
  zAppName: Array[0..512] Of char;
  zCurDir: Array[0..255] Of char;
  WorkDir: String;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
Begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  If Not CreateProcess(Nil,
    zAppName, { pointer to command line string }
    Nil, { pointer to process security attributes}
    Nil, { pointer to thread security attributes }
    false, { handle inheritance flag }
    CREATE_NEW_PROCESS_GROUP,
    Nil, { pointer to new environment block }
    Nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo) Then
  Begin
    Result := -1 { pointer to PROCESS_INF }
  End
  Else
  Begin
    WaitforSingleObject(ProcessInfo.hProcess, 300);
    GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
  End;
End;


End.
