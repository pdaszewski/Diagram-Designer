{
Cały projekt musi trafić do przebudowy.
Jest nowy z 2018 roku i warto zastosować w nim dobre praktyki projektowania i czystego kodu.
}

program StatusDiagramDesigner;

uses
  Vcl.Forms,
  DiagramDev_frm in 'DiagramDev_frm.pas' {DiagramDev},
  DiagramPowiazanie_frm in 'DiagramPowiazanie_frm.pas' {DiagramPowiazanie},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Projektowanie diagramu statusów';
  Application.CreateForm(TDiagramDev, DiagramDev);
  Application.CreateForm(TDiagramPowiazanie, DiagramPowiazanie);
  Application.Run;
end.
