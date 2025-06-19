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
  uTarefa.DAO in 'dao\uTarefa.DAO.pas';

begin
  THorse.
        Use(HorseSwagger);

  THorse.
        Get('tarefas',
        procedure(Req: THorseRequest; Res: THorseResponse)
        begin

        end
        );

  Writeln('Servidor rodando em http://localhost:9000');
  THorse.Listen(9000);

end.
