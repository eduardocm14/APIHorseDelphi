unit uTarefaService;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  REST.Client,
  REST.Types,
  uTarefaModel;

type
  TTarefaService = class
  private
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
  public
    constructor Create;
    destructor Destroy; override;

    function Listar: TArray<TTarefaModel>;
    function Criar(ATarefa: TTarefaModel): Boolean;
    function AtualizarStatus(const ID, NovoStatus: string): Boolean;
    function Remover(const ID: string): Boolean;

    function BuscarMediaPrioridade: Double;
    function BuscarTotal: Integer;
    function BuscarTotalConcluidas7Dias: Integer;
  end;

implementation

{ TTarefaService }

uses uAppConsts, uHTTPStatusPrioridade;

constructor TTarefaService.Create;
begin
  FClient := TRESTClient.Create(API_BASE_URL);
  FRequest := TRESTRequest.Create(nil);
  FResponse := TRESTResponse.Create(nil);

  FClient.ContentType := 'application/json';

  FRequest.Client := FClient;
  FRequest.Response := FResponse;
  FRequest.Params.AddItem('x-api-key', API_KEY, pkHTTPHEADER, [poDoNotEncode]); // Usar Const
end;

destructor TTarefaService.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  FClient.Free;
  inherited;
end;

function TTarefaService.Listar: TArray<TTarefaModel>;
var
  JSONArr: TJSONArray;
  I: Integer;
begin
  FRequest.Method := rmGET;
  FRequest.Resource := 'tarefas';
  FRequest.Execute;

  JSONArr := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONArray;
  try
    SetLength(Result, JSONArr.Count);
    for I := 0 to JSONArr.Count - 1 do
      Result[I] := TTarefaModel.FromJSON(JSONArr.Items[I] as TJSONObject);
  finally
    JSONArr.Free;
  end;
end;

function TTarefaService.Criar(ATarefa: TTarefaModel): Boolean;
begin
  FRequest.Method := rmPOST;
  FRequest.Resource := 'tarefas';
  FRequest.ClearBody;
  FRequest.AddBody(ATarefa.ToJSON.ToJSON, ctAPPLICATION_JSON);
  FRequest.Execute;

  Result := FResponse.StatusCode = THTTPStatus.Created;
end;

function TTarefaService.AtualizarStatus(const ID, NovoStatus: string): Boolean;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create;
  try
    JSON.AddPair('status', NovoStatus);

    FRequest.Method := rmPOST;
    FRequest.Resource := 'tarefas/' + ID + '/atualizar-status';
    FRequest.ClearBody;
    FRequest.AddBody(JSON.ToJSON, ctAPPLICATION_JSON);
    FRequest.Execute;

    Result := FResponse.StatusCode = THTTPStatus.OK;
  finally
    JSON.Free;
  end;
end;

function TTarefaService.Remover(const ID: string): Boolean;
begin
  FRequest.Method := rmDELETE;
  FRequest.Resource := 'tarefas/' + ID;
  FRequest.Execute;

  Result := FResponse.StatusCode = THTTPStatus.NoContent;
end;

function TTarefaService.BuscarMediaPrioridade: Double;
var
  JSON: TJSONObject;
begin
  FRequest.Method := rmGET;
  FRequest.Resource := 'tarefas/media-prioridade-pendentes';
  FRequest.Execute;

  JSON := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  try
    Result := JSON.GetValue<Double>('media');
  finally
    JSON.Free;
  end;
end;

function TTarefaService.BuscarTotal: Integer;
var
  JSON: TJSONObject;
begin
  FRequest.Method := rmGET;
  FRequest.Resource := 'tarefas/total';
  FRequest.Execute;

  JSON := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  try
    Result := JSON.GetValue<Integer>('totalTarefas');
  finally
    JSON.Free;
  end;
end;

function TTarefaService.BuscarTotalConcluidas7Dias: Integer;
var
  JSON: TJSONObject;
begin
  FRequest.Method := rmGET;
  FRequest.Resource := 'tarefas/concluidas-ultimos-7-dias';
  FRequest.Execute;

  JSON := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  try
    Result := JSON.GetValue<Integer>('totalConcluidas');
  finally
    JSON.Free;
  end;
end;

end.

