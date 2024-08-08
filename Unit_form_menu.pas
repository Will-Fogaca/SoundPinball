unit Unit_form_menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Media, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  Tform_menu = class(TForm)
    lay_centro: TRectangle;
    rect_iniciar: TRectangle;
    mp_Menu: TMediaPlayer;
    lbl_iniciar: TLabel;
    img_iniciar: TImage;
    rect_suporte: TRectangle;
    lbl_suporte: TLabel;
    img_suporte: TImage;
    rect_historico: TRectangle;
    lbl_historico: TLabel;
    img_historico: TImage;
    lay_logo: TLayout;
    img_logo_eduvale: TImage;
    lay_topo: TLayout;
    lbl_titulo: TLabel;
    img_logo_game: TImage;
    procedure rect_iniciarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_menu: Tform_menu;

implementation

{$R *.fmx}

uses Unit_func_procedures, Unit_form_sons, Unit_form_game;

procedure Tform_menu.rect_iniciarClick(Sender: TObject);
begin
  EmitirSom(mp_Menu, 'GameStart.mp3');
  if not Assigned(form_game) then
    form_game := Tform_game.Create(Application);

  form_game.Show;
end;

end.
