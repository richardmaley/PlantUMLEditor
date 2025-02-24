unit ads.JsonUtils;

interface
Uses
  Vcl.StdCtrls;

function IsJsonValid(json: String): Boolean;
function JsonFormatter(json: String; IndentLevel: Integer): String; overload;
function JsonFormatter(json: String; IndentLevel: Integer; out IsError: Boolean; out ErrorMsg: String): String; overload;
function JsonGetIntegerValue(json,JsonPath: String): Integer;
function JsonGetStringValue(json,JsonPath: String): String;
function MinifyJson(json: String): String;
procedure ToggleJsonFormat(memo: TMemo);

implementation

Uses
  System.Classes,
  Vcl.Forms,
  System.IOUtils,
  System.json,
  System.Rtti,
  System.SysUtils,
  System.StrUtils,
  Vcl.Dialogs;

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

function JsonFormatter(json: String; IndentLevel: Integer; out IsError: Boolean; out ErrorMsg: String): String;
Var
  sgJson: String;
begin
  sgJson := json;
  IsError := False;
  ErrorMsg := '';
  try
    var
    JsonObject := TJSONObject.ParseJSONValue(sgJson) as TJSONObject;
    Result := JsonObject.Format(IndentLevel);
  except
    on E: Exception do
    begin
      ErrorMsg := E.Message;
      If ErrorMsg = 'Out of memory' Then
      Begin
        ErrorMsg := '';
      End
      Else
      Begin
        IsError := True;
        Result := json;
      End;
    end;
  end;
end;

function JsonFormatter(json: String; IndentLevel: Integer): String; overload;
Var
  IsError : Boolean;
  ErrorMsg: String;
Begin
  Result := JsonFormatter(json, IndentLevel, IsError, ErrorMsg);
End;

function MinifyJson(json: String): String;
var
  JsonObject: TJSONObject;
begin
  Result:=json;
  JsonObject:= TJSONObject.Create;
  try
    JsonObject := TJSONObject.ParseJSONValue(json) as TJSONObject;
    If Assigned(JsonObject) Then
      Result := JsonObject.ToString;
  finally
    JsonObject.Free;
  end;
end;

function IsJsonValid(json: String): Boolean;
Var
  IsError    : Boolean;
  IndentLevel: Integer;
  ErrorMsg   : String;
Begin
  IndentLevel := 4;
  JsonFormatter(json, IndentLevel, IsError, ErrorMsg);
  Result := Not IsError;
End;

function JsonGetStringValue(json,JsonPath: String): String;
Var
  sgJson      : String;
  sgJsonPath: String;
  JSONValue   : TJSONValue;
Begin
  Result:='';
  sgJson := json;
  sgJsonPath:= JsonPath;
  If Trim(sgJson)='' Then Exit;
  If Trim(sgJsonPath)='' Then Exit;
  JSONValue := TJSONObject.ParseJSONValue(sgJson);
  if JSONValue is TJSONObject then
  Begin
    Try
      Result := JSONValue.GetValue<string>(JsonPath);
    Except
    End;
  End;
End;

function JsonGetIntegerValue(json,JsonPath: String): Integer;
Var
  sgJson      : String;
  sgJsonPath: String;
  JSONValue   : TJSONValue;
Begin
  Result:=-1;
  sgJson := json;
  sgJsonPath:= JsonPath;
  If Trim(sgJson)='' Then Exit;
  If Trim(sgJsonPath)='' Then Exit;
  JSONValue := TJSONObject.ParseJSONValue(sgJson);
  if JSONValue is TJSONObject then
  Begin
    Try
      Result := JSONValue.GetValue<Integer>(JsonPath);
    Except
    End;
  End;
End;

procedure ToggleJsonFormat(memo: TMemo);
Var
  sgJson: String;
  boIsSelection: Boolean;
  sgJsonModified: String;
  inPos: Integer;
begin
  If Not Assigned(memo) Then Exit;
  If memo.SelText<>'' Then
  Begin
    sgJson := memo.SelText;
    boIsSelection:=True;
  End
  Else
  Begin
    sgJson := memo.Text;
    boIsSelection:=False;
  End;
  inPos:=Pos(#13,sgJson);
  Case memo.Tag Of
    0:
      Begin
        If inPos>0 Then
        Begin
          sgJsonModified  := MinifyJson(sgJson);
          If boIsSelection Then
            memo.SelText:=sgJsonModified
            Else
            memo.Lines.Text :=sgJsonModified;
          memo.Tag := 1;
        End
        Else
        Begin
          sgJsonModified:= JsonFormatter(sgJson, 2);
          If boIsSelection Then
            memo.SelText:=sgJsonModified
            Else
            memo.Lines.Text :=sgJsonModified;
          memo.Tag := 2;
        End;
      End;
    1:
      Begin
        sgJsonModified:= JsonFormatter(sgJson, 2);
        If boIsSelection Then
          memo.SelText:=sgJsonModified
          Else
          memo.Lines.Text :=sgJsonModified;
        memo.Tag := 2;
      End;
    2:
      Begin
        sgJsonModified  := MinifyJson(sgJson);
        If boIsSelection Then
          memo.SelText:=sgJsonModified
          Else
          memo.Lines.Text :=sgJsonModified;
        memo.Tag := 1;
      End;
  End;
end;

end.
