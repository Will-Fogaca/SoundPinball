program SoundPinball;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_form_menu in 'Unit_form_menu.pas' {form_menu},
  Unit_func_procedures in 'Unit_func_procedures.pas',
  Unit_form_game in 'Unit_form_game.pas' {form_game};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tform_menu, form_menu);
  Application.CreateForm(Tform_game, form_game);
  Application.Run;
end.
