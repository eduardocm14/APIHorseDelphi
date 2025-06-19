program ProjAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Data.Win.ADODB,
  uConexao in 'infrastructure\uConexao.pas',
  uTesteConexaoSQLServer in 'infrastructure\uTesteConexaoSQLServer.pas';

begin
  if TTesteConexaoSQLServer.ValidarConexaoSQLServer then
  begin
    THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong retorno');
    end);

    Writeln('Servidor rodando em http://localhost:9000');
    THorse.Listen(9000);
  end;
end.
