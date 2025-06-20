unit uTarefa.DAO;

interface

uses
  System.JSON,
  Data.Win.ADODB,
  System.Classes,
  uModel.Tarefa;

type
  TTarefasDAO = class
  public
    class function ListarTodas: TJSONArray;
    class procedure Criar(AJson: TJSONObject);
    class procedure Atualizar(const AID: Integer; const ANovoStatus: string);
    class procedure Remover(AID: Integer);
    class function TotalTarefas: Integer;
    class function MediaPrioridadePendentes: Double;
    class function TarefasConcluidasUltimos7Dias: Integer;
  end;

implementation

uses
  uConexao, System.SysUtils;

class function TTarefasDAO.ListarTodas: TJSONArray;
var
  Conexao: TConexao;
  Query: TADOQuery;
  Arr: TJSONArray;
  Obj: TJSONObject;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  Arr := TJSONArray.Create;
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text := 'SELECT * FROM Tarefas';
    Query.Open;
    while not Query.Eof do
    begin
      Obj := TJSONObject.Create;
      Obj.AddPair('ID', TJSONNumber.Create(Query.FieldByName('ID').AsInteger));
      Obj.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
      Obj.AddPair('Descricao', Query.FieldByName('Descricao').AsString);
      Obj.AddPair('Prioridade', TJSONNumber.Create(Query.FieldByName('Prioridade').AsInteger));
      Obj.AddPair('Status', Query.FieldByName('Status').AsString);
      Obj.AddPair('DataCriacao', Query.FieldByName('DataCriacao').AsString);
      if not Query.FieldByName('DataConclusao').IsNull then
        Obj.AddPair('DataConclusao', Query.FieldByName('DataConclusao').AsString)
      else
        Obj.AddPair('DataConclusao', TJSONNull.Create);
      Arr.AddElement(Obj);
      Query.Next;
    end;
    Result := Arr;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

class procedure TTarefasDAO.Criar(AJson: TJSONObject);
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text :=
      'INSERT INTO Tarefas (Titulo, Descricao, Prioridade, Status) ' +
      'VALUES (:Titulo, :Descricao, :Prioridade, :Status)';
    Query.Parameters.ParamByName('Titulo').Value := AJson.GetValue<string>('Titulo');
    Query.Parameters.ParamByName('Descricao').Value := AJson.GetValue<string>('Descricao');
    Query.Parameters.ParamByName('Prioridade').Value := AJson.GetValue<Integer>('Prioridade');
    Query.Parameters.ParamByName('Status').Value := AJson.GetValue<string>('Status');
    Query.ExecSQL;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

class procedure TTarefasDAO.Atualizar(const AID: Integer; const ANovoStatus: string);
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text := 'UPDATE Tarefas SET Status = :Status WHERE ID = :ID';
    Query.Parameters.ParamByName('Status').Value := ANovoStatus;
    Query.Parameters.ParamByName('ID').Value := AID;
    Query.ExecSQL;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

class procedure TTarefasDAO.Remover(AID: Integer);
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text := 'DELETE FROM Tarefas WHERE ID = :ID';
    Query.Parameters.ParamByName('ID').Value := AID;
    Query.ExecSQL;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

class function TTarefasDAO.TotalTarefas: Integer;
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text := 'SELECT COUNT(*) AS Total FROM Tarefas';
    Query.Open;
    Result := Query.FieldByName('Total').AsInteger;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

class function TTarefasDAO.MediaPrioridadePendentes: Double;
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text := 'SELECT AVG(CAST(Prioridade AS FLOAT)) AS MediaPrioridade ' +
                      'FROM Tarefas WHERE Status = ''Pendente''';
    Query.Open;
    // Retorna 0 se não houver tarefas pendentes
    if Query.FieldByName('MediaPrioridade').IsNull then
      Result := 0
    else
      Result := Query.FieldByName('MediaPrioridade').AsFloat;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

class function TTarefasDAO.TarefasConcluidasUltimos7Dias: Integer;
var
  Conexao: TConexao;
  Query: TADOQuery;
begin
  Conexao := TConexao.Create;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := Conexao.GetConnection;
    Query.SQL.Text := 'SELECT COUNT(*) AS TotalConcluidas ' +
                      'FROM Tarefas ' +
                      'WHERE Status = ''Concluído'' ' +
                      'AND DataConclusao >= DATEADD(day, -7, GETDATE())';
    Query.Open;
    Result := Query.FieldByName('TotalConcluidas').AsInteger;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

end.

