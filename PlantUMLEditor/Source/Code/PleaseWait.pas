unit PleaseWait;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.GIFImg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfrmPleaseWait = class(TForm)
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPleaseWait: TfrmPleaseWait;

implementation

{$R *.dfm}

procedure TfrmPleaseWait.FormActivate(Sender: TObject);
begin
  (Image1.Picture.Graphic as TGIFImage).Animate := True;
  SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0,
                     SWP_NoMove or SWP_NoSize);
end;

procedure TfrmPleaseWait.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPleaseWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetWindowPos(Self.Handle, HWND_NOTOPMOST, 0, 0, 0, 0,
                     SWP_NoMove or SWP_NoSize);
end;

procedure TfrmPleaseWait.Image1Click(Sender: TObject);
begin
  Close;
end;

end.
