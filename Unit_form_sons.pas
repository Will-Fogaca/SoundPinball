unit Unit_form_sons;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Media;

type
  Tform_sons = class(TForm)
    mp_Iniciar: TMediaPlayer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_sons: Tform_sons;

implementation

{$R *.fmx}

end.
