Unit ads.Sendkey;
{Copyright(c)2022 Advanced Delphi Systems

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


Function SendKeyStrokeAltChar(Chr: Char): Boolean;

{!~ Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}
Function SendKey(VirtualKey: Word): Boolean;

{!~ Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}
Function KeySend(VirtualKey: Word): Boolean;
Procedure AltPrintScreen();

Function PrintScreenToFile(FileName: String): Boolean;


Implementation

Uses
  System.SysUtils,
  Vcl.Clipbrd,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  WinTypes;

Procedure SimulateKeystroke(Key: byte; extra: DWORD);
Begin
  keybd_event(Key, extra, 0, 0);
  keybd_event(Key, extra, KEYEVENTF_KEYUP, 0);
End;

Procedure AltPrintScreen();
Begin
  SimulateKeystroke(VK_SNAPSHOT, 1);
End;

Procedure PostVirtualKeyEvent(vk: Word; fUp: Bool);
Const
  ButtonUp: Array[False..True] Of Byte = (0, KEYEVENTF_KEYUP);
Var
  ScanCode: Byte;
Begin
  If vk <> vk_SnapShot Then
    ScanCode := MapVirtualKey(vk, 0)
  Else
    ScanCode := 0;
  Keybd_Event(vk, ScanCode, ButtonUp[fUp], 0);
End;

{Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}

Function SendKey(VirtualKey: Word): Boolean;
Begin
  Try
    PostVirtualKeyEvent(VirtualKey, False);
    PostVirtualKeyEvent(VirtualKey, True);
    Result := True;
  Except
    Result := False;
  End;
End;

{Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}

Function KeySend(VirtualKey: Word): Boolean;
Begin
  Result := SendKey(VirtualKey);
End;

Function SendKeyStrokeAltChar(Chr: Char): Boolean;
Var
  KeyInputs: Array Of TInput;

  Procedure KeybdInput(VKey: Byte; Flags: DWORD);
  Begin
    SetLength(KeyInputs, Length(KeyInputs) + 1);
    KeyInputs[high(KeyInputs)].Itype := INPUT_KEYBOARD;
    With KeyInputs[high(KeyInputs)].ki Do
    Begin
      wVk := VKey;
      wScan := MapVirtualKey(wVk, 0);
      dwFlags := Flags;
    End;
  End;
Begin
  Result := False;
  Try
    If Chr = '' Then Exit;
    KeybdInput(VK_MENU, 0);
    KeybdInput(Ord(Chr), 0);
    KeybdInput(Ord(Chr), KEYEVENTF_KEYUP);
    KeybdInput(VK_MENU, KEYEVENTF_KEYUP);
    SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(KeyInputs[0]));
    Result := True;
  Except
  End;
End;

Function PrintScreenToFile(FileName: String): Boolean;
Var
  bitmap: Vcl.Graphics.TBitmap;
  inPos: Integer;
  sgDirectory: String;
  sgFileExt: String;
  sgImageTypes: String;
  PNGImage: TPNGImage;
  JPEGImage: TJPEGImage;
  GifImage: TGifImage;
  Procedure SimulateKeystroke(Key: byte; extra: DWORD);
  Begin
    keybd_event(Key, extra, 0, 0);
    keybd_event(Key, extra, KEYEVENTF_KEYUP, 0);
  End;
  Procedure AltPrintScreen();
  Begin
    SimulateKeystroke(VK_SNAPSHOT, 1);
  End;
Begin
  Result := False;
  If Trim(FileName) = '' Then
    Exit;
  sgDirectory := System.SysUtils.ExtractFilePath(FileName);
  sgFileExt := LowerCase(System.SysUtils.ExtractFileExt(FileName));
  If Not DirectoryExists(sgDirectory) Then
  Begin
    ForceDirectories(sgDirectory);
    Application.ProcessMessages();
  End;
  AltPrintScreen();
  bitmap := Vcl.Graphics.TBitmap.Create;
  Try
    If Not Clipboard.HasFormat(CF_BITMAP) Then
      Exit;
    clipboard.GetAsHandle(CF_BITMAP);
    bitmap.Assign(Clipboard);
    sgImageTypes := '.bmp.gif.jpg.png';
    inPos := Pos(sgFileExt, sgImageTypes);
    If inPos = 0 Then
      Exit;
    Case inPos Of
      1: //.bmp
        Begin
          bitmap.SaveToFile(FileName);
          Result := True;
        End;
      5: //.gif
        Begin
          GifImage := TGifImage.Create;
          Try
            GifImage.Assign(bitmap);
            GifImage.SaveToFile(FileName);
            Result := True;
          Finally
            GifImage.Free;
          End;
        End;
      9: //.jpg
        Begin
          JPEGImage := TJPEGImage.Create;
          Try
            JPEGImage.Assign(bitmap);
            JPEGImage.SaveToFile(FileName);
            Result := True;
          Finally
            JPEGImage.Free;
          End;
        End;
      13: //.png
        Begin
          PNGImage := TPNGImage.Create;
          Try
            PNGImage.Assign(bitmap);
            PNGImage.SaveToFile(FileName);
            Result := True;
          Finally
            PNGImage.Free;
          End;
        End;
    End;
  Finally
    FreeAndNil(bitmap);
  End;
End;

End.
