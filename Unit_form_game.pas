unit Unit_form_game;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects;

type
  Tform_game = class(TForm)
    RectAnimation1: TRectAnimation;
    Circle1: TCircle;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_game: Tform_game;

implementation

{$R *.fmx}

end.
