program SoundPinball;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_form_menu in 'Unit_form_menu.pas' {form_menu},
  Unit_func_procedures in 'Unit_func_procedures.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tform_menu, form_menu);
  Application.Run;
end.
