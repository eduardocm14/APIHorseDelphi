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
  System.JSON,
  Vcl.Grids,
  REST.Types,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  uTarefaService;

type
  TFormPrincipal = class(TForm)
    btnListarTarefas: TButton;
    btnNovaTarefa: TButton;
    btnAtualizarStatus: TButton;
    btnRemoverTarefa: TButton;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    lblTotalTarefas: TLabel;
    lblMediaPrioridade: TLabel;
    lblTotalConcluidas: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnListarTarefasClick(Sender: TObject);
    procedure btnNovaTarefaClick(Sender: TObject);
    procedure btnRemoverTarefaClick(Sender: TObject);
    procedure btnAtualizarStatusClick(Sender: TObject);
  private
    FTarefaService: TTarefaService;
    procedure ListarTarefas;
    procedure AtualizarEstatisticas;
    procedure AtualizarTotalTarefas;
    procedure AtualizarMediaPrioridade;
    procedure AtualizarTotalConcluidas7Dias;
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses uHTTPStatusPrioridade, uTarefaModel, uAppConsts;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FTarefaService := TTarefaService.Create;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  AtualizarEstatisticas;
  ListarTarefas;
end;

procedure TFormPrincipal.AtualizarEstatisticas;
begin
  AtualizarTotalTarefas;
  AtualizarMediaPrioridade;
  AtualizarTotalConcluidas7Dias;
end;

procedure TFormPrincipal.AtualizarMediaPrioridade;
var
  Media: Double;
begin
  try
    Media := FTarefaService.BuscarMediaPrioridade;
    lblMediaPrioridade.Caption := Format('Média de prioridade das tarefas pendentes: %.2f', [Media]);
  except
    on E: Exception do
      lblMediaPrioridade.Caption := 'Erro ao carregar média';
  end;
end;

procedure TFormPrincipal.AtualizarTotalTarefas;
var
  Total: Integer;
begin
  try
    Total := FTarefaService.BuscarTotal;
    lblTotalTarefas.Caption := 'Número total de tarefas: ' + Total.ToString;
  except
    on E: Exception do
      lblTotalTarefas.Caption := 'Erro ao carregar total';
  end;
end;

procedure TFormPrincipal.AtualizarTotalConcluidas7Dias;
var
  Total: Integer;
begin
  try
    Total := FTarefaService.BuscarTotalConcluidas7Dias;
    lblTotalConcluidas.Caption := 'Quantidade de tarefas concluídas nos últimos 7 dias: ' + Total.ToString;
  except
    on E: Exception do
      lblTotalConcluidas.Caption := 'Erro ao carregar concl. 7 dias';
  end;
end;

procedure TFormPrincipal.btnListarTarefasClick(Sender: TObject);
begin
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
  Tarefas: TArray<TTarefaModel>;
  I: Integer;
begin
  try
    Tarefas := FTarefaService.Listar;

    StringGrid1.BeginUpdate;
    try
      // Configura colunas
      StringGrid1.ColCount := 7;
      StringGrid1.FixedRows := 1;

      StringGrid1.Cells[0, 0] := 'CÓDIGO';
      StringGrid1.Cells[1, 0] := 'TÍTULO';
      StringGrid1.Cells[2, 0] := 'DESCRIÇÃO';
      StringGrid1.Cells[3, 0] := 'PRIORIDADE';
      StringGrid1.Cells[4, 0] := 'STATUS';
      StringGrid1.Cells[5, 0] := 'CRIAÇÃO';
      StringGrid1.Cells[6, 0] := 'CONCLUSÃO';

      StringGrid1.ColWidths[0] := 80;
      StringGrid1.ColWidths[1] := 200;
      StringGrid1.ColWidths[2] := 300;
      StringGrid1.ColWidths[3] := 100;
      StringGrid1.ColWidths[4] := 120;
      StringGrid1.ColWidths[5] := 100;
      StringGrid1.ColWidths[6] := 100;

      if Length(Tarefas) > 0 then
      begin
        StringGrid1.RowCount := Length(Tarefas) + 1;

        for I := 0 to High(Tarefas) do
        begin
          StringGrid1.Cells[0, I + 1] := Tarefas[I].ID;
          StringGrid1.Cells[1, I + 1] := Tarefas[I].Titulo;
          StringGrid1.Cells[2, I + 1] := Tarefas[I].Descricao;
          StringGrid1.Cells[3, I + 1] := PrioridadeToTexto(Tarefas[I].Prioridade);
          StringGrid1.Cells[4, I + 1] := Tarefas[I].Status;
          StringGrid1.Cells[5, I + 1] := Copy(Tarefas[I].DataCriacao, 1, 10);
          StringGrid1.Cells[6, I + 1] := Copy(Tarefas[I].DataConclusao, 1, 10);
        end;
      end
      else
      begin
        StringGrid1.RowCount := 1;
        ShowMessage('Nenhuma tarefa encontrada.');
      end;
    finally
      StringGrid1.EndUpdate;
    end;

  except
    on E: Exception do
      ShowMessage('Erro ao listar tarefas: ' + E.Message);
  end;
end;

procedure TFormPrincipal.btnNovaTarefaClick(Sender: TObject);
var
  FormNovaTarefa: TForm;
  lblTitulo, lblDescricao, lblPrioridade: TLabel;
  edtTitulo: TEdit;
  memDescricao: TMemo;
  cbPrioridade: TComboBox;
  btnSalvar, btnCancelar: TButton;
  NovaTarefa: TTarefaModel;
  PrioridadeInt: Integer;
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
      if Trim(edtTitulo.Text) = '' then
        raise Exception.Create('Título é obrigatório.');

      PrioridadeInt := cbPrioridade.ItemIndex + 1;

      // Cria instância da tarefa
      NovaTarefa := TTarefaModel.Create;
      try
        NovaTarefa.Titulo := Trim(edtTitulo.Text);
        NovaTarefa.Descricao := Trim(memDescricao.Text);
        NovaTarefa.Prioridade := PrioridadeInt;
        NovaTarefa.Status := 'Pendente';

        // Chama o service
        if FTarefaService.Criar(NovaTarefa) then
        begin
          ShowMessage('Tarefa criada com sucesso!');
          ListarTarefas;
        end
        else
          ShowMessage('Erro ao criar a tarefa.');
      finally
        NovaTarefa.Free;
      end;
    end;

  finally
    FormNovaTarefa.Free;
  end;
end;

procedure TFormPrincipal.btnRemoverTarefaClick(Sender: TObject);
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

  ID := StringGrid1.Cells[0, RowIndex];
  Titulo := StringGrid1.Cells[1, RowIndex];

  if MessageDlg('Deseja remover a tarefa "' + Titulo + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if FTarefaService.Remover(ID) then
    begin
      ShowMessage('Tarefa removida com sucesso.');
      ListarTarefas;
    end
    else
      ShowMessage('Erro ao remover tarefa.');
  end;
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
    edtTitulo.Enabled := False;
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
    edtDescricao.Enabled := False;
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

      try
        if FTarefaService.AtualizarStatus(ID, NovoStatus) then
        begin
          ShowMessage('Status atualizado com sucesso.');
          ListarTarefas;
        end
        else
          ShowMessage('Erro ao atualizar o status.');
      except
        on E: Exception do
          ShowMessage('Erro: ' + E.Message);
      end;
    end;
  finally
    Form.Free;
  end;
end;

end.

