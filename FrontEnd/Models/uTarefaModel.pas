unit uTarefaModel;

interface

uses
  System.JSON;

type
  TTarefaModel = class
  public
    ID: string;
    Titulo: string;
    Descricao: string;
    Prioridade: Integer;
    Status: string;
    DataCriacao: string;
    DataConclusao: string;

    function ToJSON: TJSONObject;
    class function FromJSON(AJSON: TJSONObject): TTarefaModel;
  end;

implementation

{ TTarefaModel }

function TTarefaModel.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('Titulo', Titulo);
  Result.AddPair('Descricao', Descricao);
  Result.AddPair('Prioridade', TJSONNumber.Create(Prioridade));
  Result.AddPair('Status', Status);
end;

class function TTarefaModel.FromJSON(AJSON: TJSONObject): TTarefaModel;
begin
  Result := TTarefaModel.Create;
  Result.ID := AJSON.GetValue<string>('ID');
  Result.Titulo := AJSON.GetValue<string>('Titulo');
  Result.Descricao := AJSON.GetValue<string>('Descricao');
  Result.Prioridade := AJSON.GetValue<Integer>('Prioridade');
  Result.Status := AJSON.GetValue<string>('Status');
  Result.DataCriacao := AJSON.GetValue<string>('DataCriacao');
  Result.DataConclusao := AJSON.GetValue<string>('DataConclusao');
end;

end.
