﻿{
Cały projekt musi trafić do przebudowy.
Jest nowy z 2018 roku i warto zastosować w nim dobre praktyki projektowania i czystego kodu.
}

program StatusDiagramDesigner;

uses
  Vcl.Forms,
  DiagramDev_frm in 'DiagramDev_frm.pas' {DiagramDev},
  DiagramRelationship_frm in 'DiagramRelationship_frm.pas' {DiagramPowiazanie},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Projektowanie diagramu statusów';
  Application.CreateForm(TDiagramDev, DiagramDev);
  Application.CreateForm(TDiagramRelationship, DiagramRelationship);
  Application.Run;
end.
