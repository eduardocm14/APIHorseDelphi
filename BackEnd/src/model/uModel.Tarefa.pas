unit uModel.Tarefa;

interface

type
  TTarefaModel = class
    private
      FId: Integer;
      FTitulo: string;
      FDescricao: string;
      FPrioridade: Integer;
      FStatus: string;
      FDataCriacao: TDateTime;
      FDataConclusao: TDateTime;

    public
      property Id : Integer read FId write FId;
      property Titulo: string read FTitulo write FTitulo;
      property Descricao: string read FDescricao write FDescricao;
      property Prioridade: Integer read FPrioridade write FPrioridade;
      property Status: string read FStatus write FStatus;
      property DataCriacao : TDateTime read FDataCriacao write FDataCriacao;
      property DataConclusao : TDateTime read FDataConclusao write FDataConclusao;
  end;

implementation

end.
