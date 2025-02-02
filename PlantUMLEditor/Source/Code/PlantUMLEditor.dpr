program PlantUMLEditor;

uses
  Vcl.Forms,
  PlantUMLEditor_p in 'PlantUMLEditor_p.pas' {frmPlantUMLEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPlantUMLEditor, frmPlantUMLEditor);
  Application.Run;
end.
