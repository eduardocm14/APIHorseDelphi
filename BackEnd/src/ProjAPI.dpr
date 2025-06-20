program ProjAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Data.Win.ADODB,
  uConexao in 'infrastructure\uConexao.pas',
  uTesteConexaoSQLServer in 'infrastructure\uTesteConexaoSQLServer.pas',
  Horse.GBSwagger,
  Controller.Tarefas in 'controller\Controller.Tarefas.pas',
  uModel.Tarefa in 'model\uModel.Tarefa.pas',
  uTarefa.DAO in 'dao\uTarefa.DAO.pas',
  uModel.Util in 'model\uModel.Util.pas';

begin
  THorse.
        Use(HorseSwagger);

  Writeln('Servidor rodando com Swagger em http://localhost:9000//swagger/doc/html');
  THorse.Listen(9000);

end.
