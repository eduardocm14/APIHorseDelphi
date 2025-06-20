unit uForm.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  REST.Types,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  System.JSON, Vcl.Grids;

type
  TPrioridade = record
  const
    BAIXO = 1;
    MEDIO = 2;
    ALTO = 3;
  end;

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

  TFormPrincipal = class(TForm)
    btnListarTarefas: TButton;
    btnNovaTarefa: TButton;
    btnAtualizarStatus: TButton;
    btnRemovarTarefa: TButton;
    Panel1: TPanel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    StringGrid1: TStringGrid;
    lblTotalTarefas: TLabel;
    lblMediaPrioridade: TLabel;
    lblTotalConcluidas: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnListarTarefasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNovaTarefaClick(Sender: TObject);
    procedure btnRemovarTarefaClick(Sender: TObject);
    procedure btnAtualizarStatusClick(Sender: TObject);
  private
    { Private declarations }
    procedure ListarTarefas;
    procedure AtualizarEstatisticas;
    procedure AtualizarTotalTarefas;
    procedure AtualizarMediaPrioridade;
    procedure AtualizarTotalConcluidas7Dias;
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.AtualizarEstatisticas;
begin
  AtualizarTotalTarefas;
  AtualizarMediaPrioridade;
  AtualizarTotalConcluidas7Dias;
end;

procedure TFormPrincipal.AtualizarMediaPrioridade;
var
  JSON: TJSONObject;
begin
  RESTRequest1.Resource := 'tarefas/media-prioridade-pendentes';
  RESTRequest1.Method := rmGET;
  RESTRequest1.Execute;

  if RESTResponse1.StatusCode = THTTPStatus.OK then
  begin
    JSON := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
    try
      lblMediaPrioridade.Caption := 'Média de prioridade das tarefas pendentes: ' + FormatFloat('0.00', JSON.GetValue<Double>('media'));
    finally
      JSON.Free;
    end;
  end
  else
    lblMediaPrioridade.Caption := 'Erro ao carregar média';
end;

procedure TFormPrincipal.AtualizarTotalConcluidas7Dias;
var
  JSON: TJSONObject;
begin
  RESTRequest1.Resource := 'tarefas/concluidas-ultimos-7-dias';
  RESTRequest1.Method := rmGET;
  RESTRequest1.Execute;

  if RESTResponse1.StatusCode = THTTPStatus.OK then
  begin
    JSON := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
    try
      lblTotalConcluidas.Caption := 'Quantidade de tarefas concluídas nos últimos 7 dias: ' + JSON.GetValue<string>('totalConcluidas');
    finally
      JSON.Free;
    end;
  end
  else
    lblTotalConcluidas.Caption := 'Erro ao carregar concl. 7 dias';
end;

procedure TFormPrincipal.AtualizarTotalTarefas;
var
  JSON: TJSONObject;
begin
  RESTRequest1.Resource := 'tarefas/total';
  RESTRequest1.Method := rmGET;
  RESTRequest1.Execute;

  if RESTResponse1.StatusCode = THTTPStatus.OK then
  begin
    JSON := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
    try
      lblTotalTarefas.Caption := 'Número total de tarefas: ' + JSON.GetValue<string>('totalTarefas');
    finally
      JSON.Free;
    end;
  end
  else
    lblTotalTarefas.Caption := 'Erro ao carregar total';
end;

procedure TFormPrincipal.btnAtualizarStatusClick(Sender: TObject);
var
  Form: TForm;
  lblTitulo, lblDescricao, lblStatus: TLabel;
  edtTitulo, edtDescricao: TEdit;
  cmbStatus: TComboBox;
  btnSalvar, btnCancelar: TButton;
  ID, StatusAtual, NovoStatus: string;
  RowIndex: Integer;
  JSON: TJSONObject;
begin
  RowIndex := StringGrid1.Row;

  if RowIndex <= 0 then
  begin
    ShowMessage('Selecione uma tarefa.');
    Exit;
  end;

  // Obtem dados da tarefa selecionada
  ID := StringGrid1.Cells[0, RowIndex];
  StatusAtual := StringGrid1.Cells[4, RowIndex];

  Form := TForm.Create(nil);
  try
    Form.Caption := 'Atualizar Status da Tarefa';
    Form.Width := 400;
    Form.Height := 250;
    Form.Position := poScreenCenter;
    Form.BorderStyle := bsDialog;

    lblTitulo := TLabel.Create(Form);
    lblTitulo.Parent := Form;
    lblTitulo.Caption := 'Título:';
    lblTitulo.Left := 20;
    lblTitulo.Top := 20;

    edtTitulo := TEdit.Create(Form);
    edtTitulo.Parent := Form;
    edtTitulo.Text := StringGrid1.Cells[1, RowIndex];
    edtTitulo.Left := 80;
    edtTitulo.Top := 18;
    edtTitulo.Width := 280;
    edtTitulo.ReadOnly := True;

    lblDescricao := TLabel.Create(Form);
    lblDescricao.Parent := Form;
    lblDescricao.Caption := 'Descrição:';
    lblDescricao.Left := 20;
    lblDescricao.Top := 60;

    edtDescricao := TEdit.Create(Form);
    edtDescricao.Parent := Form;
    edtDescricao.Text := StringGrid1.Cells[2, RowIndex];
    edtDescricao.Left := 80;
    edtDescricao.Top := 58;
    edtDescricao.Width := 280;
    edtDescricao.ReadOnly := True;

    lblStatus := TLabel.Create(Form);
    lblStatus.Parent := Form;
    lblStatus.Caption := 'Status:';
    lblStatus.Left := 20;
    lblStatus.Top := 100;

    cmbStatus := TComboBox.Create(Form);
    cmbStatus.Parent := Form;
    cmbStatus.Items.Add('Pendente');
    cmbStatus.Items.Add('Em Andamento');
    cmbStatus.Items.Add('Concluído');
    cmbStatus.Left := 80;
    cmbStatus.Top := 98;
    cmbStatus.Width := 200;
    cmbStatus.ItemIndex := cmbStatus.Items.IndexOf(StatusAtual);

    btnSalvar := TButton.Create(Form);
    btnSalvar.Parent := Form;
    btnSalvar.Caption := 'Salvar';
    btnSalvar.ModalResult := mrOk;
    btnSalvar.Left := 80;
    btnSalvar.Top := 150;
    btnSalvar.Width := 100;

    btnCancelar := TButton.Create(Form);
    btnCancelar.Parent := Form;
    btnCancelar.Caption := 'Cancelar';
    btnCancelar.ModalResult := mrCancel;
    btnCancelar.Left := 200;
    btnCancelar.Top := 150;
    btnCancelar.Width := 100;

    if Form.ShowModal = mrOk then
    begin
      NovoStatus := cmbStatus.Text;

      if Trim(NovoStatus) = '' then
      begin
        ShowMessage('Informe um status válido.');
        Exit;
      end;

      JSON := TJSONObject.Create;
      try
        JSON.AddPair('status', NovoStatus);

        // Altere a rota para o novo endpoint POST
        RESTRequest1.Resource := 'tarefas/' + ID + '/atualizar-status';
        RESTRequest1.Method := rmPOST;
        RESTRequest1.Body.ClearBody;
        RESTRequest1.AddBody(JSON.ToJSON, ctAPPLICATION_JSON);
        RESTRequest1.Execute;

        if RESTResponse1.StatusCode = THTTPStatus.OK then
        begin
          ShowMessage('Status atualizado com sucesso.');
          ListarTarefas;
        end
        else
          ShowMessage('Erro ao atualizar status: ' + RESTResponse1.Content);

      finally
        JSON.Free;
      end;
    end;

  finally
    Form.Free;
  end;
end;

procedure TFormPrincipal.btnListarTarefasClick(Sender: TObject);
begin
  ListarTarefas;
end;

procedure TFormPrincipal.btnNovaTarefaClick(Sender: TObject);
var
  FormNovaTarefa: TForm;
  lblTitulo, lblDescricao, lblPrioridade: TLabel;
  edtTitulo: TEdit;
  memDescricao: TMemo;
  cbPrioridade: TComboBox;
  btnSalvar, btnCancelar: TButton;
  PrioridadeInt: Integer;
  Body: TJSONObject;
begin
  FormNovaTarefa := TForm.Create(nil);
  try
    // Configura o form
    FormNovaTarefa.Width := 400;
    FormNovaTarefa.Height := 350;
    FormNovaTarefa.Position := poScreenCenter;
    FormNovaTarefa.BorderStyle := bsDialog;
    FormNovaTarefa.Caption := 'Nova Tarefa';

    // Título
    lblTitulo := TLabel.Create(FormNovaTarefa);
    lblTitulo.Parent := FormNovaTarefa;
    lblTitulo.Caption := 'Título:';
    lblTitulo.Top := 20;
    lblTitulo.Left := 20;

    edtTitulo := TEdit.Create(FormNovaTarefa);
    edtTitulo.Parent := FormNovaTarefa;
    edtTitulo.Top := lblTitulo.Top + 20;
    edtTitulo.Left := 20;
    edtTitulo.Width := 340;

    // Descrição
    lblDescricao := TLabel.Create(FormNovaTarefa);
    lblDescricao.Parent := FormNovaTarefa;
    lblDescricao.Caption := 'Descrição:';
    lblDescricao.Top := edtTitulo.Top + 40;
    lblDescricao.Left := 20;

    memDescricao := TMemo.Create(FormNovaTarefa);
    memDescricao.Parent := FormNovaTarefa;
    memDescricao.Top := lblDescricao.Top + 20;
    memDescricao.Left := 20;
    memDescricao.Width := 340;
    memDescricao.Height := 60;

    // Prioridade
    lblPrioridade := TLabel.Create(FormNovaTarefa);
    lblPrioridade.Parent := FormNovaTarefa;
    lblPrioridade.Caption := 'Prioridade:';
    lblPrioridade.Top := memDescricao.Top + memDescricao.Height + 10;
    lblPrioridade.Left := 20;

    cbPrioridade := TComboBox.Create(FormNovaTarefa);
    cbPrioridade.Parent := FormNovaTarefa;
    cbPrioridade.Top := lblPrioridade.Top + 20;
    cbPrioridade.Left := 20;
    cbPrioridade.Width := 150;
    cbPrioridade.Items.Add('Baixo');   // 1
    cbPrioridade.Items.Add('Médio');   // 2
    cbPrioridade.Items.Add('Alto');    // 3
    cbPrioridade.ItemIndex := 0;

    // Botão Salvar
    btnSalvar := TButton.Create(FormNovaTarefa);
    btnSalvar.Parent := FormNovaTarefa;
    btnSalvar.Caption := 'Salvar';
    btnSalvar.ModalResult := mrOk;
    btnSalvar.Top := cbPrioridade.Top + 40;
    btnSalvar.Left := 200;
    btnSalvar.Width := 80;

    // Botão Cancelar
    btnCancelar := TButton.Create(FormNovaTarefa);
    btnCancelar.Parent := FormNovaTarefa;
    btnCancelar.Caption := 'Cancelar';
    btnCancelar.ModalResult := mrCancel;
    btnCancelar.Top := cbPrioridade.Top + 40;
    btnCancelar.Left := 280;
    btnCancelar.Width := 80;

    // Exibe o formulário como modal
    if FormNovaTarefa.ShowModal = mrOk then
    begin
      // Validar campos
      if Trim(edtTitulo.Text) = '' then
        raise Exception.Create('Título é obrigatório.');

      PrioridadeInt := cbPrioridade.ItemIndex + 1;

      // Montar JSON
      Body := TJSONObject.Create;
      try
        Body.AddPair('Titulo', Trim(edtTitulo.Text));
        Body.AddPair('Descricao', Trim(memDescricao.Text));
        Body.AddPair('Prioridade', TJSONNumber.Create(PrioridadeInt));
        Body.AddPair('Status', 'Pendente');

        // Enviar para API
        RESTRequest1.Resource := 'tarefas';
        RESTRequest1.Method := rmPOST;
        RESTRequest1.ClearBody;
        RESTRequest1.AddBody(Body.ToJSON, ctAPPLICATION_JSON);
        RESTRequest1.Execute;

        if RESTResponse1.StatusCode = THTTPStatus.HTTP_CREATED then
        begin
          ShowMessage('Tarefa criada com sucesso!');
          ListarTarefas;
        end
        else
          ShowMessage('Erro ao criar tarefa: ' + RESTResponse1.Content);
      finally
        Body.Free;
      end;
    end;
  finally
    FormNovaTarefa.Free;
  end;

end;

procedure TFormPrincipal.btnRemovarTarefaClick(Sender: TObject);
var
  ID, Titulo: string;
  RowIndex: Integer;
begin
  RowIndex := StringGrid1.Row;

  if RowIndex <= 0 then
  begin
    ShowMessage('Selecione uma tarefa para remover.');
    Exit;
  end;

  ID := Trim(StringGrid1.Cells[0, RowIndex]);        // Coluna do ID
  Titulo := Trim(StringGrid1.Cells[1, RowIndex]);    // Coluna do Título

  if ID = '' then
  begin
    ShowMessage('ID da tarefa inválido.');
    Exit;
  end;

  if MessageDlg(
    Format('Deseja realmente remover a tarefa %s - "%s"?', [ID, Titulo]),
    mtConfirmation, [mbYes, mbNo], 0
  ) = mrYes then
  begin
    try
      RESTRequest1.Resource := 'tarefas/' + ID;
      RESTRequest1.Method := rmDELETE;
      RESTRequest1.Execute;

      if RESTResponse1.StatusCode = THTTPStatus.HTTP_NO_CONTENT then
      begin
        ShowMessage('Tarefa removida com sucesso.');
        ListarTarefas;
      end
      else
      begin
        ShowMessage('Erro ao remover tarefa: ' + RESTResponse1.Content);
      end;
    except
      on E: Exception do
        ShowMessage('Erro: ' + E.Message);
    end;
  end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  RESTClient1.BaseURL := 'http://localhost:9000/v1';
  RESTRequest1.Client := RESTClient1;
  RESTRequest1.Response := RESTResponse1;

  RESTRequest1.Params.AddItem('x-api-key', 'minha-chave-secreta-123', pkHTTPHEADER, [poDoNotEncode]);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  AtualizarEstatisticas;
  ListarTarefas;
end;

procedure TFormPrincipal.ListarTarefas;
  function PrioridadeToTexto(const Value: Integer): string;
  begin
    case Value of
      TPrioridade.BAIXO: Result := 'Baixo';
      TPrioridade.MEDIO: Result := 'Médio';
      TPrioridade.ALTO:  Result := 'Alto';
    else
      Result := 'Desconhecida';
    end;
  end;
var
  JSONArr: TJSONArray;
  I: Integer;
  Obj: TJSONObject;
begin
  try
    // Configura e executa a requisição REST
    RESTRequest1.Resource := 'tarefas';
    RESTRequest1.Method := rmGET;
    RESTRequest1.Execute;

    if RESTResponse1.StatusCode <> THTTPStatus.OK then
      raise Exception.Create('Erro ao buscar tarefas: ' + RESTResponse1.StatusText);

    // Parse do JSON
    JSONArr := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONArray;
    try
      StringGrid1.BeginUpdate;
      try
        // Configuração básica do grid
        StringGrid1.ColCount := 7;
        StringGrid1.FixedCols := 0;
        StringGrid1.FixedRows := 1; // Uma linha fixa para cabeçalho
        StringGrid1.DefaultRowHeight := 24;
        StringGrid1.Font.Name := 'Segoe UI';
        StringGrid1.Font.Size := 12;
        StringGrid1.GridLineWidth := 1;
        StringGrid1.Options := [goFixedHorzLine, goFixedVertLine, goHorzLine, goVertLine, goRowSelect];

        // Configura cabeçalhos
        StringGrid1.Cells[0, 0] := 'CÓDIGO';
        StringGrid1.Cells[1, 0] := 'TITULO';
        StringGrid1.Cells[2, 0] := 'DESCRIÇÃO';
        StringGrid1.Cells[3, 0] := 'PRIORIDADE';
        StringGrid1.Cells[4, 0] := 'STATUS';
        StringGrid1.Cells[5, 0] := 'CRIAÇÃO';
        StringGrid1.Cells[6, 0] := 'CONCLUSÃO';

        // Configura largura das colunas
        StringGrid1.ColWidths[0] := 100;
        StringGrid1.ColWidths[1] := 250;
        StringGrid1.ColWidths[2] := 250;
        StringGrid1.ColWidths[3] := 150;
        StringGrid1.ColWidths[4] := 150;
        StringGrid1.ColWidths[5] := 150;
        StringGrid1.ColWidths[6] := 150;

        // Verifica se há dados antes de ajustar o RowCount
        if JSONArr.Count > 0 then
        begin
          // Ajusta o número de linhas (dados + cabeçalho)
          StringGrid1.RowCount := JSONArr.Count + 1;

          // Preenche os dados
          for I := 0 to JSONArr.Count - 1 do
          begin
            Obj := JSONArr.Items[I] as TJSONObject;
            StringGrid1.Cells[0, I+1] := Obj.GetValue<string>('ID');
            StringGrid1.Cells[1, I+1] := Obj.GetValue<string>('Titulo');
            StringGrid1.Cells[2, I+1] := Obj.GetValue<string>('Descricao');
            StringGrid1.Cells[3, I+1] := PrioridadeToTexto(Obj.GetValue<Integer>('Prioridade'));
            StringGrid1.Cells[4, I+1] := Obj.GetValue<string>('Status');
            StringGrid1.Cells[5, I+1] := Copy(Obj.GetValue<string>('DataCriacao'), 1, 10) ;
            StringGrid1.Cells[6, I+1] := Copy(Obj.GetValue<string>('DataConclusao'), 1, 10);
          end;
        end
        else
        begin
          // Sem dados, mantém apenas o cabeçalho
          StringGrid1.RowCount := 1;
        end;
      finally
        StringGrid1.EndUpdate;
      end;
    finally
      JSONArr.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao listar tarefas: ' + E.Message);
  end;
end;

end.
