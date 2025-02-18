program PlantUMLEditor;

uses
  Vcl.Forms,
  PlantUMLEditor_p in 'PlantUMLEditor_p.pas' {frmPlantUMLEditor},
  PleaseWait in 'PleaseWait.pas' {frmPleaseWait},
  PlantUMLHtml in 'PlantUMLHtml.pas',
  PUmlExamples in 'PUmlExamples.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPlantUMLEditor, frmPlantUMLEditor);
  Application.CreateForm(TfrmPleaseWait, frmPleaseWait);
  Application.Run;
end.
