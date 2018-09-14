unit DiagramPowiazanie_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TDiagramPowiazanie = class(TForm)
    pnl_wzor: TPanel;
    Panel1: TPanel;
    cbox_nazwy: TComboBox;
    btn_dodaj_powiazanie: TButton;
    Image1: TImage;
    Image2: TImage;
    cbox_od: TCheckBox;
    cbox_do: TCheckBox;
    procedure btn_dodaj_powiazanieClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DiagramPowiazanie: TDiagramPowiazanie;

implementation

{$R *.dfm}

uses DiagramDev_frm;

procedure TDiagramPowiazanie.btn_dodaj_powiazanieClick(Sender: TObject);
var
  panel1_status: string;
  panel2_status: string;
  index_panelu_od: Integer;
  index_panelu_do: Integer;
  i: Integer;
  czy_znaleziono: Boolean;
  pozycja_powiazania: Integer;
begin
 if (cbox_nazwy.Text<>'') and (pnl_wzor.Caption<>'') then
  Begin
   panel1_status:=pnl_wzor.Caption;
   panel2_status:=cbox_nazwy.Text;
   index_panelu_od:=0;
   index_panelu_do:=0;
   for i := 1 to DiagramDev.max_obiektow do
    Begin
     if Assigned(DiagramDev.diagram[i].panel) then
      Begin
       if DiagramDev.diagram[i].panel.Caption=panel1_status then index_panelu_od:=DiagramDev.diagram[i].id_obiektu;
      End;
    End;
  for i := 1 to DiagramDev.max_obiektow do
    Begin
     if Assigned(DiagramDev.diagram[i].panel) then
      Begin
       if DiagramDev.diagram[i].panel.Caption=panel2_status then index_panelu_do:=DiagramDev.diagram[i].id_obiektu;
      End;
    End;

   czy_znaleziono := False;
   pozycja_powiazania:=0;
   for i := 1 to DiagramDev.max_powiazan do
    Begin
     if (DiagramDev.Powiazania[i].od_obiektu=index_panelu_od) AND (DiagramDev.Powiazania[i].do_obiektu=index_panelu_do) then
      Begin
       czy_znaleziono:=True;
       pozycja_powiazania:=i;
      End;
     if (DiagramDev.Powiazania[i].od_obiektu=index_panelu_do) AND (DiagramDev.Powiazania[i].do_obiektu=index_panelu_od) then
      Begin
       czy_znaleziono:=True;
       pozycja_powiazania:=i;
      End;
     if (czy_znaleziono=False) AND (pozycja_powiazania=0) AND (DiagramDev.Powiazania[i].od_obiektu=0) then
      Begin
       pozycja_powiazania:=i;
      End;
    End;

   if pozycja_powiazania>0 then
    Begin
     if (cbox_od.Checked) and (cbox_do.Checked=False) then
      Begin
       //To jest ten specyficzny przypadek, gdy uzytkownik celowo zamienia kolejnoœæ powi¹zania.
       DiagramDev.Powiazania[pozycja_powiazania].od_obiektu:=index_panelu_do;
       DiagramDev.Powiazania[pozycja_powiazania].do_obiektu:=index_panelu_od;
       if cbox_od.Checked then DiagramDev.Powiazania[pozycja_powiazania].do_strzalka:=True else DiagramDev.Powiazania[pozycja_powiazania].do_strzalka:=False;
       if cbox_do.Checked then DiagramDev.Powiazania[pozycja_powiazania].od_strzalka:=True else DiagramDev.Powiazania[pozycja_powiazania].od_strzalka:=False;
      End
     else
      Begin
       DiagramDev.Powiazania[pozycja_powiazania].od_obiektu:=index_panelu_od;
       DiagramDev.Powiazania[pozycja_powiazania].do_obiektu:=index_panelu_do;
       if cbox_od.Checked then DiagramDev.Powiazania[pozycja_powiazania].od_strzalka:=True else DiagramDev.Powiazania[pozycja_powiazania].od_strzalka:=False;
       if cbox_do.Checked then DiagramDev.Powiazania[pozycja_powiazania].do_strzalka:=True else DiagramDev.Powiazania[pozycja_powiazania].do_strzalka:=False;
       if (cbox_od.Checked) and (cbox_do.Checked) then
        Begin
         pozycja_powiazania:=pozycja_powiazania+1;
         DiagramDev.Powiazania[pozycja_powiazania].od_obiektu:=index_panelu_do;
         DiagramDev.Powiazania[pozycja_powiazania].do_obiektu:=index_panelu_od;
        End;
      End;
    End;

   Close;
   DiagramDev.Rysuj_powiazania;
  End;
end;

end.
