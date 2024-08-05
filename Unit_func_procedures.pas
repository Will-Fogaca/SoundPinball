unit Unit_func_procedures;

interface

uses
  FMX.Media;

procedure EmitirSom(MediaPlayer: TMediaPlayer; nomeSom: String);



implementation

uses
  FMX.Dialogs, System.SysUtils, System.IOUtils;

procedure EmitirSom(MediaPlayer: TMediaPlayer; nomeSom: String);
var
  FullPath: string;
begin
  {$IF DEFINED(MSWINDOWS)}
    FullPath := TPath.Combine(ExtractFilePath(ParamStr(0)), TPath.Combine('Sons', nomeSom));
  {$ELSE}
    FullPath := TPath.Combine(TPath.GetDocumentsPath, TPath.Combine('Sons', nomeSom));
  {$ENDIF}
  if FileExists(FullPath) then
  begin
    MediaPlayer.FileName := FullPath;
    MediaPlayer.Play;
  end
  else
    ShowMessage('Arquivo de som não encontrado: ' + FullPath);
end;
end.
