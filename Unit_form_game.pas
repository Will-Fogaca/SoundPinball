unit Unit_form_game;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, System.Math,
  System.Classes, System.Generics.Collections;

type
  Tform_game = class(TForm)
    rect_haste_esquerda: TRectangle;
    rect_haste_direita: TRectangle;
    img_vazio: TImage;
    lbl_vazio: TLabel;
    tmr_game_loop: TTimer;
    tmr_desativar_power: TTimer;
    img_bola_brava: TImage;
    img_espinho_plataforma: TImage;
    rect_start: TRectangle;
    img_start: TImage;
    rect_game_over: TRectangle;
    img_game_over: TImage;
    rect_recomecar: TRectangle;
    lbl_recomecar: TLabel;
    lbl_pontuacao: TLabel;
    tmr_pontuacao: TTimer;
    lbl_result_pontuacao: TLabel;
    cc_1: TCircle;
    cc_2: TCircle;
    cc_4: TCircle;
    cc_5: TCircle;
    rect_1: TRectangle;
    rect_2: TRectangle;
    rect_3: TRectangle;
    cc_3: TCircle;
    rect_4: TRectangle;
    rect_5: TRectangle;
    procedure tmr_game_loopTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tmr_desativar_powerTimer(Sender: TObject);
    procedure rect_haste_esquerdaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rect_haste_direitaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rect_haste_esquerdaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rect_haste_direitaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rect_startClick(Sender: TObject);
    procedure rect_recomecarClick(Sender: TObject);
    procedure tmr_pontuacaoTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    procedure CreatePlatform;
    procedure MovePlataforms;
    procedure CreateSmallBall;
    procedure PosicionarComponentes;
    procedure StartGame;
    procedure GameOver;
  public
    { Public declarations }
  end;

  TDirecao = (cima, baixo, direita, esquerda);

  TBola = class(TCircle)
  private
    velX: Single;
    velY: Single;
    gravity: Single;
    dirX: TDirecao;
    dirY: TDirecao;
    procedure MovimentaBola;
    procedure VerificaColisao;
    procedure VerificaColisaoHastes;
    procedure VerificaColisaoComponentes;
    procedure VerificaPerda;
  public
    constructor Create(aOwner: TComponent); override;
    procedure IniciarMovimento;
  end;

var
  form_game: Tform_game;
  Bola: TBola;
  FPlataformas: TList<TRectangle>;
  directions: array of TPoint;

implementation

{$R *.fmx}

constructor TBola.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  velX := 6;
  velY := 6;
  gravity := 0.10;
  dirX := direita;
  dirY := baixo;

  Width := 30;
  Height := 30;
  Fill.Color := TAlphaColorRec.Blue;
  Stroke.Kind := TBrushKind.None;
  Name := 'Bola';

  IniciarMovimento;
end;

procedure TBola.IniciarMovimento;
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      while (Owner as Tform_game).tmr_game_loop.Enabled do
      begin
        TThread.Synchronize(nil, MovimentaBola);
        Sleep(16);
      end;
    end
  ).Start;
end;

procedure TBola.MovimentaBola;
begin
  form_game.rect_start.Visible := false;

  case dirX of
    direita: Self.Position.X := Self.Position.X + velX;
    esquerda: Self.Position.X := Self.Position.X - velX;
  end;

  case dirY of
    cima:
      begin
        velY := velY - gravity;
        if velY <= 0 then
        begin
          dirY := baixo;
          velY := 0;
        end;
        Self.Position.Y := Self.Position.Y - velY;
      end;
    baixo:
      begin
        velY := velY + gravity;
        Self.Position.Y := Self.Position.Y + velY;
      end;
  end;

  velX := EnsureRange(velX, -10, 10);
  velY := EnsureRange(velY, -10, 10);

  velX := velX * 0.99;
  velY := velY * 0.99;

  VerificaColisao;
  VerificaColisaoHastes;
  VerificaColisaoComponentes;
  VerificaPerda;
end;

procedure TBola.VerificaColisao;
var
  limX, limY: Single;
begin
  limX := (Owner as TForm).ClientWidth - Self.Width;
  limY := (Owner as TForm).ClientHeight - Self.Height;

  if Self.Position.X < 0 then
  begin
    Self.Position.X := 0;
    dirX := direita;
    velX := -velX;
  end;

  if Self.Position.Y < 0 then
  begin
    Self.Position.Y := 0;
    dirY := baixo;
    velY := -velY;
  end;

  if Self.Position.X > limX then
  begin
    Self.Position.X := limX;
    dirX := esquerda;
    velX := -velX;
  end;

  if Self.Position.Y > limY then
  begin
    Self.Position.Y := limY;
    dirY := cima;
    velY := velY / 2;
  end;
end;

procedure TBola.VerificaColisaoHastes;
var
  bolaRect, hasteEsquerdaRect, hasteDireitaRect: TRectF;
  impacto: Single;
begin
  bolaRect := Self.BoundsRect;
  hasteEsquerdaRect := form_game.rect_haste_esquerda.BoundsRect;
  hasteDireitaRect := form_game.rect_haste_direita.BoundsRect;

  if bolaRect.IntersectsWith(hasteEsquerdaRect) then
  begin
    impacto := (Self.Position.X + (Self.Width / 2)) - (form_game.rect_haste_esquerda.Position.X + (form_game.rect_haste_esquerda.Width / 2));
    impacto := impacto / (form_game.rect_haste_esquerda.Width / 2);

    velX := velX + impacto * 2;
    velY := -Abs(velY);

    if form_game.rect_haste_esquerda.RotationAngle < 0 then
      velY := velY * 1.2;

    Exit;
  end;

  if bolaRect.IntersectsWith(hasteDireitaRect) then
  begin
    impacto := (Self.Position.X + (Self.Width / 2)) - (form_game.rect_haste_direita.Position.X + (form_game.rect_haste_direita.Width / 2));
    impacto := impacto / (form_game.rect_haste_direita.Width / 2);

    velX := velX + impacto * 2;
    velY := -Abs(velY);

    if form_game.rect_haste_direita.RotationAngle > 0 then
      velY := velY * 1.2;

    Exit;
  end;
end;

procedure TBola.VerificaColisaoComponentes;
var
  i: Integer;
  componente: TRectangle;
  bolaRect: TRectF;
begin
  bolaRect := Self.BoundsRect;

  for i := 0 to form_game.ComponentCount - 1 do
  begin
    if (form_game.Components[i] is TRectangle) then
    begin
      componente := TRectangle(form_game.Components[i]);

      if componente.Tag = 2 then
      begin
        if bolaRect.IntersectsWith(componente.BoundsRect) then
        begin
          if (bolaRect.Right > componente.BoundsRect.Left) and (bolaRect.Left < componente.BoundsRect.Left) then
          begin
            dirX := esquerda;
          end
          else if (bolaRect.Left < componente.BoundsRect.Right) and (bolaRect.Right > componente.BoundsRect.Right) then
          begin
            dirX := direita;
          end;

          if (bolaRect.Bottom > componente.BoundsRect.Top) and (bolaRect.Top < componente.BoundsRect.Top) then
          begin
            dirY := cima;
          end
          else if (bolaRect.Top < componente.BoundsRect.Bottom) and (bolaRect.Bottom > componente.BoundsRect.Bottom) then
          begin
            dirY := baixo;
          end;

          Exit;
        end;
      end;
    end;
  end;
end;

procedure TBola.VerificaPerda;
begin
  if Self.BoundsRect.IntersectsWith(form_game.img_vazio.BoundsRect) then
  begin
    form_game.GameOver;
    Self.Free;
  end;
end;

procedure Tform_game.StartGame;
var
  img_bola: TImage;
begin
  if Assigned(Bola) then
  begin
    Bola.Free;
    Bola := nil;
  end;

  Bola := TBola.Create(Self);
  Bola.Parent := Self;
  Bola.Position.X := (ClientWidth - Bola.Width) / 2;
  Bola.Position.Y := 100;
  img_bola := TImage.Create(Self);
  img_bola.Parent := Bola;
  img_bola.Bitmap := img_bola_brava.Bitmap;
  img_bola.Align := TAlignLayout.Client;

  tmr_game_loop.Enabled := True;
  tmr_pontuacao.Enabled := true;
end;

procedure Tform_game.GameOver;
begin
  tmr_game_loop.Enabled := False;
  tmr_pontuacao.Enabled := false;
  lbl_result_pontuacao.Text := lbl_pontuacao.Text;

  if Assigned(FPlataformas) then
  begin
    for var plataforma in FPlataformas do
      plataforma.Free;

    FPlataformas.Free;
    FPlataformas := nil;
  end;

  rect_game_over.Visible := true;
end;

procedure Tform_game.MovePlataforms;
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      Randomize;
      while not Application.Terminated do
      begin
        TThread.Synchronize(nil,
          procedure
          var
            plat: TRectangle;
            index: Integer;
          begin
            for index := 0 to FPlataformas.Count - 1 do
            begin
              plat := FPlataformas[index];

              plat.Position.X := plat.Position.X + directions[index].X;
              plat.Position.Y := plat.Position.Y + directions[index].Y;

              if (plat.Position.X <= 0) or (plat.Position.X + plat.Width >= ClientWidth) then
                directions[index].X := -directions[index].X;

              if (plat.Position.Y <= 0) or (plat.Position.Y + plat.Height >= ClientHeight) then
                directions[index].Y := -directions[index].Y;
            end;
          end
        );
        Sleep(25);
      end;
    end
  ).Start;
end;

procedure Tform_game.rect_haste_direitaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  rect_haste_direita.RotationAngle := 30;
end;

procedure Tform_game.rect_haste_direitaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  rect_haste_direita.RotationAngle := -10;
end;

procedure Tform_game.rect_haste_esquerdaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  rect_haste_esquerda.RotationAngle := -30;
end;

procedure Tform_game.rect_haste_esquerdaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  rect_haste_esquerda.RotationAngle := 10;
end;

procedure Tform_game.rect_recomecarClick(Sender: TObject);
begin
  if assigned(Bola) then
  begin
    Bola := nil;
    Bola.Free;
  end;

  rect_game_over.Visible := false;
  rect_start.Visible := true;
end;

procedure Tform_game.rect_startClick(Sender: TObject);
begin
  StartGame;
end;

procedure Tform_game.CreatePlatform;
var
  plataforma: TRectangle;
  i: Integer;
  img_plataforma: TImage;
begin
  if not Assigned(FPlataformas) then
  begin
    FPlataformas := TList<TRectangle>.Create;
    SetLength(directions, 5);

    for i := 0 to 4 do
    begin
      plataforma := TRectangle.Create(Self);
      plataforma.Parent := Self;
      plataforma.Width := 50;
      plataforma.Height := 40;
      plataforma.Tag := 1;
      plataforma.Fill.Kind := TBrushKind.None;
      plataforma.Stroke.Kind := TBrushKind.None;

      plataforma.Position.X := Random(ClientWidth - Trunc(plataforma.Width));
      plataforma.Position.Y := Random(ClientHeight div 2);

      img_plataforma := TImage.Create(Self);
      img_plataforma.Parent := plataforma;
      img_plataforma.Bitmap := img_espinho_plataforma.Bitmap;
      img_plataforma.Align := TAlignLayout.Client;

      FPlataformas.Add(plataforma);

      directions[i] := Point(RandomRange(-2, 3), RandomRange(-2, 3));

      if (directions[i].X = 0) and (directions[i].Y = 0) then
        directions[i] := Point(1, 1);
    end;
  end;
end;

procedure Tform_game.CreateSmallBall;
var
  bolinha: TCircle;
  ballCount: Integer;
  i: Integer;
begin
  ballCount := 0;
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TCircle) and (Components[i].Tag = 2) then
      Inc(ballCount);
  end;

  if ballCount < 8 then
  begin
    bolinha := TCircle.Create(Self);
    bolinha.Parent := Self;
    bolinha.Width := 20;
    bolinha.Height := 20;
    bolinha.Position.X := Random(ClientWidth - Trunc(bolinha.Width));
    bolinha.Position.Y := Random(ClientHeight div 2);
    bolinha.Fill.Color := TAlphaColorRec.Red;
    bolinha.Tag := 2;
  end;
end;

procedure Tform_game.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form_game := nil;
  form_game.Free;
end;

procedure Tform_game.FormResize(Sender: TObject);
begin
  PosicionarComponentes;
end;

procedure Tform_game.PosicionarComponentes;
var
  hasteWidth: Single;
  hasteHeight: Single;
  margin: Single;
begin
  hasteWidth := Width * 0.37;
  hasteHeight := 20;
  margin := 10;

  rect_haste_esquerda.Width := hasteWidth;
  rect_haste_esquerda.Height := hasteHeight;
  rect_haste_esquerda.Position.X := margin;
  rect_haste_esquerda.Position.Y := ClientHeight - rect_haste_esquerda.Height - margin - img_vazio.Height - 20;

  rect_haste_direita.Width := hasteWidth;
  rect_haste_direita.Height := hasteHeight;
  rect_haste_direita.Position.X := ClientWidth - rect_haste_direita.Width - margin;
  rect_haste_direita.Position.Y := ClientHeight - rect_haste_direita.Height - margin - img_vazio.Height - 20;
end;

procedure Tform_game.tmr_game_loopTimer(Sender: TObject);
begin
  CreateSmallBall;
  if rect_start.Visible then
    rect_start.Visible := false;
end;

procedure Tform_game.tmr_pontuacaoTimer(Sender: TObject);
var
  pontuacao: Integer;
begin
  pontuacao := StrToInt(lbl_pontuacao.Text);
  pontuacao := pontuacao + 2;
  lbl_pontuacao.Text := IntToStr(pontuacao);
end;

procedure Tform_game.tmr_desativar_powerTimer(Sender: TObject);
begin
  PosicionarComponentes;
  tmr_desativar_power.Enabled := False;
end;

end.

