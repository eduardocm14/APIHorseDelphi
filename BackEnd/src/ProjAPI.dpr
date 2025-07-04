program ProjAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.CORS,
  Data.Win.ADODB,
  uConexao in 'infrastructure\uConexao.pas',
  uTesteConexaoSQLServer in 'infrastructure\uTesteConexaoSQLServer.pas',
  Horse.GBSwagger,
  Controller.Tarefas in 'controller\Controller.Tarefas.pas',
  uModel.Tarefa in 'model\uModel.Tarefa.pas',
  uTarefa.DAO in 'dao\uTarefa.DAO.pas',
  uModel.Util in 'model\uModel.Util.pas';

begin
  with THorse do
  begin
    Use(HorseSwagger);
    Use(CORS);
  end;

  Writeln('Servidor rodando com Swagger em http://localhost:9000//swagger/doc/html');
  Writeln('API_BASE_URL = http://localhost:9000/v1');
  THorse.Listen(9000);

end.
