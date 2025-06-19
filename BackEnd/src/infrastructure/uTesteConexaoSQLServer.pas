unit uTesteConexaoSQLServer;

interface

uses
  System.SysUtils,
  Data.Win.ADODB,
  Data.DB;

type
  TTesteConexaoSQLServer = class
  public
    class function ValidarConexaoSQLServer: Boolean; static;
  end;

implementation

uses
  uConexao;

{ TTesteConexaoSQLServer }

class function TTesteConexaoSQLServer.ValidarConexaoSQLServer: Boolean;
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;

  try
    if Conexao.GetConnection.Connected then
    begin
      Writeln('Conexão com o banco de dados estabelecida com sucesso!');

      Query := TADOQuery.Create(nil);
      try
        Query.Connection := Conexao.GetConnection;
        Query.SQL.Text := 'SELECT * FROM tarefas'; // ajuste conforme necessário
        Query.Open;

        if not Query.IsEmpty then
          Writeln('Consulta testada com sucesso. Total de registros: ' + IntToStr(Query.RecordCount))
        else
          Writeln('Consulta testada com sucesso, nenhum registro encontrado.');
      finally
        Query.Free;
      end;
    end
    else
      Writeln('Falha na conexão com o banco de dados.');

    Result := Conexao.GetConnection.Connected;
  finally
    FreeAndNil(Conexao);
  end;
end;

end.

