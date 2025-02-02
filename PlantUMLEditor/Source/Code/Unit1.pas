unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Edge, Vcl.StdCtrls, Vcl.Clipbrd,WinApi.WebView2,
  Winapi.ActiveX;

type
  TForm1 = class(TForm)
    EdgeBrowser1: TEdgeBrowser;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
      AResult: HRESULT; const AResultObjectAsJson: string);
//    procedure EdgeBrowser1ExecuteScriptResult(Sender: TObject;
//      AResult: COREWEBVIEW2_EXECUTE_SCRIPT_RESULT; const AResultObjectAsJson: string);
  private
    { Private declarations }
    procedure CopySelectedTextToClipboard;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CopySelectedTextToClipboard;
begin
  EdgeBrowser1.ExecuteScript(
    'window.getSelection().toString();'//, // JavaScript to get selected text
    //COREWEBVIEW2_EXECUTE_SCRIPT_KIND_STRING // Specify the result type as string
  );
end;

procedure TForm1.EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
  AResult: HRESULT; const AResultObjectAsJson: string);
begin

end;

//procedure TForm1.EdgeBrowser1ExecuteScriptResult(Sender: TObject;
//  AResult: COREWEBVIEW2_EXECUTE_SCRIPT_RESULT; const AResultObjectAsJson: string);
//var
//  SelectedText: string;
//begin
//  if AResult = COREWEBVIEW2_EXECUTE_SCRIPT_RESULT_SUCCESS then
//  begin
//    // Remove the surrounding quotes from the JSON string
//    SelectedText := AResultObjectAsJson.DeQuotedString('"');
//
//    // Copy the selected text to the clipboard
//    Clipboard.AsText := SelectedText;
//  end
//  else
//  begin
//    ShowMessage('Failed to retrieve selected text.');
//  end;
//end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  CopySelectedTextToClipboard;
end;

end.
