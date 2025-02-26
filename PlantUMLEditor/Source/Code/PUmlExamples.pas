unit PUmlExamples;

interface

Function SaveThemedExamplesToDisk(ExamplesDir: String): Boolean;
Function SaveDiagramTypesToDisk(ImagesDir: String): Boolean;

implementation

Uses
  ads.Globals,
  System.Classes,
  System.SysUtils,
  Vcl.Dialogs,
  Vcl.Forms;

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

Type
  TTextToDelphi = Record
    FileExt: String;
    FileName: String;
    FileBody: String;
    Raw: String;
    Function toString: String;
    Function toFile(FileName: String): Boolean;
  End;

  TTextToDelphiArray = Array Of TTextToDelphi;

Const
  UnitName='PUmlExamples';
  ThemedExamples = '' + #13 + #10 +                                                           //
    'PlantUmlExamples' + #13 + #10 +                                                          //
    'Files' + #13 + #10 +                                                                     //
    '1  CdsHooksPatientView.puml  ' + #13 + #10 +                                             //
    '2  PlantUMLThemes1.puml  ' + #13 + #10 +                                                 //
    '3  PlantUMLThemes2.puml  ' + #13 + #10 +                                                 //
    '4  PlantUMLThemes3.puml  ' + #13 + #10 +                                                 //
    '5  PlantUMLThemes4.puml  ' + #13 + #10 +                                                 //
    '6  Themed_activity-1.puml  ' + #13 + #10 +                                               //
    '7  Themed_activity-2.puml  ' + #13 + #10 +                                               //
    '8  Themed_board-1.puml  ' + #13 + #10 +                                                  //
    '9  Themed_class-1.puml  ' + #13 + #10 +                                                  //
    '10  Themed_class-2.puml  ' + #13 + #10 +                                                 //
    '11  Themed_class-3.puml  ' + #13 + #10 +                                                 //
    '12  Themed_component-1.puml  ' + #13 + #10 +                                             //
    '13  Themed_deployment-1.puml  ' + #13 + #10 +                                            //
    '14  Themed_deployment-2.puml  ' + #13 + #10 +                                            //
    '15  Themed_gantt-1.puml  ' + #13 + #10 +                                                 //
    '16  Themed_gantt-2.puml  ' + #13 + #10 +                                                 //
    '17  Themed_json-1.puml  ' + #13 + #10 +                                                  //
    '18  Themed_json-2.puml  ' + #13 + #10 +                                                  //
    '19  Themed_mindmap-1.puml  ' + #13 + #10 +                                               //
    '20  Themed_mindmap-2.puml  ' + #13 + #10 +                                               //
    '21  Themed_mindmap-3.puml  ' + #13 + #10 +                                               //
    '22  Themed_nwdiag-1.puml  ' + #13 + #10 +                                                //
    '23  Themed_object-1.puml  ' + #13 + #10 +                                                //
    '24  Themed_object-2.puml  ' + #13 + #10 +                                                //
    '25  Themed_salt-1.puml  ' + #13 + #10 +                                                  //
    '26  Themed_sequence-1.puml  ' + #13 + #10 +                                              //
    '27  Themed_sequence-2.puml  ' + #13 + #10 +                                              //
    '28  Themed_sequence-3.puml  ' + #13 + #10 +                                              //
    '29  Themed_sequence-4.puml  ' + #13 + #10 +                                              //
    '30  Themed_state-1.puml  ' + #13 + #10 +                                                 //
    '31  Themed_state-2.puml  ' + #13 + #10 +                                                 //
    '32  Themed_state-3.puml  ' + #13 + #10 +                                                 //
    '33  Themed_swimlane-1.puml  ' + #13 + #10 +                                              //
    '34  Themed_timing-1.puml  ' + #13 + #10 +                                                //
    '35  Themed_timing-2.puml  ' + #13 + #10 +                                                //
    '36  Themed_usecase-1.puml  ' + #13 + #10 +                                               //
    '37  Themed_usecase-2.puml  ' + #13 + #10 +                                               //
    '38  Themed_usecase-3.puml  ' + #13 + #10 +                                               //
    '39  Themed_wbs-1.puml  ' + #13 + #10 +                                                   //
    '40  Themed_wbs-2.puml  ' + #13 + #10 +                                                   //
    '41  Themed_wire-1.puml  ' + #13 + #10 +                                                  //
    '42  Themed_yaml-1.puml  ' + #13 + #10 +                                                  //
    '43  Themed_yaml-2.puml  ' + #13 + #10 +                                                  //
    '' + #13 + #10 +                                                                          //
    '//{zjq}' + #13 + #10 +                                                                   //
    '//  CdsHooksPatientView.puml  Top' + #13 + #10 +
    '@startuml'+#13+#10+//
    '!Diagram = "activity"'+#13+#10+//
    '<style>'+#13+#10+//
    'root {'+#13+#10+//
    '  --default-BackGroundColor: White Smoke;'+#13+#10+//
    '  --default-DiagonalCorner: 0;'+#13+#10+//
    '  --default-FontName: SansSerif;'+#13+#10+//
    '  --default-FontSize: 14;'+#13+#10+//
    '  --default-FontSize-Title: 24;'+#13+#10+//
    '  --default-LineThickness: 2.0;'+#13+#10+//
    '  --default-note-BackgroundColor: #white/LemonChiffon;'+#13+#10+//
    '  --default-RoundCorner: 25;'+#13+#10+//
    '  --default-Shadowing:3.0;'+#13+#10+//
    '  BackGroundColor: var(--default-BackGroundColor);'+#13+#10+//
    '  DiagonalCorner: var(--default-DiagonalCorner);'+#13+#10+//
    '  FontColor black'+#13+#10+//
    '  FontName: var(--default-FontName);'+#13+#10+//
    '  FontSize: var(--default-FontSize);'+#13+#10+//
    '  FontStyle plain'+#13+#10+//
    '  HorizontalAlignment left'+#13+#10+//
    '  HyperLinkColor blue'+#13+#10+//
    '  HyperLinkUnderlineThickness 1'+#13+#10+//
    '  LineColor black'+#13+#10+//
    '  LineThickness: var(--default-LineThickness);'+#13+#10+//
    '  RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '  Shadowing: 0.0;'+#13+#10+//
    '  arrow {'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontName: var(--default-FontName);'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor black'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '  }'+#13+#10+//
    '  caption {'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor transparent'+#13+#10+//
    '    Margin 5'+#13+#10+//
    '    Padding 5'+#13+#10+//
    '  }'+#13+#10+//
    '  footer {'+#13+#10+//
    '    BackGroundColor transparent'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle bold'+#13+#10+//
    '    HorizontalAlignment right'+#13+#10+//
    '    LineColor transparent'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '  }'+#13+#10+//
    '  group {'+#13+#10+//
    '    BackgroundColor #white/Aqua'+#13+#10+//
    '    FontColor Blue'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor Blue'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '    '' Shadowing: 3.0;'+#13+#10+//
    '                Shadowing: var(--default-Shadowing);'+#13+#10+//
    '    package {'+#13+#10+//
    '      LineThickness: var(--default-LineThickness);'+#13+#10+//
    '      LineColor black'+#13+#10+//
    '    }'+#13+#10+//
    '    folder {'+#13+#10+//
    '      LineThickness: var(--default-LineThickness);'+#13+#10+//
    '      LineColor black'+#13+#10+//
    '    }'+#13+#10+//
    '  }'+#13+#10+//
    '  groupHeader {'+#13+#10+//
    '    BackGroundColor white'+#13+#10+//
    '    FontColor blue'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle bold'+#13+#10+//
    '    LineColor black'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '  }  '+#13+#10+//
    '  header {'+#13+#10+//
    '    BackGroundColor transparent'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle bold'+#13+#10+//
    '    HorizontalAlignment right'+#13+#10+//
    '    LineColor transparent'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '  }'+#13+#10+//
    '  note {'+#13+#10+//
    '    FontColor Blue'+#13+#10+//
    '                FontSize:: var(--default-FontSize);'+#13+#10+//
    '    LineColor Navy'+#13+#10+//
    '                LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    BackGroundColor:var(--default-note-BackgroundColor);'+#13+#10+//
    '  }'+#13+#10+//
    '  swimlane {'+#13+#10+//
    '    BackgroundColor transparent'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '  } '+#13+#10+//
    '  title {'+#13+#10+//
    '    BackGroundColor transparent'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontSize:: var(default-FontSize-Title);'+#13+#10+//
    '    FontStyle bold'+#13+#10+//
    '    HorizontalAlignment center'+#13+#10+//
    '    LineColor transparent'+#13+#10+//
    '  }  '+#13+#10+//
    '}'+#13+#10+//
    'activityDiagram {'+#13+#10+//
    '  DiagonalCorner: var(--default-DiagonalCorner);'+#13+#10+//
    '  FontName: var(--default-FontName);'+#13+#10+//
    '  FontSize:: var(--default-FontSize);'+#13+#10+//
    '  FontStyle plain'+#13+#10+//
    '  HorizontalAlignment left'+#13+#10+//
    '  LineColor black'+#13+#10+//
    '  LineThickness: var(--default-LineThickness);'+#13+#10+//
    '  RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '  activity {'+#13+#10+//
    '    BackgroundColor #white/palegreen'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontName: var(--default-FontName);'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor black'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '    ''Shadowing: 3.0;'+#13+#10+//
    '    Shadowing: var(--default-Shadowing);'+#13+#10+//
    '  }'+#13+#10+//
    '  diamond {'+#13+#10+//
    '    BackgroundColor #white/yellow'+#13+#10+//
    '    BorderColor black'+#13+#10+//
    '    FontColor Black'+#13+#10+//
    '    FontName: var(--default-FontName);'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor black'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    ''Shadowing: 3.0;'+#13+#10+//
    '    Shadowing: var(--default-Shadowing);'+#13+#10+//
    '  }'+#13+#10+//
    '  end {'+#13+#10+//
    '    LineColor red'+#13+#10+//
    '  }'+#13+#10+//
    '  card {'+#13+#10+//
    '    BackgroundColor #white/Aqua'+#13+#10+//
    '    FontColor Blue'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor Blue'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '    ''Shadowing: 3.0;  '+#13+#10+//
    '    Shadowing: var(--default-Shadowing);'+#13+#10+//
    '  }  '+#13+#10+//
    '  package {'+#13+#10+//
    '    BackgroundColor #white/Aqua'+#13+#10+//
    '    FontColor Blue'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor Blue'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '    ''Shadowing: 3.0;  '+#13+#10+//
    '    Shadowing: var(--default-Shadowing);'+#13+#10+//
    '  }  '+#13+#10+//
    '  partition {'+#13+#10+//
    '    BackgroundColor #white/Aqua'+#13+#10+//
    '    FontColor Blue'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor Blue'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '    ''Shadowing: 3.0;  '+#13+#10+//
    '    Shadowing: var(--default-Shadowing);'+#13+#10+//
    '  }'+#13+#10+//
    '  rectangle {'+#13+#10+//
    '    BackgroundColor #white/Aqua'+#13+#10+//
    '    FontColor Blue'+#13+#10+//
    '    FontSize:: var(--default-FontSize);'+#13+#10+//
    '    FontStyle Bold'+#13+#10+//
    '    LineColor Blue'+#13+#10+//
    '    LineThickness: var(--default-LineThickness);'+#13+#10+//
    '    RoundCorner:0;'+#13+#10+//
    '    ''RoundCorner: var(--default-RoundCorner);'+#13+#10+//
    '    ''Shadowing: 3.0;  '+#13+#10+//
    '    Shadowing: var(--default-Shadowing);'+#13+#10+//
    '  }  '+#13+#10+//
    '  start {'+#13+#10+//
    '    BackgroundColor #white/green'+#13+#10+//
    '    LineColor green'+#13+#10+//
    '  }'+#13+#10+//
    '  stop {'+#13+#10+//
    '    BackgroundColor #white/red'+#13+#10+//
    '    LineColor red'+#13+#10+//
    '  }'+#13+#10+//
    '  swimlane {'+#13+#10+//
    '    BackgroundColor transparent'+#13+#10+//
    '    FontColor black'+#13+#10+//
    '    FontSize 20'+#13+#10+//
    '    FontStyle bold'+#13+#10+//
    '}'+#13+#10+//
    'document {'+#13+#10+//
    '   BackgroundColor transparent'+#13+#10+//
    '}'+#13+#10+//
    '</style>'+#13+#10+//
    'title: EHR\npatient-view\nCDS-Hooks\nActivity Diagram'+#13+#10+//
    '|EHR GUI|'+#13+#10+//
    'start'+#13+#10+//
    'repeat'+#13+#10+//
    ':Clinician\nchanges\npatient;'+#13+#10+//
    'if (   If Business Rules and'+#13+#10+//
    '    filters determine'+#13+#10+//
    '    CDS-Hooks are not'+#13+#10+//
    '    required now) then (  true   )'+#13+#10+//
    '  stop'+#13+#10+//
    'else ( false)'+#13+#10+//
    '  :EHR makes a REST request for'+#13+#10+//
    '  patient-view hook data for the'+#13+#10+//
    '  current patient;'+#13+#10+//
    'endif'+#13+#10+//
    '|#AntiqueWhite|CDS-Hooks Service|'+#13+#10+//
    ':Patient-view hook receives a'+#13+#10+//
    'REST request for CDS-Hook cards;'+#13+#10+//
    ':A JSON response is prepared and'+#13+#10+//
    'returned to EHR.  This response'+#13+#10+//
    'includes an array of CDS-Hook'+#13+#10+//
    'cards.;'+#13+#10+//
    '|EHR GUI|'+#13+#10+//
    'repeat while (Has patient\ncontext changed) not (no)'+#13+#10+//
    'if (CDS-Hook response\nhas an empty array\nof CDS-Hook cards) then (true)'+#13+#10+//
    '  :The clinician\nwork-flow\ncontinues\nuninterrupted;'+#13+#10+//
    '  stop'+#13+#10+//
    'else (false)'+#13+#10+//
    ':*EHR displays a stay-on-top\nnon-modal dialog to present\nCDS-Hooks cards to the clinician\nfor review and action.\n*The dialog has an embedded\nEdge browser hosting a React\nweb application.; '+#13+#10+//
    '|EHR web App|'+#13+#10+//
    '    :*React application initializes\nwith CDS-Hook cards.\n*The cards are presented sorted\nmost important to least important.\n*All 508 regulations need to be\ncomplied with.\n*The dialog has a list of card titles\non the left and a card viewing area\non the right.\n*The current card selection is\nhighlighted in the list on the left.\n*Card importance is highlighted in\nthe list on the left.;'+#13+#10+//
    'while (Are there more\ncards to process?) is (Next Card)'+#13+#10+//
    'if (clinician wants to stop) then (true)'+#13+#10+//
    '  |EHR GUI|'+#13+#10+//
    '  :Clinician closes\nthe dialog;'+#13+#10+//
    '  stop'+#13+#10+//
    'else (false)'+#13+#10+//
    '|EHR web App|'+#13+#10+//
    '  :*Clinician reviews next card.\n*Action is recorded as:\n**none,\n**read,\n**accepted, or\n**rejected.;'+#13+#10+//
    'endif '+#13+#10+//
    '  |EHR web App|'+#13+#10+//
    '  :Card action is sent to\nCDS-Hooks Service;'+#13+#10+//
    '  :Next Card;'+#13+#10+//
    '  backward:again;'+#13+#10+//
    'endwhile (No more cards)'+#13+#10+//
    '|EHR GUI|'+#13+#10+//
    ':Clinician closes\nthe dialog;'+#13+#10+//
    'stop'+#13+#10+//
    '''header: patient-view'+#13+#10+//
    '''caption patient-view'+#13+#10+//
    '@enduml'+#13+#10+//
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '//{qjz}' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '//{zjq}' + #13 + #10 +                                       //
    '//  PlantUMLThemes1.puml  Top' + #13 + #10 +                 //
    '@startuml' + #13 + #10 +                                     //
    '' + #13 + #10 +                                              //
    'label l [' + #13 + #10 +                                     //
    '{{' + #13 + #10 +                                            //
    '!theme amiga' + #13 + #10 +                                  //
    'title amiga' + #13 + #10 +                                   //
    'Alice -> Bob: amiga' + #13 + #10 +                           //
    'Bob -> Alice: amiga' + #13 + #10 +                           //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme aws-orange' + #13 + #10 +                             //
    'title aws-orange' + #13 + #10 +                              //
    'Alice -> Bob: aws-orange' + #13 + #10 +                      //
    'Bob -> Alice: aws-orange' + #13 + #10 +                      //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme black-knight' + #13 + #10 +                           //
    'title black-knight' + #13 + #10 +                            //
    'Alice -> Bob: black-knight' + #13 + #10 +                    //
    'Bob -> Alice: black-knight' + #13 + #10 +                    //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme bluegray' + #13 + #10 +                               //
    'title bluegray' + #13 + #10 +                                //
    'Alice -> Bob: bluegray' + #13 + #10 +                        //
    'Bob -> Alice: bluegray' + #13 + #10 +                        //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme blueprint' + #13 + #10 +                              //
    'title blueprint' + #13 + #10 +                               //
    'Alice -> Bob: blueprint' + #13 + #10 +                       //
    'Bob -> Alice: blueprint' + #13 + #10 +                       //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme carbon-gray' + #13 + #10 +                            //
    'title carbon-gray' + #13 + #10 +                             //
    'Alice -> Bob: carbon-gray' + #13 + #10 +                     //
    'Bob -> Alice: carbon-gray' + #13 + #10 +                     //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme cerulean-outline' + #13 + #10 +                       //
    'title cerulean-outline' + #13 + #10 +                        //
    'Alice -> Bob: cerulean-outline' + #13 + #10 +                //
    'Bob -> Alice: cerulean-outline' + #13 + #10 +                //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme cerulean' + #13 + #10 +                               //
    'title cerulean' + #13 + #10 +                                //
    'Alice -> Bob: cerulean' + #13 + #10 +                        //
    'Bob -> Alice: cerulean' + #13 + #10 +                        //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme cloudscape-design' + #13 + #10 +                      //
    'title cloudscape-design' + #13 + #10 +                       //
    'Alice -> Bob: cloudscape-design' + #13 + #10 +               //
    'Bob -> Alice: cloudscape-design' + #13 + #10 +               //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme crt-amber' + #13 + #10 +                              //
    'title crt-amber' + #13 + #10 +                               //
    'Alice -> Bob: crt-amber' + #13 + #10 +                       //
    'Bob -> Alice: crt-amber' + #13 + #10 +                       //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    ']' + #13 + #10 +                                             //
    '@enduml' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '//{qjz}' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '//{zjq}' + #13 + #10 +                                       //
    '//  PlantUMLThemes2.puml  Top' + #13 + #10 +                 //
    '@startuml' + #13 + #10 +                                     //
    '' + #13 + #10 +                                              //
    'label l [' + #13 + #10 +                                     //
    '{{' + #13 + #10 +                                            //
    '!theme crt-green' + #13 + #10 +                              //
    'title crt-green' + #13 + #10 +                               //
    'Alice -> Bob: crt-green' + #13 + #10 +                       //
    'Bob -> Alice: crt-green' + #13 + #10 +                       //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme cyborg-outline' + #13 + #10 +                         //
    'title cyborg-outline' + #13 + #10 +                          //
    'Alice -> Bob: cyborg-outline' + #13 + #10 +                  //
    'Bob -> Alice: cyborg-outline' + #13 + #10 +                  //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme cyborg' + #13 + #10 +                                 //
    'title cyborg' + #13 + #10 +                                  //
    'Alice -> Bob: cyborg' + #13 + #10 +                          //
    'Bob -> Alice: cyborg' + #13 + #10 +                          //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme hacker' + #13 + #10 +                                 //
    'title hacker' + #13 + #10 +                                  //
    'Alice -> Bob: hacker' + #13 + #10 +                          //
    'Bob -> Alice: hacker' + #13 + #10 +                          //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme lightgray' + #13 + #10 +                              //
    'title lightgray' + #13 + #10 +                               //
    'Alice -> Bob: lightgray' + #13 + #10 +                       //
    'Bob -> Alice: lightgray' + #13 + #10 +                       //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme mars' + #13 + #10 +                                   //
    'title mars' + #13 + #10 +                                    //
    'Alice -> Bob: mars' + #13 + #10 +                            //
    'Bob -> Alice: mars' + #13 + #10 +                            //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme materia-outline' + #13 + #10 +                        //
    'title materia-outline' + #13 + #10 +                         //
    'Alice -> Bob: materia-outline' + #13 + #10 +                 //
    'Bob -> Alice: materia-outline' + #13 + #10 +                 //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme materia' + #13 + #10 +                                //
    'title materia' + #13 + #10 +                                 //
    'Alice -> Bob: materia' + #13 + #10 +                         //
    'Bob -> Alice: materia' + #13 + #10 +                         //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme metal' + #13 + #10 +                                  //
    'title metal' + #13 + #10 +                                   //
    'Alice -> Bob: metal' + #13 + #10 +                           //
    'Bob -> Alice: metal' + #13 + #10 +                           //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme mimeograph' + #13 + #10 +                             //
    'title mimeograph' + #13 + #10 +                              //
    'Alice -> Bob: mimeograph' + #13 + #10 +                      //
    'Bob -> Alice: mimeograph' + #13 + #10 +                      //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    ']' + #13 + #10 +                                             //
    '@enduml' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '//{qjz}' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '//{zjq}' + #13 + #10 +                                       //
    '//  PlantUMLThemes3.puml  Top' + #13 + #10 +                 //
    '@startuml' + #13 + #10 +                                     //
    '' + #13 + #10 +                                              //
    'label l [' + #13 + #10 +                                     //
    '{{' + #13 + #10 +                                            //
    '!theme minty' + #13 + #10 +                                  //
    'title minty' + #13 + #10 +                                   //
    'Alice -> Bob: minty' + #13 + #10 +                           //
    'Bob -> Alice: minty' + #13 + #10 +                           //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme mono' + #13 + #10 +                                   //
    'title mono' + #13 + #10 +                                    //
    'Alice -> Bob: mono' + #13 + #10 +                            //
    'Bob -> Alice: mono' + #13 + #10 +                            //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme plain' + #13 + #10 +                                  //
    'title plain' + #13 + #10 +                                   //
    'Alice -> Bob: plain' + #13 + #10 +                           //
    'Bob -> Alice: plain' + #13 + #10 +                           //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-darkblue' + #13 + #10 +                      //
    'title reddress-darkblue' + #13 + #10 +                       //
    'Alice -> Bob: reddress-darkblue' + #13 + #10 +               //
    'Bob -> Alice: reddress-darkblue' + #13 + #10 +               //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-darkgreen' + #13 + #10 +                     //
    'title reddress-darkgreen' + #13 + #10 +                      //
    'Alice -> Bob: reddress-darkgreen' + #13 + #10 +              //
    'Bob -> Alice: reddress-darkgreen' + #13 + #10 +              //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-darkorange' + #13 + #10 +                    //
    'title reddress-darkorange' + #13 + #10 +                     //
    'Alice -> Bob: reddress-darkorange' + #13 + #10 +             //
    'Bob -> Alice: reddress-darkorange' + #13 + #10 +             //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-darkred' + #13 + #10 +                       //
    'title reddress-darkred' + #13 + #10 +                        //
    'Alice -> Bob: reddress-darkred' + #13 + #10 +                //
    'Bob -> Alice: reddress-darkred' + #13 + #10 +                //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-lightblue' + #13 + #10 +                     //
    'title reddress-lightblue' + #13 + #10 +                      //
    'Alice -> Bob: reddress-lightblue' + #13 + #10 +              //
    'Bob -> Alice: reddress-lightblue' + #13 + #10 +              //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-lightgreen' + #13 + #10 +                    //
    'title reddress-lightgreen' + #13 + #10 +                     //
    'Alice -> Bob: reddress-lightgreen' + #13 + #10 +             //
    'Bob -> Alice: reddress-lightgreen' + #13 + #10 +             //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    ']' + #13 + #10 +                                             //
    '@enduml' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '//{qjz}' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '//{zjq}' + #13 + #10 +                                       //
    '//  PlantUMLThemes4.puml  Top' + #13 + #10 +                 //
    '@startuml' + #13 + #10 +                                     //
    '' + #13 + #10 +                                              //
    'label l [' + #13 + #10 +                                     //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-lightorange' + #13 + #10 +                   //
    'title reddress-lightorange' + #13 + #10 +                    //
    'Alice -> Bob: reddress-lightorange' + #13 + #10 +            //
    'Bob -> Alice: reddress-lightorange' + #13 + #10 +            //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme reddress-lightred' + #13 + #10 +                      //
    'title reddress-lightred' + #13 + #10 +                       //
    'Alice -> Bob: reddress-lightred' + #13 + #10 +               //
    'Bob -> Alice: reddress-lightred' + #13 + #10 +               //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme sandstone' + #13 + #10 +                              //
    'title sandstone' + #13 + #10 +                               //
    'Alice -> Bob: sandstone' + #13 + #10 +                       //
    'Bob -> Alice: sandstone' + #13 + #10 +                       //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme silver' + #13 + #10 +                                 //
    'title silver' + #13 + #10 +                                  //
    'Alice -> Bob: silver' + #13 + #10 +                          //
    'Bob -> Alice: silver' + #13 + #10 +                          //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme sketchy-outline' + #13 + #10 +                        //
    'title sketchy-outline' + #13 + #10 +                         //
    'Alice -> Bob: sketchy-outline' + #13 + #10 +                 //
    'Bob -> Alice: sketchy-outline' + #13 + #10 +                 //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme sketchy' + #13 + #10 +                                //
    'title sketchy' + #13 + #10 +                                 //
    'Alice -> Bob: sketchy' + #13 + #10 +                         //
    'Bob -> Alice: sketchy' + #13 + #10 +                         //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme spacelab-white' + #13 + #10 +                         //
    'title spacelab-white' + #13 + #10 +                          //
    'Alice -> Bob: spacelab-white' + #13 + #10 +                  //
    'Bob -> Alice: spacelab-white' + #13 + #10 +                  //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme spacelab' + #13 + #10 +                               //
    'title spacelab' + #13 + #10 +                                //
    'Alice -> Bob: spacelab' + #13 + #10 +                        //
    'Bob -> Alice: spacelab' + #13 + #10 +                        //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme superhero-outline' + #13 + #10 +                      //
    'title superhero-outline' + #13 + #10 +                       //
    'Alice -> Bob: superhero-outline' + #13 + #10 +               //
    'Bob -> Alice: superhero-outline' + #13 + #10 +               //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme superhero' + #13 + #10 +                              //
    'title superhero' + #13 + #10 +                               //
    'Alice -> Bob: superhero' + #13 + #10 +                       //
    'Bob -> Alice: superhero' + #13 + #10 +                       //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme toy' + #13 + #10 +                                    //
    'title toy' + #13 + #10 +                                     //
    'Alice -> Bob: toy' + #13 + #10 +                             //
    'Bob -> Alice: toy' + #13 + #10 +                             //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme united' + #13 + #10 +                                 //
    'title united' + #13 + #10 +                                  //
    'Alice -> Bob: united' + #13 + #10 +                          //
    'Bob -> Alice: united' + #13 + #10 +                          //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    '!theme vibrant' + #13 + #10 +                                //
    'title vibrant' + #13 + #10 +                                 //
    'Alice -> Bob: vibrant' + #13 + #10 +                         //
    'Bob -> Alice: vibrant' + #13 + #10 +                         //
    '}}' + #13 + #10 +                                            //
    '{{' + #13 + #10 +                                            //
    'title ___________________________________  ' + #13 + #10 +   //
    '}}' + #13 + #10 +                                            //
    ']' + #13 + #10 +                                             //
    '@enduml' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '' + #13 + #10 +                                              //
    '//{qjz}' + #13 + #10 +                                       //
    '' + #13 + #10 +                                              //
    '//{zjq}' + #13 + #10 +                                       //
    '//  Themed_activity-1.puml  Top' + #13 + #10 +               //
    '@startuml' + #13 + #10 +                                     //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Activity Diagram - $THEME theme' + #13 + #10 +                           //
    'start' + #13 + #10 +                                                           //
    ' :start;' + #13 + #10 +                                                        //
    ' fork' + #13 + #10 +                                                           //
    '  partition "My Partition" {' + #13 + #10 +                                    //
    '   :foo1;' + #13 + #10 +                                                       //
    '   :foo2;' + #13 + #10 +                                                       //
    '  }' + #13 + #10 +                                                             //
    ' fork again' + #13 + #10 +                                                     //
    '   :foo3;' + #13 + #10 +                                                       //
    '   note right: Note' + #13 + #10 +                                             //
    '   detach' + #13 + #10 +                                                       //
    ' endfork' + #13 + #10 +                                                        //
    ' if (foo4) then (yes)' + #13 + #10 +                                           //
    '   :foo5;' + #13 + #10 +                                                       //
    '   detach' + #13 + #10 +                                                       //
    ' else (no)' + #13 + #10 +                                                      //
    '  stop' + #13 + #10 +                                                          //
    ' endif' + #13 + #10 +                                                          //
    ' :foo6;' + #13 + #10 +                                                         //
    ' detach' + #13 + #10 +                                                         //
    ' :foo7;' + #13 + #10 +                                                         //
    ' stop' + #13 + #10 +                                                           //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_activity-2.puml  Top' + #13 + #10 +                                 //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Activity Diagram - $THEME theme' + #13 + #10 +                           //
    'start' + #13 + #10 +                                                           //
    ':init;' + #13 + #10 +                                                          //
    '-> test of color;' + #13 + #10 +                                               //
    'if (color?) is (red) then' + #13 + #10 +                                       //
    '  :print red;' + #13 + #10 +                                                   //
    'else ' + #13 + #10 +                                                           //
    '  :print not red;' + #13 + #10 +                                               //
    '  note right: no color' + #13 + #10 +                                          //
    'endif' + #13 + #10 +                                                           //
    'partition End {' + #13 + #10 +                                                 //
    '  :end;' + #13 + #10 +                                                         //
    '}' + #13 + #10 +                                                               //
    '-> this is the end;' + #13 + #10 +                                             //
    'end' + #13 + #10 +                                                             //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_board-1.puml  Top' + #13 + #10 +                                    //
    '@startboard' + #13 + #10 +                                                     //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Board Diagram - $THEME theme' + #13 + #10 +                              //
    'A1' + #13 + #10 +                                                              //
    '+U1.1' + #13 + #10 +                                                           //
    '++S1 R1' + #13 + #10 +                                                         //
    '++S1 R2 ' + #13 + #10 +                                                        //
    '+U1.2' + #13 + #10 +                                                           //
    'A2' + #13 + #10 +                                                              //
    '@endboard' + #13 + #10 +                                                       //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_class-1.puml  Top' + #13 + #10 +                                    //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Class Diagram With Abstract Interface- $THEME theme' + #13 + #10 +       //
    'abstract class AbstractList' + #13 + #10 +                                     //
    'abstract AbstractCollection' + #13 + #10 +                                     //
    'interface List' + #13 + #10 +                                                  //
    'interface Collection' + #13 + #10 +                                            //
    'List <|-- AbstractList : AList to List' + #13 + #10 +                          //
    'Collection <|-- AbstractCollection : AColl to Coll' + #13 + #10 +              //
    'Collection <|- List : List to Coll' + #13 + #10 +                              //
    'AbstractCollection <|- AbstractList : AList to AColl' + #13 + #10 +            //
    'AbstractList <|-- ArrayList : ArList to AList' + #13 + #10 +                   //
    'class ArrayList {' + #13 + #10 +                                               //
    '  Object[] elementData' + #13 + #10 +                                          //
    '  size()' + #13 + #10 +                                                        //
    '}' + #13 + #10 +                                                               //
    'enum TimeUnit {' + #13 + #10 +                                                 //
    '  DAYS' + #13 + #10 +                                                          //
    '  HOURS' + #13 + #10 +                                                         //
    '  MINUTES' + #13 + #10 +                                                       //
    '}' + #13 + #10 +                                                               //
    'annotation SuppressWarnings' + #13 + #10 +                                     //
    'annotation Annotation {' + #13 + #10 +                                         //
    '  annotation with members' + #13 + #10 +                                       //
    '  String foo()' + #13 + #10 +                                                  //
    '  String bar()' + #13 + #10 +                                                  //
    '}' + #13 + #10 +                                                               //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_class-2.puml  Top' + #13 + #10 +                                    //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Class Diagram - $THEME theme' + #13 + #10 +                              //
    'abstract class AbstractList' + #13 + #10 +                                     //
    'abstract AbstractCollection' + #13 + #10 +                                     //
    'interface List' + #13 + #10 +                                                  //
    'interface Collection' + #13 + #10 +                                            //
    'List <|-- AbstractList: this is a message' + #13 + #10 +                       //
    'Collection <|-- AbstractCollection' + #13 + #10 +                              //
    'Collection <|- List' + #13 + #10 +                                             //
    'AbstractCollection <|- AbstractList' + #13 + #10 +                             //
    'AbstractList <|-- ArrayList' + #13 + #10 +                                     //
    'class ArrayList {' + #13 + #10 +                                               //
    '  Object[] elementData' + #13 + #10 +                                          //
    '  size()' + #13 + #10 +                                                        //
    '}' + #13 + #10 +                                                               //
    'enum TimeUnit {' + #13 + #10 +                                                 //
    '  DAYS' + #13 + #10 +                                                          //
    '  HOURS' + #13 + #10 +                                                         //
    '  MINUTES' + #13 + #10 +                                                       //
    '}' + #13 + #10 +                                                               //
    'annotation SuppressWarnings' + #13 + #10 +                                     //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_class-3.puml  Top' + #13 + #10 +                                    //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Class Diagram 2- $THEME theme' + #13 + #10 +                             //
    'abstract        abstract' + #13 + #10 +                                        //
    'abstract class  "abstract class"' + #13 + #10 +                                //
    'annotation      annotation' + #13 + #10 +                                      //
    'circle          circle' + #13 + #10 +                                          //
    '()              circle_short_form' + #13 + #10 +                               //
    'class           class' + #13 + #10 +                                           //
    'diamond         diamond' + #13 + #10 +                                         //
    '<>              diamond_short_form' + #13 + #10 +                              //
    'entity          entity' + #13 + #10 +                                          //
    'enum            enum' + #13 + #10 +                                            //
    'interface       interface' + #13 + #10 +                                       //
    'protocol        protocol' + #13 + #10 +                                        //
    'struct          struct' + #13 + #10 +                                          //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_component-1.puml  Top' + #13 + #10 +                                //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Component Diagram - $THEME theme' + #13 + #10 +                          //
    'package "My Package" {' + #13 + #10 +                                          //
    '  HTTP - [First Component]' + #13 + #10 +                                      //
    '  [Another Component]' + #13 + #10 +                                           //
    '  rectangle MyRectangle1' + #13 + #10 +                                        //
    '  collections MyCollection1' + #13 + #10 +                                     //
    '}' + #13 + #10 +                                                               //
    'node "My Node" {' + #13 + #10 +                                                //
    '  FTP - [Second Component]' + #13 + #10 +                                      //
    '  [First Component] --> FTP' + #13 + #10 +                                     //
    '  rectangle MyRectangle2' + #13 + #10 +                                        //
    '} ' + #13 + #10 +                                                              //
    'cloud "My Cloud" {' + #13 + #10 +                                              //
    '  [Example 1]' + #13 + #10 +                                                   //
    '}' + #13 + #10 +                                                               //
    'collections MyCollection2' + #13 + #10 +                                       //
    'database "My Database" {' + #13 + #10 +                                        //
    '  folder "My folder" {' + #13 + #10 +                                          //
    '	[Folder 3]' + #13 + #10 +                                                     //
    '  }' + #13 + #10 +                                                             //
    '  frame "My Frame" {' + #13 + #10 +                                            //
    '	[Frame 4]' + #13 + #10 +                                                      //
    '  }' + #13 + #10 +                                                             //
    '}' + #13 + #10 +                                                               //
    'artifact "My Artifact"' + #13 + #10 +                                          //
    'storage "My Storage"' + #13 + #10 +                                            //
    'queue "My Queue"' + #13 + #10 +                                                //
    'interface "My Interface"' + #13 + #10 +                                        //
    'card "My Card"' + #13 + #10 +                                                  //
    'file "My File"' + #13 + #10 +                                                  //
    'stack "My Stack"' + #13 + #10 +                                                //
    '[Another Component] --> [Example 1]: some message' + #13 + #10 +               //
    '[Example 1] --> [Folder 3]' + #13 + #10 +                                      //
    '[Folder 3] --> [Frame 4]' + #13 + #10 +                                        //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_deployment-1.puml  Top' + #13 + #10 +                               //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Deployment Diagram - $THEME theme' + #13 + #10 +                         //
    'actor actor' + #13 + #10 +                                                     //
    'actor/ "actor/"' + #13 + #10 +                                                 //
    'agent agent' + #13 + #10 +                                                     //
    'artifact artifact' + #13 + #10 +                                               //
    'boundary boundary' + #13 + #10 +                                               //
    'card card' + #13 + #10 +                                                       //
    'circle circle' + #13 + #10 +                                                   //
    'cloud cloud' + #13 + #10 +                                                     //
    'collections collections' + #13 + #10 +                                         //
    'component component' + #13 + #10 +                                             //
    'control control' + #13 + #10 +                                                 //
    'database database' + #13 + #10 +                                               //
    'entity entity' + #13 + #10 +                                                   //
    'file file' + #13 + #10 +                                                       //
    'folder folder' + #13 + #10 +                                                   //
    'frame frame' + #13 + #10 +                                                     //
    'interface interface' + #13 + #10 +                                             //
    'label label' + #13 + #10 +                                                     //
    'node node' + #13 + #10 +                                                       //
    'package package' + #13 + #10 +                                                 //
    'person person' + #13 + #10 +                                                   //
    'queue queue' + #13 + #10 +                                                     //
    'rectangle rectangle' + #13 + #10 +                                             //
    'stack stack' + #13 + #10 +                                                     //
    'storage storage' + #13 + #10 +                                                 //
    'usecase usecase' + #13 + #10 +                                                 //
    'usecase/ "usecase/"' + #13 + #10 +                                             //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_deployment-2.puml  Top' + #13 + #10 +                               //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Deployment Diagram With Group- $THEME theme' + #13 + #10 +               //
    'package "Some Group" {' + #13 + #10 +                                          //
    '  HTTP - [First Component]' + #13 + #10 +                                      //
    '  [Another Component]' + #13 + #10 +                                           //
    '}' + #13 + #10 +                                                               //
    'node "Other Groups" {' + #13 + #10 +                                           //
    '  FTP - [Second Component]' + #13 + #10 +                                      //
    '  [First Component] --> FTP' + #13 + #10 +                                     //
    '}' + #13 + #10 +                                                               //
    'cloud {' + #13 + #10 +                                                         //
    '  [Example 1]' + #13 + #10 +                                                   //
    '}' + #13 + #10 +                                                               //
    'database "MySql" {' + #13 + #10 +                                              //
    '  folder "This is my folder" {' + #13 + #10 +                                  //
    '    [Folder 3]' + #13 + #10 +                                                  //
    '  }' + #13 + #10 +                                                             //
    '  frame "Foo" {' + #13 + #10 +                                                 //
    '    [Frame 4]' + #13 + #10 +                                                   //
    '  }' + #13 + #10 +                                                             //
    '}' + #13 + #10 +                                                               //
    '[Another Component] --> [Example 1]: Some Comment' + #13 + #10 +               //
    '[Example 1] --> [Folder 3]' + #13 + #10 +                                      //
    '[Folder 3] --> [Frame 4]' + #13 + #10 +                                        //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_gantt-1.puml  Top' + #13 + #10 +                                    //
    '@startgantt' + #13 + #10 +                                                     //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                              //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 +            //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 +            //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                           //
    '''_____________________________________________________________' + #13 + #10 +            //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                                 //
    'title Gantt Diagram - $THEME theme' + #13 + #10 +                                         //
    '[Task1] lasts 10 days' + #13 + #10 +                                                      //
    'note bottom' + #13 + #10 +                                                                //
    '  memo1 ...' + #13 + #10 +                                                                //
    '  memo2 ...' + #13 + #10 +                                                                //
    '  explanations1 ...' + #13 + #10 +                                                        //
    '  explanations2 ...' + #13 + #10 +                                                        //
    'end note' + #13 + #10 +                                                                   //
    '[Task2] lasts 4 days' + #13 + #10 +                                                       //
    '[Task1] -> [Task2]' + #13 + #10 +                                                         //
    '[Test  000] lasts 7 days and starts at [Task2]''s end and is 0% complete' + #13 + #10 +   //
    '[Test  025] lasts 7 days and starts at [Task2]''s end and is 25% complete' + #13 + #10 +  //
    '[Test  060] lasts 7 days and starts at [Task2]''s end and is 60% complete' + #13 + #10 +  //
    '[Test  100] lasts 7 days and starts at [Task2]''s end and is 100% complete' + #13 + #10 + //
    '-- Separator title --' + #13 + #10 +                                                      //
    '[M1] happens on 5 days after [Task1]''s end' + #13 + #10 +                                //
    '-- end --' + #13 + #10 +                                                                  //
    '@endgantt' + #13 + #10 +                                                                  //
    '' + #13 + #10 +                                                                           //
    '' + #13 + #10 +                                                                           //
    '' + #13 + #10 +                                                                           //
    '//{qjz}' + #13 + #10 +                                                                    //
    '' + #13 + #10 +                                                                           //
    '//{zjq}' + #13 + #10 +                                                                    //
    '//  Themed_gantt-2.puml  Top' + #13 + #10 +                                               //
    '@startgantt' + #13 + #10 +                                                                //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                              //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 +            //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 +            //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                           //
    '''_____________________________________________________________' + #13 + #10 +            //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                                 //
    'title Gantt Diagram With Calendar - $THEME theme' + #13 + #10 +                           //
    'Project starts the 2020-12-14' + #13 + #10 +                                              //
    'sunday are closed' + #13 + #10 +                                                          //
    '[Task1] lasts 10 days' + #13 + #10 +                                                      //
    'note bottom' + #13 + #10 +                                                                //
    '  memo1 ...' + #13 + #10 +                                                                //
    '  memo2 ...' + #13 + #10 +                                                                //
    '  explanations1 ...' + #13 + #10 +                                                        //
    '  explanations2 ...' + #13 + #10 +                                                        //
    'end note' + #13 + #10 +                                                                   //
    '[Task2] lasts 4 days' + #13 + #10 +                                                       //
    '[Task1] -> [Task2]' + #13 + #10 +                                                         //
    '[Test  000] lasts 7 days and starts at [Task2]''s end and is 0% complete' + #13 + #10 +   //
    '[Test  025] lasts 7 days and starts at [Task2]''s end and is 25% complete' + #13 + #10 +  //
    '[Test  060] lasts 7 days and starts at [Task2]''s end and is 60% complete' + #13 + #10 +  //
    '[Test  100] lasts 7 days and starts at [Task2]''s end and is 100% complete' + #13 + #10 + //
    '-- Separator title --' + #13 + #10 +                                                      //
    '[M1] happens on 5 days after [Task1]''s end' + #13 + #10 +                                //
    '-- end --' + #13 + #10 +                                                                  //
    '@endgantt' + #13 + #10 +                                                                  //
    '' + #13 + #10 +                                                                           //
    '' + #13 + #10 +                                                                           //
    '' + #13 + #10 +                                                                           //
    '//{qjz}' + #13 + #10 +                                                                    //
    '' + #13 + #10 +                                                                           //
    '//{zjq}' + #13 + #10 +                                                                    //
    '//  Themed_json-1.puml  Top' + #13 + #10 +                                                //
    '@startjson' + #13 + #10 +                                                                 //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title JSON Diagram - $THEME theme' + #13 + #10 +                               //
    '{' + #13 + #10 +                                                               //
    '   "fruit":"Apple",' + #13 + #10 +                                             //
    '   "size": "Large",' + #13 + #10 +                                             //
    '   "color": ["Red", "Green"]' + #13 + #10 +                                    //
    '}' + #13 + #10 +                                                               //
    '@endjson' + #13 + #10 +                                                        //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_json-2.puml  Top' + #13 + #10 +                                     //
    '@startjson' + #13 + #10 +                                                      //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title JSON Diagram With Highlight- $THEME theme' + #13 + #10 +                 //
    '#highlight "color" / "0"' + #13 + #10 +                                        //
    '{' + #13 + #10 +                                                               //
    '   "fruit":"Apple",' + #13 + #10 +                                             //
    '   "size": "Large",' + #13 + #10 +                                             //
    '   "color": ["Red", "Green"]' + #13 + #10 +                                    //
    '}' + #13 + #10 +                                                               //
    '@endjson' + #13 + #10 +                                                        //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_mindmap-1.puml  Top' + #13 + #10 +                                  //
    '@startmindmap' + #13 + #10 +                                                   //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Mindmap Diagram - $THEME theme' + #13 + #10 +                            //
    '!DIAGRAM = "mindmap"' + #13 + #10 +                                            //
    '+ OS' + #13 + #10 +                                                            //
    '++ Ubuntu' + #13 + #10 +                                                       //
    '+++ Linux Mint' + #13 + #10 +                                                  //
    '+++ Kubuntu' + #13 + #10 +                                                     //
    '+++ Lubuntu' + #13 + #10 +                                                     //
    '+++ KDE Neon' + #13 + #10 +                                                    //
    '++ LMDE' + #13 + #10 +                                                         //
    '++ SolydXK' + #13 + #10 +                                                      //
    '++ SteamOS' + #13 + #10 +                                                      //
    '++ Raspbian' + #13 + #10 +                                                     //
    '-- Windows 95' + #13 + #10 +                                                   //
    '-- Windows 98' + #13 + #10 +                                                   //
    '-- Windows NT' + #13 + #10 +                                                   //
    '--- Windows 8' + #13 + #10 +                                                   //
    '--- Windows 10' + #13 + #10 +                                                  //
    '@endmindmap' + #13 + #10 +                                                     //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_mindmap-2.puml  Top' + #13 + #10 +                                  //
    '@startmindmap' + #13 + #10 +                                                   //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Mindmap Diagram 2 - $THEME theme' + #13 + #10 +                          //
    '+ root' + #13 + #10 +                                                          //
    '**:right_1.1' + #13 + #10 +                                                    //
    'right_1.2;' + #13 + #10 +                                                      //
    '++ right_2' + #13 + #10 +                                                      //
    'left side' + #13 + #10 +                                                       //
    '-- left_1' + #13 + #10 +                                                       //
    '-- left_2' + #13 + #10 +                                                       //
    '**:left_3.1' + #13 + #10 +                                                     //
    'left_3.2;' + #13 + #10 +                                                       //
    '@endmindmap' + #13 + #10 +                                                     //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_mindmap-3.puml  Top' + #13 + #10 +                                  //
    '@startmindmap' + #13 + #10 +                                                   //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Mindmap Diagram With Boxless - $THEME theme' + #13 + #10 +               //
    '+ root node' + #13 + #10 +                                                     //
    '++ some first level node' + #13 + #10 +                                        //
    '+++_ second level node' + #13 + #10 +                                          //
    '+++_ another second level node' + #13 + #10 +                                  //
    '+++_ foo' + #13 + #10 +                                                        //
    '+++_ bar' + #13 + #10 +                                                        //
    '+++_ foobar' + #13 + #10 +                                                     //
    '++_ another first level node' + #13 + #10 +                                    //
    '-- some first right level node' + #13 + #10 +                                  //
    '--_ another first right level node' + #13 + #10 +                              //
    '@endmindmap' + #13 + #10 +                                                     //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_nwdiag-1.puml  Top' + #13 + #10 +                                   //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Network Diagram - $THEME theme' + #13 + #10 +                            //
    'nwdiag {' + #13 + #10 +                                                        //
    '  network DMZ {' + #13 + #10 +                                                 //
    '      address = "y.x.x.x/24"' + #13 + #10 +                                    //
    '      web01 [address = "y.x.x.1"];' + #13 + #10 +                              //
    '      web02 [address = "y.x.x.2"];' + #13 + #10 +                              //
    '  }' + #13 + #10 +                                                             //
    '   network Internal {' + #13 + #10 +                                           //
    '    web01;' + #13 + #10 +                                                      //
    '    web02;' + #13 + #10 +                                                      //
    '    db01 [address = "w.w.w.z", shape = database];' + #13 + #10 +               //
    '  } ' + #13 + #10 +                                                            //
    '    group {' + #13 + #10 +                                                     //
    '    description = "long group label";' + #13 + #10 +                           //
    '    web01;' + #13 + #10 +                                                      //
    '    web02;' + #13 + #10 +                                                      //
    '    db01;' + #13 + #10 +                                                       //
    '  }' + #13 + #10 +                                                             //
    '}' + #13 + #10 +                                                               //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_object-1.puml  Top' + #13 + #10 +                                   //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Object Diagram - $THEME theme' + #13 + #10 +                             //
    'object Object01' + #13 + #10 +                                                 //
    'object Object02' + #13 + #10 +                                                 //
    'object Object03' + #13 + #10 +                                                 //
    'object Object04' + #13 + #10 +                                                 //
    'object Object05' + #13 + #10 +                                                 //
    'object Object06' + #13 + #10 +                                                 //
    'object Object07' + #13 + #10 +                                                 //
    'object Object08' + #13 + #10 +                                                 //
    'Object08 : name = "Dummy"' + #13 + #10 +                                       //
    'Object08 : id = 123' + #13 + #10 +                                             //
    'Object01 <|-- Object02' + #13 + #10 +                                          //
    'Object03 *-- Object04' + #13 + #10 +                                           //
    'Object05 o-- "4" Object06' + #13 + #10 +                                       //
    'Object07 .. Object08 : some labels' + #13 + #10 +                              //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_object-2.puml  Top' + #13 + #10 +                                   //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Object Diagram 2 - $THEME theme' + #13 + #10 +                           //
    'object user1' + #13 + #10 +                                                    //
    'user1 : name = "Dummy"' + #13 + #10 +                                          //
    'user1 : id = 123' + #13 + #10 +                                                //
    'object user2 {' + #13 + #10 +                                                  //
    '  name = "Dummy"' + #13 + #10 +                                                //
    '  id = 123' + #13 + #10 +                                                      //
    '}' + #13 + #10 +                                                               //
    'object o1' + #13 + #10 +                                                       //
    'object o2' + #13 + #10 +                                                       //
    'diamond dia' + #13 + #10 +                                                     //
    'object o3' + #13 + #10 +                                                       //
    'o1  --> dia' + #13 + #10 +                                                     //
    'o2  "1" --> "1" dia' + #13 + #10 +                                             //
    'dia --> o3' + #13 + #10 +                                                      //
    'object London' + #13 + #10 +                                                   //
    'map CapitalCity {' + #13 + #10 +                                               //
    ' UK *-> London' + #13 + #10 +                                                  //
    ' USA => Washington' + #13 + #10 +                                              //
    ' Germany => Berlin' + #13 + #10 +                                              //
    '}' + #13 + #10 +                                                               //
    'user1 --> CapitalCity : visits >' + #13 + #10 +                                //
    'json json {' + #13 + #10 +                                                     //
    '   "fruit":"Apple",' + #13 + #10 +                                             //
    '   "size": "Large",' + #13 + #10 +                                             //
    '   "color": ["Red", "Green"]' + #13 + #10 +                                    //
    '}' + #13 + #10 +                                                               //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_salt-1.puml  Top' + #13 + #10 +                                     //
    '@startsalt' + #13 + #10 +                                                      //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Salt Diagram - $THEME theme' + #13 + #10 +                               //
    '{+' + #13 + #10 +                                                              //
    '  Just plain text' + #13 + #10 +                                               //
    '  [This is my button]' + #13 + #10 +                                           //
    '  ()  Unchecked radio' + #13 + #10 +                                           //
    '  (X) Checked radio' + #13 + #10 +                                             //
    '  []  Unchecked box' + #13 + #10 +                                             //
    '  [X] Checked box' + #13 + #10 +                                               //
    '  "Enter text here   "' + #13 + #10 +                                          //
    '  ^This is a droplist^' + #13 + #10 +                                          //
    '}' + #13 + #10 +                                                               //
    '@endsalt' + #13 + #10 +                                                        //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_sequence-1.puml  Top' + #13 + #10 +                                 //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Sequence Diagram - $THEME theme' + #13 + #10 +                           //
    'skinparam responseMessageBelowArrow true' + #13 + #10 +                        //
    'autonumber "[000]"' + #13 + #10 +                                              //
    'header Page Header' + #13 + #10 +                                              //
    'footer Page %page% of %lastpage%' + #13 + #10 +                                //
    'actor Foo1' + #13 + #10 +                                                      //
    'boundary Foo2' + #13 + #10 +                                                   //
    'control Foo3' + #13 + #10 +                                                    //
    'entity Foo4' + #13 + #10 +                                                     //
    'database Foo5' + #13 + #10 +                                                   //
    'collections Foo6' + #13 + #10 +                                                //
    'participant Bob << Person >>' + #13 + #10 +                                    //
    'participant Alice << (C,#ADD1B2) Testable >>' + #13 + #10 +                    //
    'box "Internal Service"' + #13 + #10 +                                          //
    '	participant Bob' + #13 + #10 +                                                //
    '	participant Alice' + #13 + #10 +                                              //
    'end box' + #13 + #10 +                                                         //
    '== Initialization ==' + #13 + #10 +                                            //
    'Foo1 -> Foo2 : To boundary' + #13 + #10 +                                      //
    '|||' + #13 + #10 +                                                             //
    'Foo2 -> Foo3 ++: To control' + #13 + #10 +                                     //
    'ref over Foo4, Foo5' + #13 + #10 +                                             //
    '  This can be on' + #13 + #10 +                                                //
    '  several lines' + #13 + #10 +                                                 //
    'end ref' + #13 + #10 +                                                         //
    'Foo3 -> Foo4 : To entity' + #13 + #10 +                                        //
    'Foo4 -> Foo5 : To database' + #13 + #10 +                                      //
    'Foo5 --> Foo3 -- : return' + #13 + #10 +                                       //
    'Foo3 --> Foo2 --: return' + #13 + #10 +                                        //
    '... Some ~~long delay~~ ...' + #13 + #10 +                                     //
    'Foo1 -> Foo6 : To collections' + #13 + #10 +                                   //
    'Foo6 --> Foo4: $success("success")' + #13 + #10 +                              //
    'group alt [successful case]' + #13 + #10 +                                     //
    'Foo1 -> Alice: Authentication Accepted' + #13 + #10 +                          //
    'Alice --> Foo1: success' + #13 + #10 +                                         //
    'note left of Alice: this is a first note' + #13 + #10 +                        //
    'else some kind of failure' + #13 + #10 +                                       //
    '	Foo1 -> Alice: Authentication Failure' + #13 + #10 +                          //
    '    Alice --> Foo1: $failure("Bad request")' + #13 + #10 +                     //
    '	group My own label' + #13 + #10 +                                             //
    '	    loop 1000 times' + #13 + #10 +                                            //
    '	        Alice -> Foo1: DNS Attack' + #13 + #10 +                              //
    '	    end' + #13 + #10 +                                                        //
    '	end' + #13 + #10 +                                                            //
    'else Just a Warning' + #13 + #10 +                                             //
    '   Foo1 -> Alice: $warning("Please repeat")' + #13 + #10 +                     //
    'end' + #13 + #10 +                                                             //
    'note over Foo1, Foo2' + #13 + #10 +                                            //
    'this is a second note' + #13 + #10 +                                           //
    'that is really' + #13 + #10 +                                                  //
    'long' + #13 + #10 +                                                            //
    'end note' + #13 + #10 +                                                        //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_sequence-2.puml  Top' + #13 + #10 +                                 //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Sequence Diagram 2 - $THEME theme' + #13 + #10 +                         //
    'participant Participant as Foo' + #13 + #10 +                                  //
    'actor       Actor       as Foo1' + #13 + #10 +                                 //
    'boundary    Boundary    as Foo2' + #13 + #10 +                                 //
    'control     Control     as Foo3' + #13 + #10 +                                 //
    'entity      Entity      as Foo4' + #13 + #10 +                                 //
    'database    Database    as Foo5' + #13 + #10 +                                 //
    'collections Collections as Foo6' + #13 + #10 +                                 //
    'queue       Queue       as Foo7' + #13 + #10 +                                 //
    'Foo -> Foo1 : To actor ' + #13 + #10 +                                         //
    'Foo -> Foo2 : To boundary' + #13 + #10 +                                       //
    'Foo -> Foo3 : To control' + #13 + #10 +                                        //
    'Foo -> Foo4 : To entity' + #13 + #10 +                                         //
    'Foo -> Foo5 : To database' + #13 + #10 +                                       //
    'Foo -> Foo6 : To collections' + #13 + #10 +                                    //
    'Foo -> Foo7 : To queue' + #13 + #10 +                                          //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_sequence-3.puml  Top' + #13 + #10 +                                 //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Sequence Diagram With Group - $THEME theme' + #13 + #10 +                //
    'Alice -> Bob: Authentication Request' + #13 + #10 +                            //
    'alt successful case' + #13 + #10 +                                             //
    '    Bob -> Alice: Authentication Accepted' + #13 + #10 +                       //
    'else some kind of failure' + #13 + #10 +                                       //
    '    Bob -> Alice: Authentication Failure' + #13 + #10 +                        //
    '    group My own label' + #13 + #10 +                                          //
    '    Alice -> Log : Log attack start' + #13 + #10 +                             //
    '        loop 1000 times' + #13 + #10 +                                         //
    '            Alice -> Bob: DNS Attack' + #13 + #10 +                            //
    '        end' + #13 + #10 +                                                     //
    '    Alice -> Log : Log attack end' + #13 + #10 +                               //
    '    end' + #13 + #10 +                                                         //
    'else Another type of failure' + #13 + #10 +                                    //
    '   Bob -> Alice: Please repeat' + #13 + #10 +                                  //
    'end' + #13 + #10 +                                                             //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_sequence-4.puml  Top' + #13 + #10 +                                 //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Sequence Diagram With TEOZ - $THEME theme' + #13 + #10 +                 //
    '!pragma teoz true' + #13 + #10 +                                               //
    'Alice -> Bob : hello' + #13 + #10 +                                            //
    '& Bob -> Charlie : hi' + #13 + #10 +                                           //
    'group A teoz group' + #13 + #10 +                                              //
    'Alice -> Bob : hello' + #13 + #10 +                                            //
    '& Bob -> Charlie : ha' + #13 + #10 +                                           //
    'end' + #13 + #10 +                                                             //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_state-1.puml  Top' + #13 + #10 +                                    //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title State Diagram - $THEME theme' + #13 + #10 +                              //
    'state fork_state <>' + #13 + #10 +                                             //
    '[*] --> fork_state' + #13 + #10 +                                              //
    'fork_state --> State2' + #13 + #10 +                                           //
    'fork_state --> State3' + #13 + #10 +                                           //
    'state join_state <>' + #13 + #10 +                                             //
    'State2 --> join_state: some message' + #13 + #10 +                             //
    'State3 --> join_state' + #13 + #10 +                                           //
    'join_state --> State4' + #13 + #10 +                                           //
    'State4 --> Active' + #13 + #10 +                                               //
    'state Active {' + #13 + #10 +                                                  //
    '  [*] -> NumLockOff' + #13 + #10 +                                             //
    '  NumLockOff --> NumLockOn : EvNumLockPressed' + #13 + #10 +                   //
    '  NumLockOn --> NumLockOff : EvNumLockPressed' + #13 + #10 +                   //
    '  --' + #13 + #10 +                                                            //
    '  [*] -> CapsLockOff' + #13 + #10 +                                            //
    '  CapsLockOff --> CapsLockOn : EvCapsLockPressed' + #13 + #10 +                //
    '  CapsLockOn --> CapsLockOff : EvCapsLockPressed' + #13 + #10 +                //
    '  --' + #13 + #10 +                                                            //
    '  [*] -> ScrollLockOff' + #13 + #10 +                                          //
    '  ScrollLockOff --> ScrollLockOn : EvCapsLockPressed' + #13 + #10 +            //
    '  ScrollLockOn --> ScrollLockOff : EvCapsLockPressed' + #13 + #10 +            //
    '}' + #13 + #10 +                                                               //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_state-2.puml  Top' + #13 + #10 +                                    //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title State Diagram 2 - $THEME theme' + #13 + #10 +                            //
    'state choice1 <>' + #13 + #10 +                                                //
    'state fork1   <>' + #13 + #10 +                                                //
    'state join2   <>' + #13 + #10 +                                                //
    'state end3    <>' + #13 + #10 +                                                //
    '[*]     --> choice1 : from start\nto choice' + #13 + #10 +                     //
    'choice1 --> fork1   : from choice\nto fork' + #13 + #10 +                      //
    'choice1 --> join2   : from choice\nto join' + #13 + #10 +                      //
    'choice1 --> end3    : from choice\nto end' + #13 + #10 +                       //
    'fork1   ---> State1 : from fork\nto state' + #13 + #10 +                       //
    'fork1   --> State2  : from fork\nto state' + #13 + #10 +                       //
    'State2  --> join2   : from state\nto join' + #13 + #10 +                       //
    'State1  --> [*]     : from state\nto end' + #13 + #10 +                        //
    'join2   --> [*]     : from join\nto end' + #13 + #10 +                         //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_state-3.puml  Top' + #13 + #10 +                                    //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title State Diagram With Point  - $THEME theme' + #13 + #10 +                  //
    'state Somp {' + #13 + #10 +                                                    //
    '  state entry1 <>' + #13 + #10 +                                               //
    '  state entry2 <>' + #13 + #10 +                                               //
    '  state sin' + #13 + #10 +                                                     //
    '  entry1 --> sin' + #13 + #10 +                                                //
    '  entry2 -> sin' + #13 + #10 +                                                 //
    '  sin -> sin2' + #13 + #10 +                                                   //
    '  sin2 --> exitA <>' + #13 + #10 +                                             //
    '}' + #13 + #10 +                                                               //
    '[*] --> entry1' + #13 + #10 +                                                  //
    'exitA --> Foo' + #13 + #10 +                                                   //
    'Foo1 -> entry2' + #13 + #10 +                                                  //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_swimlane-1.puml  Top' + #13 + #10 +                                 //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Swinlane Diagram - $THEME theme' + #13 + #10 +                           //
    '|Actor_For_red|' + #13 + #10 +                                                 //
    'start' + #13 + #10 +                                                           //
    'if (color?) is (red) then' + #13 + #10 +                                       //
    ':**action red**;' + #13 + #10 +                                                //
    ':foo1;' + #13 + #10 +                                                          //
    'else (not red)' + #13 + #10 +                                                  //
    '|Actor_For_no_red|' + #13 + #10 +                                              //
    ':**action not red**;' + #13 + #10 +                                            //
    ':foo2;' + #13 + #10 +                                                          //
    'endif' + #13 + #10 +                                                           //
    '|Next_Actor|' + #13 + #10 +                                                    //
    ':foo3;' + #13 + #10 +                                                          //
    ':foo4;' + #13 + #10 +                                                          //
    '|Final_Actor|' + #13 + #10 +                                                   //
    ':stop;' + #13 + #10 +                                                          //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_timing-1.puml  Top' + #13 + #10 +                                   //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Timing Diagram  - $THEME theme' + #13 + #10 +                            //
    'robust "Web Browser" as WB' + #13 + #10 +                                      //
    'concise "Web User" as WU' + #13 + #10 +                                        //
    'WB is Initializing' + #13 + #10 +                                              //
    'WU is Absent' + #13 + #10 +                                                    //
    '@WB' + #13 + #10 +                                                             //
    '0 is idle' + #13 + #10 +                                                       //
    '+200 is Processing' + #13 + #10 +                                              //
    '+100 is Waiting' + #13 + #10 +                                                 //
    'WB@0 <-> @50 : {50 ms lag}' + #13 + #10 +                                      //
    '@WU' + #13 + #10 +                                                             //
    '0 is Waiting' + #13 + #10 +                                                    //
    '+500 is ok' + #13 + #10 +                                                      //
    '@200 <-> @+150 : {150 ms}' + #13 + #10 +                                       //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_timing-2.puml  Top' + #13 + #10 +                                   //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Timing Diagram 2 - $THEME theme' + #13 + #10 +                           //
    'concise "CDAS_FETCH_EVENT" as CDAS_FETCH_EVENT' + #13 + #10 +                  //
    'concise "jb_2" as jb_2' + #13 + #10 +                                          //
    'concise "LOAD_PERSISTENT_SESSIONS" as LOAD_PERSISTENT_SESSIONS' + #13 + #10 +  //
    'scale 30 as 100 pixels' + #13 + #10 +                                          //
    'title connector.log' + #13 + #10 +                                             //
    '0 is {hidden}' + #13 + #10 +                                                   //
    '@CDAS_FETCH_EVENT' + #13 + #10 +                                               //
    '0 is 80 : db' + #13 + #10 +                                                    //
    '+80 is {-}' + #13 + #10 +                                                      //
    '120 is 95 : db' + #13 + #10 +                                                  //
    '+95 is {-}' + #13 + #10 +                                                      //
    '@jb_2' + #13 + #10 +                                                           //
    '9 is 156 : db' + #13 + #10 +                                                   //
    '+156 is {-}' + #13 + #10 +                                                     //
    '@59 <-> @+96 : 96 (db_rbs)' + #13 + #10 +                                      //
    '@LOAD_PERSISTENT_SESSIONS' + #13 + #10 +                                       //
    '141 is "(n/a)" : db' + #13 + #10 +                                             //
    'highlight 0 to 9 : min' + #13 + #10 +                                          //
    'highlight 141 to 165 : 3 connects\n(max)' + #13 + #10 +                        //
    'highlight 80  to 120 : 1 connect (min)' + #13 + #10 +                          //
    'highlight 215 to 250 ' + #13 + #10 +                                           //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_usecase-1.puml  Top' + #13 + #10 +                                  //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Usecase Diagram - $THEME theme' + #13 + #10 +                            //
    'legend' + #13 + #10 +                                                          //
    'This is my legend' + #13 + #10 +                                               //
    'it can have a long list of stuff here' + #13 + #10 +                           //
    'and it can go on and on and on' + #13 + #10 +                                  //
    'that''s about it' + #13 + #10 +                                                //
    'endlegend' + #13 + #10 +                                                       //
    'left to right direction' + #13 + #10 +                                         //
    'actor customer' + #13 + #10 +                                                  //
    'actor clerk' + #13 + #10 +                                                     //
    'rectangle checkout {' + #13 + #10 +                                            //
    '  customer -- (checkout)' + #13 + #10 +                                        //
    '  (checkout) .> (payment) : include' + #13 + #10 +                             //
    '  (help) .> (checkout) : extends' + #13 + #10 +                                //
    '  (checkout) -- clerk' + #13 + #10 +                                           //
    '}' + #13 + #10 +                                                               //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_usecase-2.puml  Top' + #13 + #10 +                                  //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Usecase Diagram 2 - $THEME theme' + #13 + #10 +                          //
    'left to right direction' + #13 + #10 +                                         //
    'actor Guest as g' + #13 + #10 +                                                //
    'package Professional {' + #13 + #10 +                                          //
    '  actor Chef as c' + #13 + #10 +                                               //
    '  actor "Food Critic" as fc' + #13 + #10 +                                     //
    '}' + #13 + #10 +                                                               //
    'rectangle Restaurant {' + #13 + #10 +                                          //
    '  usecase "Eat Food" as UC1' + #13 + #10 +                                     //
    '  usecase "Pay for Food" as UC2' + #13 + #10 +                                 //
    '  usecase "Drink" as UC3' + #13 + #10 +                                        //
    '  usecase "Review" as UC4' + #13 + #10 +                                       //
    '}' + #13 + #10 +                                                               //
    'fc --> UC4' + #13 + #10 +                                                      //
    'g --> UC1' + #13 + #10 +                                                       //
    'g --> UC2' + #13 + #10 +                                                       //
    'g --> UC3' + #13 + #10 +                                                       //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_usecase-3.puml  Top' + #13 + #10 +                                  //
    '@startuml' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Usecase Diagram With Actor Style- $THEME theme' + #13 + #10 +            //
    'skinparam actorStyle awesome' + #13 + #10 +                                    //
    ':User: --> (Use)' + #13 + #10 +                                                //
    '"Main Admin" as Admin' + #13 + #10 +                                           //
    '"Use the application" as (Use)' + #13 + #10 +                                  //
    'Admin --> (Admin the application)' + #13 + #10 +                               //
    '@enduml' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_wbs-1.puml  Top' + #13 + #10 +                                      //
    '@startwbs' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Work Breakdown Diagram - $THEME theme' + #13 + #10 +                     //
    '!$DIAGRAM = "wbs"' + #13 + #10 +                                               //
    '+ New Job' + #13 + #10 +                                                       //
    '++ Decide on Job Requirements' + #13 + #10 +                                   //
    '+++ Identity gaps' + #13 + #10 +                                               //
    '+++ Review JDs' + #13 + #10 +                                                  //
    '++++ Sign-Up for courses' + #13 + #10 +                                        //
    '++++ Volunteer' + #13 + #10 +                                                  //
    '++++ Reading' + #13 + #10 +                                                    //
    '++- Checklist' + #13 + #10 +                                                   //
    '+++- Responsibilities' + #13 + #10 +                                           //
    '+++- Location' + #13 + #10 +                                                   //
    '++ CV Upload Done' + #13 + #10 +                                               //
    '+++ CV Updated' + #13 + #10 +                                                  //
    '++++ Spelling & Grammar' + #13 + #10 +                                         //
    '++++ Check dates' + #13 + #10 +                                                //
    '---- Skills' + #13 + #10 +                                                     //
    '+++ Recruitment sites chosen' + #13 + #10 +                                    //
    '@endwbs' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_wbs-2.puml  Top' + #13 + #10 +                                      //
    '@startwbs' + #13 + #10 +                                                       //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title Work Breakdown Diagram 2 - $THEME theme' + #13 + #10 +                   //
    '* World' + #13 + #10 +                                                         //
    '** America ' + #13 + #10 +                                                     //
    '***_ Canada ' + #13 + #10 +                                                    //
    '***_ Mexico' + #13 + #10 +                                                     //
    '***_ USA' + #13 + #10 +                                                        //
    '** Europe' + #13 + #10 +                                                       //
    '***_  England' + #13 + #10 +                                                   //
    '***_  Germany' + #13 + #10 +                                                   //
    '***_  Spain' + #13 + #10 +                                                     //
    '@endwbs' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_wire-1.puml  Top' + #13 + #10 +                                     //
    '@startwire' + #13 + #10 +                                                      //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    '* BOX_1 [100x200]' + #13 + #10 +                                               //
    '--' + #13 + #10 +                                                              //
    'move(100,0)' + #13 + #10 +                                                     //
    '* BOX_2 [50x175]' + #13 + #10 +                                                //
    'BOX_1 ->  BOX_2 : abcd' + #13 + #10 +                                          //
    'BOX_1 <-> BOX_2 : abcd' + #13 + #10 +                                          //
    'BOX_1 <-  BOX_2 : abcd' + #13 + #10 +                                          //
    'BOX_1 -   BOX_2 : abcd' + #13 + #10 +                                          //
    'BOX_1 =>  BOX_2 : abcd' + #13 + #10 +                                          //
    'BOX_1 <=> BOX_2 #red : abcd' + #13 + #10 +                                     //
    'BOX_1 <=  BOX_2 : abcd' + #13 + #10 +                                          //
    'BOX_1 =   BOX_2 : abcd' + #13 + #10 +                                          //
    '@endwire' + #13 + #10 +                                                        //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_yaml-1.puml  Top' + #13 + #10 +                                     //
    '@startyaml' + #13 + #10 +                                                      //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title YAML Diagram - $THEME theme' + #13 + #10 +                               //
    'fruit: Apple' + #13 + #10 +                                                    //
    'size: Large' + #13 + #10 +                                                     //
    'color:' + #13 + #10 +                                                          //
    ' - Red' + #13 + #10 +                                                          //
    ' - Green' + #13 + #10 +                                                        //
    '@endyaml' + #13 + #10 +                                                        //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10 +                                                         //
    '' + #13 + #10 +                                                                //
    '//{zjq}' + #13 + #10 +                                                         //
    '//  Themed_yaml-2.puml  Top' + #13 + #10 +                                     //
    '@startyaml' + #13 + #10 +                                                      //
    '!$THEME = %splitstr("amiga~aws-orange~black-knight~bluegray~blueprint~carbon-gray~cerulean~cerulean-outline~cloudscape-design~crt-amber~crt-green~cyborg~cyborg-outline~hacker~lightgray~mars~materia~materia-outline~metal~mimeograph~minty~mono~plain~plain~reddress-darkblue~reddress-darkgreen~reddress-darkorange~reddress-darkred~reddress-lightblue~reddress-lightgreen~reddress-lightorange~reddress-lightred~sandstone~silver~sketchy~sketchy-outline~spacelab~spacelab-white~sunlust~superhero-outline~toy~united~vibrant","~")'
    + #13 + #10 +                                                                   //
    '''To change theme change the index below.  The range is [0..43]' + #13 + #10 + //
    '''VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' + #13 + #10 + //
    '!$THEMEINDEX = 0' + #13 + #10 +                                                //
    '''_____________________________________________________________' + #13 + #10 + //
    '!theme $THEME[$THEMEINDEX]' + #13 + #10 +                                      //
    'title YAML With Highlight - $THEME theme' + #13 + #10 +                        //
    '#highlight "color" / "0"' + #13 + #10 +                                        //
    'fruit: Apple' + #13 + #10 +                                                    //
    'size: Large' + #13 + #10 +                                                     //
    'color:' + #13 + #10 +                                                          //
    ' - Red' + #13 + #10 +                                                          //
    ' - Green' + #13 + #10 +                                                        //
    '@endyaml' + #13 + #10 +                                                        //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '' + #13 + #10 +                                                                //
    '//{qjz}' + #13 + #10;                                                          //

Function GetFileList(sgSourceData: String; out lst: TStringlist): String;
Var
  inPos : Integer;
  Token1: String;
  i     : Integer;
Begin
  Result := '';
  Token1 := '//{zjq}';
  If Trim(sgSourceData) = '' Then
    Exit;
  inPos := Pos(Token1, sgSourceData);
  If inPos = 0 Then
    Exit;
  sgSourceData := Copy(sgSourceData, 1, inPos - 1);
  inPos        := Pos('1  ', sgSourceData);
  If inPos = 0 Then
    Exit;
  sgSourceData := Copy(sgSourceData, inPos, Length(sgSourceData) - inPos + 1);
  lst.clear;
  lst.SetText(PChar(sgSourceData));
  For i := 0 To lst.Count - 1 Do
  Begin
    lst[i] := Copy(lst[i], 5, Length(lst[i]) - 5 + 1);
  End;
  Result := lst.Text;
End;

Procedure GetParts(Source, Token: String; Out Before, After: String; Out found: Boolean; CaseSensitive: Boolean);
Var
  inPos: Integer;
Begin
  Before := '';
  After  := '';
  found  := False;
  If Trim(Token) = '' Then
    Exit;
  If Trim(Source) = '' Then
    Exit;
  If CaseSensitive Then
  Begin
    inPos := Pos(Token, Source);
  End
  Else
  Begin
    inPos := Pos(UpperCase(Token), UpperCase(Source));
  End;
  If inPos <> 0 Then
    found := True;
  Before  := Copy(Source, 1, inPos - 1);
  After   := Copy(Source, inPos + Length(Token), Length(Source) - (inPos + Length(Token)) + 1);
End;

Procedure ParseRaw(Raw: String; Out Ext, FileName, FileBody: String);
Var
  Before: String;
  After : String;
  found : Boolean;
Begin
  Ext      := '';
  FileName := '';
  FileBody := '';
  If Trim(Raw) = '' Then
    Exit;
  GetParts(Raw, '  Top', Before, After, found, True);
  If found Then
  Begin
    FileName := StringReplace(Before, '//', '', [rfReplaceAll]);
    FileName := Trim(FileName);
    Ext      := ExtractFileExt(FileName);
    FileBody := Trim(After);
  End;
End;

function CreateFilesFromText(SourceData, DestPath, Token1, Token2: String; out error: String): Boolean;
Var
  After            : String;
  Before           : String;
  CaseSensitive    : Boolean;
  Ext              : String;
  FileBody         : String;
  FileName         : String;
  found            : Boolean;
  i                : Integer;
  inPos            : Integer;
  lst              : TStringlist;
  sgBefore         : String;
  sgDT             : String;
  sgSource         : String;
  Source           : String;
  TextToDelphiArray: TTextToDelphiArray;
Begin
  Result := False;
  If Trim(SourceData) = '' Then
  Begin
    error := 'SourceData is empty. Aborting!';
    Exit;
  End;
  If Trim(DestPath) = '' Then
  Begin
    error := 'A destination path is needed. Aborting!';
    Exit;
  End;
  If Trim(Token1) = '' Then
  Begin
    error := 'Token1 is empty. Aborting!';
    Exit;
  End;
  If Trim(Token2) = '' Then
  Begin
    error := 'Token2 is empty. Aborting!';
    Exit;
  End;
  // If Not FileExists(SourceFile) Then
  // Begin
  // error:='A source file is needed. ' + SourceFile + ' does not exist. Aborting!';
  // Exit;
  // End;
  If Not System.SysUtils.DirectoryExists(DestPath) Then
  Begin
    error := 'A destination path is needed.  ' + DestPath + ' does not exist. Aborting!';
    Exit;
  End;
  If Pos(Token1, SourceData) = 0 Then
  Begin
    error := 'Token1 was not found in the SourceData. Token1=' + Token1 + '. Aborting!';
    Exit;
  End;
  If Pos(Token2, SourceData) = 0 Then
  Begin
    error := 'Token2 was not found in the SourceData. Token2=' + Token2 + '. Aborting!';
    Exit;
  End;
  SetLength(TextToDelphiArray, 0);
  lst := TStringlist.Create();
  Try
    sgDT := FormatDateTime('YYYYMMDDHHNNSS', now());
    lst.SetText(PChar(SourceData));

    After         := '';
    Before        := '';
    CaseSensitive := True;
    found         := True;
    Source        := lst.Text;
    i := 1;
    SetLength(TextToDelphiArray, 0);
    While found Do
    Begin
      i := i + 1;
      If i > 100 Then
        Break;
      GetParts(Source, Token1, Before, After, found, CaseSensitive);
      sgSource := After;
      If Not found Then
      Begin
        inPos := Pos(Token2, Source);
        If inPos > 0 Then
        Begin
          SetLength(TextToDelphiArray, Length(TextToDelphiArray) + 1);
          GetParts(Source, Token2, Before, After, found, CaseSensitive);
          Source                                         := Trim(Before);
          TextToDelphiArray[High(TextToDelphiArray)].Raw := Source;
          ParseRaw(Source, Ext, FileName, FileBody);
          TextToDelphiArray[High(TextToDelphiArray)].FileExt  := Ext;
          TextToDelphiArray[High(TextToDelphiArray)].FileName := FileName;
          TextToDelphiArray[High(TextToDelphiArray)].FileBody := FileBody;
        End;
        Break;
      End;
      sgBefore := Before;
      inPos    := Pos(Token2, sgBefore);
      If inPos > 0 Then
      Begin
        SetLength(TextToDelphiArray, Length(TextToDelphiArray) + 1);
        GetParts(sgBefore, Token2, Before, After, found, CaseSensitive);
        sgBefore                                       := Trim(Before);
        TextToDelphiArray[High(TextToDelphiArray)].Raw := sgBefore;
        ParseRaw(sgBefore, Ext, FileName, FileBody);
        TextToDelphiArray[High(TextToDelphiArray)].FileExt  := Ext;
        TextToDelphiArray[High(TextToDelphiArray)].FileName := FileName;
        TextToDelphiArray[High(TextToDelphiArray)].FileBody := FileBody;
      End;
      Source := sgSource;
      found  := True;
    End;
    For i := Low(TextToDelphiArray) To High(TextToDelphiArray) Do
    Begin
      StrToFile(TextToDelphiArray[i].FileBody, DestPath + TextToDelphiArray[i].FileName);
    End;
    Result := True;
  Finally
    FreeAndNil(lst);
  End;
End;

Function SaveThemedExamplesToDisk(ExamplesDir: String): Boolean;
Var
  boFilesMissing: Boolean;
  error         : String;
  FileList      : TStringlist;
  i             : Integer;
  ProcName      : String;
  sgMessage     : String;
  sgSourceData  : String;
  Token1        : String;
  Token2        : String;
Begin
  Token1   := '//{zjq}';
  Token2   := '//{qjz}';
  ProcName := 'SaveThemedExamplesToDisk';
  error    := '';
  FileList := TStringlist.Create();
  Try
    {$WARNINGS OFF}
    ExamplesDir  := System.SysUtils.IncludeTrailingBackslash(ExamplesDir);
    {$WARNINGS ON}
    sgSourceData := ThemedExamples;
    GetFileList(sgSourceData, FileList);
    boFilesMissing := Not System.SysUtils.DirectoryExists(ExamplesDir);
    If boFilesMissing Then
      System.SysUtils.ForceDirectories(ExamplesDir);
    If Not boFilesMissing Then
    Begin
      For i := 0 To FileList.Count - 1 Do
      Begin
        If FileExists(ExamplesDir + FileList[i]) Then
          Continue;
        boFilesMissing := True;
        Break;
      End;
    End;

    If boFilesMissing Then
    Begin
      Result := CreateFilesFromText(sgSourceData, ExamplesDir, Token1, Token2, error);
      If error <> '' Then
      Begin
        sgMessage:=error;
        LogMessage(UnitName, ProcName, sgMessage);
      End;
    End
    Else
    Begin
      Result := True;
    End;

  Finally
    FreeAndNil(FileList);
  End;
End;

{ TTextToDelphi }

Function TTextToDelphi.toFile(FileName: String): Boolean;
Var
  sgData: String;
Begin
  sgData := self.toString;
  StrToFile(sgData, FileName);
  Result := True;
End;

Function TTextToDelphi.toString: String;
Begin
  Result := 'FileExt =' + FileExt + #13 + #10 + 'FileName=' + FileName + #13 + #10 + 'FileBody=' + FileBody + #13 + #10 + 'Raw     =' + Raw + #13 + #10;
End;

Function SaveDiagramTypesToDisk(ImagesDir: String): Boolean;
Var
  s: String;
Begin
  Result:=False;
  If FileExists(ImagesDir+'Diagram_Types.txt') Then Exit;
  s:=
    '''''
    !DIAGRAM = "sequence"

    Here are the possible values
    activity
    archimate
    c4 (for C4 model diagrams)
    class
    component
    deployment
    dot (for Graphviz DOT diagrams)
    entity
    er (Entity-Relationship diagrams)
    flowchart
    gantt
    git
    journey
    json
    math (for mathematical diagrams)
    mindmap
    network
    object
    pie
    salt
    sdl (Specification and Description Language)
    sequence
    state
    timing
    tree
    usecase
    venn
    wbs
    wbs (Work Breakdown Structure)
    wireframe
    yaml
    ''''';
  StrToFile(s,DirImages+'Diagram_Types.txt');
  Result:=True;
End;

end.
