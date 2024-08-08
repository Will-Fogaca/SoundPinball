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
  // Use um caminho relativo ao diret�rio do execut�vel
  FullPath := TPath.Combine(ExtractFilePath(ParamStr(0)), nomeSom);

  if FileExists(FullPath) then
  begin
    MediaPlayer.FileName := FullPath;
    MediaPlayer.Play;
  end
  else
    ShowMessage('Arquivo de som n�o encontrado: ' + FullPath);
end;
end.
