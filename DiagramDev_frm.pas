unit DiagramDev_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.ComCtrls, Vcl.ExtDlgs, Vcl.Imaging.pngimage, Vcl.Themes, Vcl.AppEvnts;

type
  obiekt = record
    id_obiektu: Integer;
    panel: TPanel;
  end;

type
  powiazanie = record
    od_obiektu: Integer;
    do_obiektu: Integer;
    od_strzalka: Boolean;
    do_strzalka: Boolean;
  end;

type
  TDiagramDev = class(TForm)
    pnl_wzor: TPanel;
    PopupMenuPanelu: TPopupMenu;
    Zmienazw1: TMenuItem;
    MainMenu1: TMainMenu;
    Diagram1: TMenuItem;
    pnl_narzedzia: TPanel;
    btn_nowy: TButton;
    Zamknij1: TMenuItem;
    Nowy1: TMenuItem;
    Dodajpowizanie1: TMenuItem;
    Narzdzia1: TMenuItem;
    chkPositionRunTime: TMenuItem;
    N1: TMenuItem;
    Usupowizaniategoobiektu1: TMenuItem;
    Zapiszdopliku1: TMenuItem;
    SaveDialog: TSaveDialog;
    N2: TMenuItem;
    StatusBar1: TStatusBar;
    Wczytajdiagramzpliku1: TMenuItem;
    OpenDialog: TOpenDialog;
    SavePictureDialog: TSavePictureDialog;
    N3: TMenuItem;
    EksportujdiagramdoplikuPNG1: TMenuItem;
    AlphaBlend1: TMenuItem;
    CarbonStyle1: TMenuItem;
    N4: TMenuItem;
    AutoRefresh: TTimer;
    ApplicationEvents1: TApplicationEvents;
    Usuobiekt1: TMenuItem;
    N5: TMenuItem;
    cbox_zadaj_nazwy: TMenuItem;
    N6: TMenuItem;
    Szukajniepowizanychobiektw1: TMenuItem;
    procedure pnl_wzorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnl_wzorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnl_wzorMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btn_nowyClick(Sender: TObject);
    procedure Zmienazw1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Czysc_tablice;

    procedure Rysuj_powiazanie(od_obiektu, do_obiektu: Integer;
      od_strzalka, do_strzalka: Boolean);
    procedure Rysuj_powiazania;
    function Ile_powiazan(id_obiektu: Integer): Integer;
    function Ktore_to_powiazanie(id_obiektu, id_obiektu_od,
      id_obiektu_do: Integer): Integer;
    function ID_obiektu_z_nazwy(nazwa_statusu: String): Integer;

    procedure Zamknij1Click(Sender: TObject);
    procedure Nowy1Click(Sender: TObject);
    procedure Dodajpowizanie1Click(Sender: TObject);
    procedure chkPositionRunTimeClick(Sender: TObject);
    procedure Usupowizaniategoobiektu1Click(Sender: TObject);
    procedure Zapiszdopliku1Click(Sender: TObject);
    procedure Wczytajdiagramzpliku1Click(Sender: TObject);
    procedure EksportujdiagramdoplikuPNG1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AlphaBlend1Click(Sender: TObject);
    procedure CarbonStyle1Click(Sender: TObject);
    procedure AutoRefreshTimer(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Usuobiekt1Click(Sender: TObject);
    procedure Szukajniepowizanychobiektw1Click(Sender: TObject);
  private
  Var
    fdefaultStyleName: String;
    inReposition: Boolean;
    oldPos: TPoint;
    wybrany_panel: Integer;
  public const
    max_obiektow = 200;
    max_powiazan = 1000;

  Var
    Diagram: array [1 .. max_obiektow] of obiekt;
    Powiazania: array [1 .. max_powiazan] of powiazanie;
  end;

const
  wersja = '0.7.0.2';

var
  DiagramDev: TDiagramDev;
  ostatni_obiekt: Integer;

implementation

{$R *.dfm}

uses DiagramRelationship_frm;

procedure TDiagramDev.Czysc_tablice;
var
  i: Integer;
begin
  /// <summary>
  /// Funkcja czyœci nie tylko tablice samych obiektów, ale równie¿ powi¹zañ miêdzy nimi!
  /// Czyszczone tablice: Powiazania i Diagram
  /// </summary>
  if ostatni_obiekt > 0 then
  Begin
    for i := 1 to max_powiazan do
    Begin
      Powiazania[i].od_obiektu := 0;
      Powiazania[i].do_obiektu := 0;
      Powiazania[i].od_strzalka := False;
      Powiazania[i].do_strzalka := False;
    End;

    for i := 1 to max_obiektow do
    Begin
      Diagram[i].panel.Free;
      Diagram[i].panel := nil;
      Diagram[i].id_obiektu := 0;
    End;
    ostatni_obiekt := 0;
  End;

  Rysuj_powiazania;
end;

function TDiagramDev.ID_obiektu_z_nazwy(nazwa_statusu: String): Integer;
var
  wynik: Integer;
  i: Integer;
Begin
  wynik := 0;
  for i := 1 to max_obiektow do
  Begin
    if Assigned(Diagram[i].panel) then
    Begin
      if Diagram[i].panel.Caption = nazwa_statusu then
        wynik := Diagram[i].id_obiektu;
    End;
  End;
  ID_obiektu_z_nazwy := wynik;
End;

function TDiagramDev.Ktore_to_powiazanie(id_obiektu, id_obiektu_od,
  id_obiektu_do: Integer): Integer;
var
  i: Integer;
  wynik: Integer;
  koniec: Boolean;
Begin
  wynik := 0;
  koniec := False;
  for i := 1 to max_powiazan do
  Begin
    if koniec = False then
    Begin
      if (Powiazania[i].od_obiektu = id_obiektu) OR
        ((Powiazania[i].do_obiektu = id_obiektu)) then
        wynik := wynik + 1;
      if (Powiazania[i].od_obiektu = id_obiektu_od) and
        (Powiazania[i].do_obiektu = id_obiektu_do) then
        koniec := True;
    End;
  End;
  Ktore_to_powiazanie := wynik;
End;

function TDiagramDev.Ile_powiazan(id_obiektu: Integer): Integer;
var
  i: Integer;
  wynik: Integer;
Begin
  wynik := 0;
  for i := 1 to max_powiazan do
  Begin
    if (Powiazania[i].do_obiektu = id_obiektu) or
      (Powiazania[i].od_obiektu = id_obiektu) then
      wynik := wynik + 1;
  End;
  Ile_powiazan := wynik;
End;

procedure TDiagramDev.Rysuj_powiazania;
var
  i, o: Integer;
  pnl_od: Integer;
  pnl_do: Integer;
Begin
  DiagramDev.Refresh;
  for i := 1 to max_powiazan do
  Begin
    if Powiazania[i].od_obiektu > 0 then
    Begin
      for o := 1 to max_obiektow do
      Begin
        if Diagram[o].id_obiektu = Powiazania[i].od_obiektu then
          pnl_od := o;
      End;
      for o := 1 to max_obiektow do
      Begin
        if Diagram[o].id_obiektu = Powiazania[i].do_obiektu then
          pnl_do := o;
      End;

      Rysuj_powiazanie(pnl_od, pnl_do, Powiazania[i].od_strzalka,
        Powiazania[i].do_strzalka);
    End;
  End;
End;

procedure TDiagramDev.Rysuj_powiazanie(od_obiektu, do_obiektu: Integer;
  od_strzalka, do_strzalka: Boolean);
var
  od_panelu, do_panelu: TPanel;
  x1, y1: Integer;
  x2, y2: Integer;
  xbase: Integer;
  xLineDelta: Integer;
  xLineUnitDelta: Double;
  xNormalDelta: Integer;
  xNormalUnitDelta: Double;
  ybase: Integer;
  yLineDelta: Integer;
  yLineUnitDelta: Double;
  yNormalDelta: Integer;
  yNormalUnitDelta: Double;
  HeadLength: Integer;
  pion, poziom: String;
  odlegloscX, odlegloscY: Integer;
  ox1, oy1: Integer;
  ox2, oy2: Integer;
  ile_pow_od: Integer;
  ile_pow_do: Integer;
  ktore_od: Integer;
  ktore_do: Integer;
  roznica: Integer;
  max_wys_analizy: Integer;
  lamanie: Integer;
begin
  if (od_strzalka) or (do_strzalka) then
  Begin
    od_panelu := Diagram[od_obiektu].panel;
    do_panelu := Diagram[do_obiektu].panel;

    ile_pow_od := Ile_powiazan(Diagram[od_obiektu].id_obiektu);
    ile_pow_do := Ile_powiazan(Diagram[do_obiektu].id_obiektu);
    ktore_od := Ktore_to_powiazanie(Diagram[od_obiektu].id_obiektu,
      Diagram[od_obiektu].id_obiektu, Diagram[do_obiektu].id_obiektu);
    ktore_do := Ktore_to_powiazanie(Diagram[do_obiektu].id_obiektu,
      Diagram[od_obiektu].id_obiektu, Diagram[do_obiektu].id_obiektu);

    Canvas.Pen.Style := psSolid;

    if wybrany_panel > 0 then
    Begin
      if (od_obiektu = wybrany_panel) or
        ((do_obiektu = wybrany_panel) and (od_strzalka)) then
      Begin
        Canvas.Pen.Color := clRed;
        Canvas.Brush.Color := clRed;
      End
      else
      Begin
        Canvas.Pen.Color := clBlue;
        Canvas.Brush.Color := clBlue;
      End;
    End
    else
    Begin
      Canvas.Pen.Color := clBlue;
      Canvas.Brush.Color := clBlue;
    End;

    Canvas.Pen.Width := 2;
    HeadLength := 8; // pixels

    if od_panelu.Top <= do_panelu.Top then
    Begin
      pion := 'D';
      odlegloscY := (do_panelu.Top - (od_panelu.Top + od_panelu.Height)) div 2;
    end
    else
    Begin
      pion := 'G';
      odlegloscY := (od_panelu.Top - (do_panelu.Top + do_panelu.Height)) div 2;
    End;

    if od_panelu.Left <= do_panelu.Left then
    Begin
      poziom := 'P';
      odlegloscX := (do_panelu.Left - od_panelu.Left) div 2;
    end
    else
    Begin
      poziom := 'L';
      odlegloscX := (od_panelu.Left - do_panelu.Left) div 2;
    End;

    if pion = 'G' then
    Begin
      x1 := (od_panelu.Left + (od_panelu.Width div 2)) + (ktore_od * 10);
      y1 := od_panelu.Top;

      x2 := (do_panelu.Left + (do_panelu.Width div 2)) + (ktore_do * 10);
      y2 := do_panelu.Top + do_panelu.Height;
    End;
    if pion = 'D' then
    Begin
      x1 := (od_panelu.Left + (od_panelu.Width div 2)) + (ktore_od * 10);
      y1 := od_panelu.Top + od_panelu.Height;

      x2 := (do_panelu.Left + (do_panelu.Width div 2)) + (ktore_do * 10);
      y2 := do_panelu.Top;
    End;

    max_wys_analizy := od_panelu.Height;
    if do_panelu.Height > od_panelu.Height then
      max_wys_analizy := do_panelu.Height;

    roznica := ABS(od_panelu.Top - do_panelu.Top);
    if roznica < (max_wys_analizy + (HeadLength * 2)) then
      lamanie := 3
    else
      lamanie := 2;

    Canvas.MoveTo(x1, y1);

    if lamanie = 2 then
    Begin
      if pion = 'G' then
      Begin
        Canvas.LineTo(x1, y1 - odlegloscY);
        ox1 := x1;
        oy1 := y1 - odlegloscY;
        Canvas.LineTo(x2, y1 - odlegloscY);
        ox2 := x2;
        oy2 := y1 - odlegloscY;
        Canvas.LineTo(x2, y2);
      End;
      if pion = 'D' then
      Begin
        Canvas.LineTo(x1, y1 + odlegloscY);
        ox1 := x1;
        oy1 := y1 + odlegloscY;
        Canvas.LineTo(x2, y1 + odlegloscY);
        ox2 := x2;
        oy2 := y1 + odlegloscY;
        Canvas.LineTo(x2, y2);
      End;
    End;

    if lamanie = 3 then
    Begin
      if pion = 'G' then
      Begin
        y2 := do_panelu.Top;
        Canvas.LineTo(x1, y2 - (HeadLength * 2));
        ox1 := x1;
        oy1 := y2 - (HeadLength * 2);
        Canvas.LineTo(x2, y2 - (HeadLength * 2));
        ox2 := x2;
        oy2 := y2 - (HeadLength * 2);
        Canvas.LineTo(x2, y2);
      End;
      if pion = 'D' then
      Begin
        y2 := do_panelu.Top + do_panelu.Height;
        Canvas.LineTo(x1, y2 + (HeadLength * 2));
        ox1 := x1;
        oy1 := y2 + (HeadLength * 2);
        Canvas.LineTo(x2, y2 + (HeadLength * 2));
        ox2 := x2;
        oy2 := y2 + (HeadLength * 2);
        Canvas.LineTo(x2, y2);
      End;
    End;

    // ========================================================================================
    if do_strzalka then
    Begin
      xLineDelta := x2 - ox2;
      yLineDelta := y2 - oy2;

      xLineUnitDelta := xLineDelta / SQRT(SQR(xLineDelta) + SQR(yLineDelta));
      yLineUnitDelta := yLineDelta / SQRT(SQR(xLineDelta) + SQR(yLineDelta));

      xbase := x2 - ROUND(HeadLength * xLineUnitDelta);
      ybase := y2 - ROUND(HeadLength * yLineUnitDelta);

      xNormalDelta := yLineDelta;
      yNormalDelta := -xLineDelta;
      xNormalUnitDelta := xNormalDelta /
        SQRT(SQR(xNormalDelta) + SQR(yNormalDelta));
      yNormalUnitDelta := yNormalDelta /
        SQRT(SQR(xNormalDelta) + SQR(yNormalDelta));

      Canvas.Polygon([Point(x2, y2),
        Point(xbase + ROUND(HeadLength * xNormalUnitDelta),
        ybase + ROUND(HeadLength * yNormalUnitDelta)),
        Point(xbase - ROUND(HeadLength * xNormalUnitDelta),
        ybase - ROUND(HeadLength * yNormalUnitDelta))]);
    End;

    // ========================================================================================
    if od_strzalka then
    Begin
      xLineDelta := x1 - ox1;
      yLineDelta := y1 - oy1;

      xLineUnitDelta := xLineDelta / SQRT(SQR(xLineDelta) + SQR(yLineDelta));
      yLineUnitDelta := yLineDelta / SQRT(SQR(xLineDelta) + SQR(yLineDelta));

      xbase := x1 - ROUND(HeadLength * xLineUnitDelta);
      ybase := y1 - ROUND(HeadLength * yLineUnitDelta);

      xNormalDelta := yLineDelta;
      yNormalDelta := -xLineDelta;
      xNormalUnitDelta := xNormalDelta /
        SQRT(SQR(xNormalDelta) + SQR(yNormalDelta));
      yNormalUnitDelta := yNormalDelta /
        SQRT(SQR(xNormalDelta) + SQR(yNormalDelta));

      // Draw the arrow tip
      Canvas.Polygon([Point(x1, y1),
        Point(xbase + ROUND(HeadLength * xNormalUnitDelta),
        ybase + ROUND(HeadLength * yNormalUnitDelta)),
        Point(xbase - ROUND(HeadLength * xNormalUnitDelta),
        ybase - ROUND(HeadLength * yNormalUnitDelta))]);
    End;
    // ========================================================================================
  end;
end;

procedure TDiagramDev.Szukajniepowizanychobiektw1Click(Sender: TObject);
var
  o, i: Integer;
  id_obiektu: Integer;
  czy_znaleziono: Boolean;
  czy_znaleziono_niepowiazane: Boolean;
begin
  czy_znaleziono_niepowiazane := False;
  for o := 1 to max_obiektow do
  Begin
    if Assigned(Diagram[o].panel) then
    Begin
      id_obiektu := Diagram[o].id_obiektu;
      czy_znaleziono := False;
      for i := 1 to max_powiazan do
      Begin
        if (Powiazania[i].od_obiektu = id_obiektu) or
          (Powiazania[i].do_obiektu = id_obiektu) then
          czy_znaleziono := True;
      End;

      if czy_znaleziono then
        Diagram[o].panel.Color := pnl_wzor.Color
      else
      Begin
        Diagram[o].panel.Color := clRed;
        czy_znaleziono_niepowiazane := True;
      End;
    End;
  End;

  if czy_znaleziono_niepowiazane = True then
    ShowMessage('UWAGA!!!' + #13 +
      'Znaleziono i oznaczono obiekty niepowi¹zane!')
  else
    ShowMessage('Struktura spójna!' + #13 + 'Wszystko OK!');
end;

procedure TDiagramDev.Usuobiekt1Click(Sender: TObject);
var
  status: string;
  i: Integer;
  index_obiektu: Integer;
begin
  status := (PopupMenuPanelu.PopupComponent as TPanel).Caption;

  for i := 1 to max_obiektow do
  Begin
    if Assigned(Diagram[i].panel) then
    Begin
      if Diagram[i].panel.Caption = status then
      Begin
        index_obiektu := Diagram[i].id_obiektu;
        Diagram[i].id_obiektu := 0;
        Diagram[i].panel.Free;
        Diagram[i].panel := nil;
      End;
    End;
  End;

  for i := 1 to max_powiazan do
  Begin
    if (Powiazania[i].od_obiektu = index_obiektu) or
      (Powiazania[i].do_obiektu = index_obiektu) then
    Begin
      Powiazania[i].od_obiektu := 0;
      Powiazania[i].do_obiektu := 0;
      Powiazania[i].od_strzalka := False;
      Powiazania[i].do_strzalka := False;
    End;
  End;

  Rysuj_powiazania;
end;

procedure TDiagramDev.Usupowizaniategoobiektu1Click(Sender: TObject);
var
  status: string;
  i: Integer;
  index_obiektu: Integer;
begin
  status := (PopupMenuPanelu.PopupComponent as TPanel).Caption;

  for i := 1 to max_obiektow do
  Begin
    if Assigned(Diagram[i].panel) then
    Begin
      if Diagram[i].panel.Caption = status then
        index_obiektu := Diagram[i].id_obiektu;
    End;
  End;

  for i := 1 to max_powiazan do
  Begin
    if (Powiazania[i].od_obiektu = index_obiektu) or
      (Powiazania[i].do_obiektu = index_obiektu) then
    Begin
      Powiazania[i].od_obiektu := 0;
      Powiazania[i].do_obiektu := 0;
      Powiazania[i].od_strzalka := False;
      Powiazania[i].do_strzalka := False;
    End;
  End;

  Rysuj_powiazania;
end;

procedure TDiagramDev.AlphaBlend1Click(Sender: TObject);
begin
  DiagramDev.AlphaBlend := NOT(DiagramDev.AlphaBlend);
  AlphaBlend1.Checked := DiagramDev.AlphaBlend;
  AutoRefresh.Enabled := True;
end;

procedure TDiagramDev.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  AutoRefresh.Enabled := False;
end;

procedure TDiagramDev.AutoRefreshTimer(Sender: TObject);
begin
  AutoRefresh.Enabled := False;
  Rysuj_powiazania;
end;

procedure TDiagramDev.btn_nowyClick(Sender: TObject);
Var
  panel: TPanel;
  nowa_nazwa: string;
  czy_ok: Boolean;
  i: Integer;
  id: String;
begin
  panel := TPanel.Create(DiagramDev);
  panel.Parent := DiagramDev;
  panel.Left := 10;
  panel.Top := 50;
  panel.Width := pnl_wzor.Width;
  panel.Height := pnl_wzor.Height;
  panel.ParentBackground := False;
  panel.OnMouseDown := pnl_wzor.OnMouseDown;
  panel.OnMouseUp := pnl_wzor.OnMouseUp;
  panel.OnMouseMove := pnl_wzor.OnMouseMove;
  panel.BevelKind := pnl_wzor.BevelKind;
  panel.BevelOuter := pnl_wzor.BevelOuter;
  panel.Font.Size := pnl_wzor.Font.Size;
  panel.Font.Style := pnl_wzor.Font.Style;
  panel.Font := pnl_wzor.Font;
  panel.Color := pnl_wzor.Color;
  panel.Cursor := pnl_wzor.Cursor;
  panel.PopupMenu := pnl_wzor.PopupMenu;
  panel.StyleElements := pnl_wzor.StyleElements;
  panel.ShowHint := True;

  if cbox_zadaj_nazwy.Checked then
  Begin
    nowa_nazwa := Trim(InputBox('Nazwa statusu', 'Status: ', panel.Caption));
    czy_ok := True;

    for i := 1 to max_obiektow do
    Begin
      if Assigned(Diagram[i].panel) then
      Begin
        if (panel <> Diagram[i].panel) and
          (Diagram[i].panel.Caption = nowa_nazwa) then
          czy_ok := False;
      End;
    End;

    if czy_ok then
      panel.Caption := nowa_nazwa
    else
      ShowMessage('Podany status ju¿ istnieje!' + #13 +
        'Obiekt zosta³ dodany, ale nale¿y przydzieliæ mu niepowtarzalny status!');
  End;

  ostatni_obiekt := ostatni_obiekt + 1;

  // Tu mo¿emy dodaæ funkcjê wpisywania obiektu do bazy danych i pobierania identyfikatora bazy!
  id := IntToStr(ostatni_obiekt);

  Diagram[ostatni_obiekt].id_obiektu := StrToInt(id);
  Diagram[ostatni_obiekt].panel := panel;
  panel.Hint := 'ID obiektu: ' + id;

  Rysuj_powiazania;
end;

procedure TDiagramDev.CarbonStyle1Click(Sender: TObject);
begin
  CarbonStyle1.Checked := Not(CarbonStyle1.Checked);
  if CarbonStyle1.Checked then
    TStyleManager.TrySetStyle('Carbon')
  else
    TStyleManager.TrySetStyle('Windows');
  AutoRefresh.Enabled := True;
end;

procedure TDiagramDev.chkPositionRunTimeClick(Sender: TObject);
begin
  chkPositionRunTime.Checked := NOT(chkPositionRunTime.Checked);
end;

procedure TDiagramDev.Dodajpowizanie1Click(Sender: TObject);
var
  status: string;
  i: Integer;
begin
  status := Trim((PopupMenuPanelu.PopupComponent as TPanel).Caption);
  if status <> '' then
  Begin
    DiagramRelationship.pnl_wzor.Caption := status;
    DiagramRelationship.cbox_nazwy.Clear;
    for i := 1 to max_obiektow do
    Begin
      if Assigned(Diagram[i].panel) then
      Begin
        if Diagram[i].panel.Caption <> status then
          DiagramRelationship.cbox_nazwy.Items.Add(Diagram[i].panel.Caption);
      End;
    End;
    DiagramRelationship.cbox_od.Checked := False;
    DiagramRelationship.cbox_do.Checked := True;
    DiagramRelationship.Show;
    if DiagramRelationship.cbox_nazwy.Items.Count = 1 then
      DiagramRelationship.cbox_nazwy.ItemIndex := 0;
  End
  else
    ShowMessage('Obiekt musi mieæ zdefiniowan¹ nazwê!');
end;

procedure TDiagramDev.EksportujdiagramdoplikuPNG1Click(Sender: TObject);
var
  Bmp: TBitmap;
  Png: TPngImage;
begin
  if SavePictureDialog.Execute then
  begin
    pnl_narzedzia.Visible := False;
    Application.ProcessMessages;
    Bmp := TBitmap.Create;
    try
      Bmp.SetSize(Canvas.ClipRect.Right, Canvas.ClipRect.Bottom);
      BitBlt(Bmp.Canvas.Handle, 0, 0, Width, Height, Canvas.Handle, 0,
        0, SRCCOPY);
      Png := TPngImage.Create;
      try
        Png.Assign(Bmp);
        Png.SaveToFile(SavePictureDialog.FileName);
      finally
        Png.Free;
      end;
    finally
      Bmp.Free;
    end;
    pnl_narzedzia.Visible := True;
    Application.ProcessMessages;
  end;
end;

procedure TDiagramDev.FormActivate(Sender: TObject);
begin
  Rysuj_powiazania;
end;

procedure TDiagramDev.FormCreate(Sender: TObject);
begin
  Caption := 'Diagram przep³ywu statusów - Wersja: ' + wersja;
  ostatni_obiekt := 0;
  DoubleBuffered := True;
end;

procedure TDiagramDev.FormResize(Sender: TObject);
begin
  Rysuj_powiazania;
end;

procedure TDiagramDev.Nowy1Click(Sender: TObject);
begin
  Czysc_tablice;
end;

procedure TDiagramDev.pnl_wzorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  status: String;
begin
  if (chkPositionRunTime.Checked) AND (Sender is TWinControl) then
  begin
    inReposition := True;
    SetCapture(TWinControl(Sender).Handle);
    GetCursorPos(oldPos);
    status := (Sender as TPanel).Caption;
    wybrany_panel := ID_obiektu_z_nazwy(status);
    Rysuj_powiazania;
  end;
end;

procedure TDiagramDev.pnl_wzorMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
const
  minWidth = 20;
  minHeight = 20;
var
  newPos: TPoint;
  frmPoint: TPoint;
begin
  if inReposition then
  begin
    with TWinControl(Sender) do
    begin
      GetCursorPos(newPos);
      if ssShift in Shift then
      begin // resize
        Screen.Cursor := crSizeNWSE;
        frmPoint := ScreenToClient(Mouse.CursorPos);
        if frmPoint.X > minWidth then
          Width := frmPoint.X;
        if frmPoint.Y > minHeight then
          Height := frmPoint.Y;
      end
      else // move
      begin
        Screen.Cursor := crSize;
        Left := Left - oldPos.X + newPos.X;
        Top := Top - oldPos.Y + newPos.Y;
        oldPos := newPos;
      end;
    end;
    Rysuj_powiazania;
  end;
end;

procedure TDiagramDev.pnl_wzorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if inReposition then
  begin
    Screen.Cursor := crDefault;
    ReleaseCapture;
    inReposition := False;
    wybrany_panel := 0;
    Rysuj_powiazania;
  end;
end;

procedure TDiagramDev.Zamknij1Click(Sender: TObject);
begin
  Close;
end;

procedure TDiagramDev.Wczytajdiagramzpliku1Click(Sender: TObject);
Var
  plik: TStringList;
  linia: String;
  i: Integer;
  id, X, Y, w, h, text: String;
  od_id, do_id, sod, sdo: String;
  panel: TPanel;
  ostatnie_powiazanie: Integer;
begin
  if OpenDialog.Execute then
  Begin
    Czysc_tablice;
    ostatnie_powiazanie := 1;
    plik := TStringList.Create;
    plik.LoadFromFile(OpenDialog.FileName);
    for i := 0 to plik.Count - 1 do
    Begin
      linia := Trim(plik.Strings[i]);
      if linia = '[OBIEKT_BEGIN]' then
      Begin
        id := Trim(StringReplace(plik[i + 1], 'ID=', '',
          [rfReplaceAll, rfIgnoreCase]));
        X := Trim(StringReplace(plik[i + 2], 'X=', '',
          [rfReplaceAll, rfIgnoreCase]));
        Y := Trim(StringReplace(plik[i + 3], 'Y=', '',
          [rfReplaceAll, rfIgnoreCase]));
        w := Trim(StringReplace(plik[i + 4], 'W=', '',
          [rfReplaceAll, rfIgnoreCase]));
        h := Trim(StringReplace(plik[i + 5], 'H=', '',
          [rfReplaceAll, rfIgnoreCase]));
        text := Trim(StringReplace(plik[i + 6], 'TEXT=', '',
          [rfReplaceAll, rfIgnoreCase]));

        panel := TPanel.Create(DiagramDev);
        panel.Parent := DiagramDev;
        panel.Left := StrToInt(X);
        panel.Top := StrToInt(Y);
        panel.Width := StrToInt(w);
        panel.Height := StrToInt(h);
        panel.Caption := text;
        panel.ParentBackground := False;
        panel.OnMouseDown := pnl_wzor.OnMouseDown;
        panel.OnMouseUp := pnl_wzor.OnMouseUp;
        panel.OnMouseMove := pnl_wzor.OnMouseMove;
        panel.BevelKind := pnl_wzor.BevelKind;
        panel.BevelOuter := pnl_wzor.BevelOuter;
        panel.Font.Size := pnl_wzor.Font.Size;
        panel.Font.Style := pnl_wzor.Font.Style;
        panel.Font := pnl_wzor.Font;
        panel.Color := pnl_wzor.Color;
        panel.Cursor := pnl_wzor.Cursor;
        panel.PopupMenu := pnl_wzor.PopupMenu;
        panel.StyleElements := pnl_wzor.StyleElements;
        panel.ShowHint := True;
        panel.Hint := 'ID obiektu: ' + id;

        ostatni_obiekt := ostatni_obiekt + 1;
        Diagram[ostatni_obiekt].id_obiektu := StrToInt(id);
        Diagram[ostatni_obiekt].panel := panel;
      End;

      if linia = '[POWIAZANIE_BEGIN]' then
      Begin
        od_id := Trim(StringReplace(plik[i + 1], 'OD=', '',
          [rfReplaceAll, rfIgnoreCase]));
        do_id := Trim(StringReplace(plik[i + 2], 'DO=', '',
          [rfReplaceAll, rfIgnoreCase]));
        sod := Trim(StringReplace(plik[i + 3], 'SOD=', '',
          [rfReplaceAll, rfIgnoreCase]));
        sdo := Trim(StringReplace(plik[i + 4], 'SDO=', '',
          [rfReplaceAll, rfIgnoreCase]));
        Powiazania[ostatnie_powiazanie].od_obiektu := StrToInt(od_id);
        Powiazania[ostatnie_powiazanie].do_obiektu := StrToInt(do_id);
        Powiazania[ostatnie_powiazanie].od_strzalka := StrToBool(sod);
        Powiazania[ostatnie_powiazanie].do_strzalka := StrToBool(sdo);
        ostatnie_powiazanie := ostatnie_powiazanie + 1;
      End;
    End;
    plik.Free;
    Rysuj_powiazania;
  End;
end;

procedure TDiagramDev.Zapiszdopliku1Click(Sender: TObject);
Var
  plik: TextFile;
  i: Integer;
  czy_zapisac: Boolean;
  wyb: Integer;
begin
  if SaveDialog.Execute then
  Begin
    czy_zapisac := False;
    if FileExists(SaveDialog.FileName) then
    Begin
      wyb := MessageBox(Handle,
        PWideChar('Czy na pewno chcesz zast¹piæ wskazany plik?' + #13 +
        'Istniej¹cy diagram zostanie nadpisany!!!!'), 'Zast¹piæ plik diagramu?',
        MB_YESNO + MB_ICONQUESTION);
      if wyb = mrYes then
        czy_zapisac := True;
    End
    else
      czy_zapisac := True;

    if czy_zapisac then
    Begin
      AssignFile(plik, SaveDialog.FileName);
      Rewrite(plik);
      for i := 1 to max_obiektow do
      Begin
        if Assigned(Diagram[i].panel) then
        Begin
          Writeln(plik, '[OBIEKT_BEGIN]');
          Writeln(plik, 'ID=' + IntToStr(Diagram[i].id_obiektu));
          Writeln(plik, 'X=' + IntToStr(Diagram[i].panel.Left));
          Writeln(plik, 'Y=' + IntToStr(Diagram[i].panel.Top));
          Writeln(plik, 'W=' + IntToStr(Diagram[i].panel.Width));
          Writeln(plik, 'H=' + IntToStr(Diagram[i].panel.Height));
          Writeln(plik, 'TEXT=' + Diagram[i].panel.Caption);
          Writeln(plik, '[OBIEKT_END]');
        End;
      End;
      for i := 1 to max_powiazan do
      Begin
        if Powiazania[i].od_obiektu > 0 then
        Begin
          Writeln(plik, '[POWIAZANIE_BEGIN]');
          Writeln(plik, 'OD=' + IntToStr(Powiazania[i].od_obiektu));
          Writeln(plik, 'DO=' + IntToStr(Powiazania[i].do_obiektu));
          Writeln(plik, 'SOD=' + BoolToStr(Powiazania[i].od_strzalka));
          Writeln(plik, 'SDO=' + BoolToStr(Powiazania[i].do_strzalka));
          Writeln(plik, '[POWIAZANIE_END]');
        End;
      End;
      CloseFile(plik);
      ShowMessage('Diagram poprawnie zapisano do pliku:' + #13 +
        SaveDialog.FileName);
    End;
  End;
end;

procedure TDiagramDev.Zmienazw1Click(Sender: TObject);
var
  nowa_nazwa: string;
  czy_ok: Boolean;
  i: Integer;
begin
  nowa_nazwa := Trim(InputBox('Nazwa statusu', 'Status: ',
    (PopupMenuPanelu.PopupComponent as TPanel).Caption));
  czy_ok := True;

  for i := 1 to max_obiektow do
  Begin
    if Assigned(Diagram[i].panel) then
    Begin
      if ((PopupMenuPanelu.PopupComponent as TPanel) <> Diagram[i].panel) and
        (Diagram[i].panel.Caption = nowa_nazwa) then
        czy_ok := False;
    End;
  End;

  if czy_ok then
    (PopupMenuPanelu.PopupComponent as TPanel).Caption := nowa_nazwa
  else
    ShowMessage('Podany status ju¿ istnieje!');
end;

end.
