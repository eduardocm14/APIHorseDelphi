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
  GBSwagger.Model.Types,
  uModel.Tarefa,
  Rest.Json,
  Horse.Jhonson,
  uModel.Util;

type
  THTTPStatus = record
  const
    OK = 200;
   	HTTP_CREATED = 201;
    HTTP_NO_CONTENT = 204;
    BAD_REQUEST = 400;
    HTTP_UNAUTHORIZED = 401;
    NOT_FOUND = 404;
    INTERNAL_SERVER_ERROR = 500;
  end;

  [SwagPath('v1', 'tarefas')]
  TControllerTarefa = class(THorseGBSwagger)
  public
    [SwagGET('tarefas', 'Listar todas as tarefas')]
    [SwagResponse(THTTPStatus.OK, TTarefaModel, 'Retorno com sucesso')]
    procedure DoListTarefas;

    [SwagPOST('tarefas', 'Criar nova tarefa')]
    [SwagParamBody('body', TTarefaModel, true, 'Nova tarefa')]
    [SwagResponse(THTTPStatus.HTTP_CREATED, nil, 'Criado com sucesso')]
    procedure DoPost;

    [SwagPUT('tarefas/{id}', 'Atualizar dados da tarefa')]
    [SwagParamPath('id', 'ID da tarefa')]
    [SwagParamBody('body', TTarefaModel, True, 'Status da Tarefa a ser atualizado')]
    [SwagResponse(THTTPStatus.OK, nil, 'Atualizado com sucesso')]
    procedure DoPut;

    [SwagDELETE('tarefas/{id}', 'Excluir tarefa')]
    [SwagParamPath('id', 'ID da tarefa')]
    [SwagResponse(THTTPStatus.HTTP_NO_CONTENT, nil, 'Removido com sucesso')]
    procedure DoDelete;

    [SwagGET('tarefas/total', 'Retorna o número total de tarefas')]
    [SwagResponse(THTTPStatus.OK, TTotalTarefasModel, 'Retorno com sucesso')]
    [SwagResponse(THTTPStatus.INTERNAL_SERVER_ERROR, TErrorModel, 'Erro interno do servidor')]
    procedure TotalTarefas;

    [SwagGET('tarefas/media-prioridade-pendentes', 'Retorna a média de prioridade das tarefas pendentes')]
    [SwagResponse(THTTPStatus.OK, TMediaPrioridadeModel, 'Retorno com sucesso')]
    procedure MediaPrioridadePendentes;

    [SwagGET('tarefas/concluidas-ultimos-7-dias', 'Retorna a quantidade de tarefas concluídas nos últimos 7 dias')]
    [SwagResponse(THTTPStatus.OK, TTotalConcluidasModel, 'Retorno com sucesso')]
    procedure TarefasConcluidasUltimos7Dias;
  end;

implementation

uses
  uTarefa.DAO,
  Horse.Request,
  Horse.Response,
  GBSwagger.Resources;

{ TControllerTarefa }

procedure TControllerTarefa.DoListTarefas;
var
  Lista: TJSONArray;
begin
  Lista := TTarefasDAO.ListarTodas;
  try
    try
      FResponse
        .ContentType('application/json')
        .Send(Lista.ToJSON);
    except
      on E: Exception do
        FResponse
          .Status(THTTPStatus.INTERNAL_SERVER_ERROR)
          .ContentType('application/json')
          .Send(Format('{"erro":"%s"}', [E.Message]));
    end;
  finally
    Lista.Free;
  end;
end;

procedure TControllerTarefa.DoPost;
var
  Body: TJSONObject;
begin
  try
    Body := FRequest.Body<TJSONObject>;
    if Body = nil then
      raise Exception.Create('JSON inválido ou malformado.');

    TTarefasDAO.Criar(Body);

    FResponse.Status(THTTPStatus.HTTP_CREATED)
      .ContentType('application/json')
      .Send('{"mensagem":"Tarefa criada com sucesso"}');
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .ContentType('application/json')
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

procedure TControllerTarefa.DoPut;
var
  ID: Integer;
  IDStr: string;
  Body: TTarefaModel;
begin
  try
    if not FRequest.Params.TryGetValue('id', IDStr) then
    begin
      FResponse.Status(THTTPStatus.BAD_REQUEST)
        .ContentType('application/json')
        .Send('{"erro":"ID da tarefa não informado"}');
      Exit;
    end;

    ID := StrToIntDef(IDStr, 0);
    if ID = 0 then
    begin
      FResponse.Status(THTTPStatus.BAD_REQUEST)
        .ContentType('application/json')
        .Send('{"erro":"ID inválido"}');
      Exit;
    end;

    try
      Body := FRequest.Body<TTarefaModel>;
    except
      on E: Exception do
      begin
        FResponse.Status(THTTPStatus.BAD_REQUEST)
          .ContentType('application/json')
          .Send(Format('{"erro":"Corpo da requisição inválido: %s"}', [E.Message]));
        Exit;
      end;
    end;

    if Body.Status.Trim.IsEmpty then
    begin
      FResponse.Status(THTTPStatus.BAD_REQUEST)
        .ContentType('application/json')
        .Send('{"erro":"Status da tarefa não informado"}');
      Exit;
    end;

    // Atualiza somente o status da tarefa no DAO
    TTarefasDAO.Atualizar(ID, Body.Status);

    FResponse.Status(THTTPStatus.OK)
      .ContentType('application/json')
      .Send('{"mensagem":"Status da tarefa atualizado com sucesso"}');

  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .ContentType('application/json')
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

procedure TControllerTarefa.DoDelete;
var
  ID: Integer;
begin
  try
    ID := FRequest.Params['id'].ToInteger;
    TTarefasDAO.Remover(ID);
    FResponse.Status(THTTPStatus.HTTP_NO_CONTENT); // No Content
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .ContentType('application/json')
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

procedure TControllerTarefa.TotalTarefas;
begin
  try
    FResponse.Status(THTTPStatus.OK)
      .ContentType('application/json')
      .Send(
        TJSONObject.Create
          .AddPair('totalTarefas', TJSONNumber.Create(TTarefasDAO.TotalTarefas))
      );
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .Send(
          TJSONObject.Create
            .AddPair('erro', E.Message)
        );
  end;
end;

procedure TControllerTarefa.MediaPrioridadePendentes;
begin
  try
    FResponse.Status(THTTPStatus.OK)
      .ContentType('application/json')
      .Send(
        TJSONObject.Create
          .AddPair('media', TJSONNumber.Create(TTarefasDAO.MediaPrioridadePendentes))
      );
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .Send(
          TJSONObject.Create
            .AddPair('erro', E.Message)
        );
  end;
end;

procedure TControllerTarefa.TarefasConcluidasUltimos7Dias;
begin
  try
    FResponse.Status(THTTPStatus.OK)
      .ContentType('application/json')
      .Send(
        TJSONObject.Create
          .AddPair('totalConcluidas', TJSONNumber.Create(TTarefasDAO.TarefasConcluidasUltimos7Dias))
      );
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .Send(
          TJSONObject.Create
            .AddPair('erro', E.Message)
        );
  end;
end;

const
  API_KEY = 'minha-chave-secreta-123'; // você pode trocar por um GUID ou algo mais forte

procedure RequireApiKey(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
const
  API_KEY = 'minha-chave-secreta-123';
var
  Key, Path: string;
begin
  Path := Req.RawWebRequest.PathInfo;

  // Libera acesso para as rotas do Swagger
  if Path.StartsWith('/swagger') then
  begin
    Next();
    Exit;
  end;

  Key := Req.Headers['x-api-key'];
  if Key.IsEmpty or (Key <> API_KEY) then
  begin
    Res.Status(THTTPStatus.HTTP_UNAUTHORIZED)
      .ContentType('application/json')
      .Send('{"erro":"Acesso não autorizado. Chave de API inválida."}');
    Exit;
  end;

  Next();
end;

initialization
  THorse.Use(Jhonson());     // IMPORTANTE: middleware para interpretar JSON
  THorse.Use(RequireApiKey); // protege com API key
  THorseGBSwaggerRegister.RegisterPath(TControllerTarefa);
end.

