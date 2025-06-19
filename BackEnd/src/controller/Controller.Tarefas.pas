unit Controller.Tarefas;

interface

uses
  Horse,
  System.SysUtils,
  System.Classes,
  System.JSON,
  Horse.GBSwagger.Register,
  Horse.GBSwagger.Controller,
  GBSwagger.Path.Attributes,
  uModel.Tarefa;

type
  [SwagPath('v1', 'tarefas')]
  TControllerTarefa = class(THorseGBSwagger)
  public
    [SwagGET('tarefas', 'Listar todas as tarefas')]
    [SwagResponse(200, TTarefaModel, 'Retorno com sucesso')]
    procedure DoListTarefas;
  end;

implementation

uses
  uTarefa.DAO,
  Horse.Request,
  Horse.Response;

{ TControllerTarefas }

procedure TControllerTarefa.DoListTarefas;
var
  Lista: TJSONArray;
begin
  try
    Lista := TTarefasDAO.ListarTodas;
    FResponse
      .ContentType('application/json')  // Define o header correto
      .Send(Lista.ToJSON);              // Envia o JSON como texto
  except
    on E: Exception do
      FResponse
        .Status(500)
        .ContentType('application/json')
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

initialization
  THorseGBSwaggerRegister.RegisterPath(TControllerTarefa);

end.

