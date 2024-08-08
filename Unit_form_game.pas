unit Unit_form_game;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  Tform_game = class(TForm)
    Button1: TButton;
    rect_haste_esquerda: TRectangle;
    rect_haste_direita: TRectangle;
    lay_hastes: TLayout;
    an_haste_esquerda: TFloatAnimation;
    an_haste_direita: TFloatAnimation;
    img_vazio: TImage;
    lbl_vazio: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure rect_haste_esquerdaClick(Sender: TObject);
    procedure rect_haste_direitaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDirecao = (cima, baixo, direita, esquerda);

  TBola = class(TCircle)
  private
    velX: Single;
    velY: Single;
    dirX: TDirecao;
    dirY: TDirecao;
    procedure movimentaBola;
    procedure verificaColisao;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  form_game: Tform_game;

implementation

{$R *.fmx}

constructor TBola.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  // Configura a bola
  velX := 10;
  velY := 10;
  dirX := direita;
  dirY := baixo;

  // Thread an�nima para movimento da bola
  TThread.CreateAnonymousThread(
    procedure
    var
      limX, limY: Single;
      procedure AtualizaPosicao;
      begin
        movimentaBola;
        verificaColisao;

        // Atualiza a posi��o na thread principal
        TThread.Synchronize(nil,
          procedure
          begin
            Self.Position.X := Self.Position.X;
            Self.Position.Y := Self.Position.Y;
          end
        );
      end;
    begin
      limX := (Owner as TForm).ClientWidth - Self.Width;
      limY := (Owner as TForm).ClientHeight - Self.Height;

      repeat
        // Atualiza a posi��o da bola
        AtualizaPosicao;

        // Delay para controlar a taxa de atualiza��o
        Sleep(16); // Aproximadamente 60 FPS
      until False;
    end
  ).Start;
end;

procedure TBola.movimentaBola;
begin
  case dirX of
    direita: Self.Position.X := Self.Position.X + velX;
    esquerda: Self.Position.X := Self.Position.X - velX;
  end;
  case dirY of
    cima: Self.Position.Y := Self.Position.Y - velY;
    baixo: Self.Position.Y := Self.Position.Y + velY;
  end;
end;

procedure TBola.verificaColisao;
var
  limX, limY: Single;
begin
  limX := (Owner as TForm).ClientWidth - Self.Width;
  limY := (Owner as TForm).ClientHeight - Self.Height;

  // Verifica colis�o com as bordas e inverte a dire��o
  if Self.Position.X < 0 then
  begin
    Self.Position.X := 0;
    if dirX = direita then dirX := esquerda else dirX := direita;
  end;

  if Self.Position.Y < 0 then
  begin
    Self.Position.Y := 0;
    if dirY = baixo then dirY := cima else dirY := baixo;
  end;

  if Self.Position.X > limX then
  begin
    Self.Position.X := limX;
    if dirX = direita then dirX := esquerda else dirX := direita;
  end;

  if Self.Position.Y > limY then
  begin
    Self.Position.Y := limY;
    if dirY = baixo then dirY := cima else dirY := baixo;
  end;


  //Verifica colis�o com as hastes


end;

procedure Tform_game.Button1Click(Sender: TObject);
begin
  with TBola.Create(Self) do
  begin
    Parent := Self;
    Position.X := 10;
    Position.Y := 10;
    Width := 30;
    Height := 30;
    Fill.Color := TAlphaColorRec.White;
  end;
end;

procedure Tform_game.rect_haste_direitaClick(Sender: TObject);
begin
  an_haste_direita.Start;
end;

procedure Tform_game.rect_haste_esquerdaClick(Sender: TObject);
begin
  an_haste_esquerda.Start;
end;

end.

