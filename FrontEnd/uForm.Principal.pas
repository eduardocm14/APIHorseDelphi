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
    procedure FormCreate(Sender: TObject);
    procedure btnListarTarefasClick(Sender: TObject);
  private
    { Private declarations }
    procedure ListarTarefas;
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.btnListarTarefasClick(Sender: TObject);
begin
  ListarTarefas;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  RESTClient1.BaseURL := 'http://localhost:9000/v1';
  RESTRequest1.Client := RESTClient1;
  RESTRequest1.Response := RESTResponse1;

  RESTRequest1.Params.AddItem('x-api-key', 'minha-chave-secreta-123', pkHTTPHEADER, [poDoNotEncode]);
end;

procedure TFormPrincipal.ListarTarefas;
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

    if RESTResponse1.StatusCode <> 200 then
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
            StringGrid1.Cells[3, I+1] := Obj.GetValue<string>('Prioridade');
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
