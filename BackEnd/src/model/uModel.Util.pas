unit uModel.Util;

interface

type
  /// <summary>
  /// Modelo para representar o status de uma tarefa
  /// </summary>
  TStatusModel = class
  private
    FStatus: string;
  public
    /// <summary>
    /// Status da tarefa (ex: 'Pendente', 'Em Andamento', 'Conclu�do')
    /// </summary>
    property status: string read FStatus write FStatus;
  end;

  /// <summary>
  /// Modelo para representar o total de tarefas
  /// </summary>
  TTotalTarefasModel = class
  private
    FTotal: Integer;
  public
    /// <summary>
    /// Quantidade total de tarefas
    /// </summary>
    property total: Integer read FTotal write FTotal;
  end;

  /// <summary>
  /// Modelo para representar mensagens de erro
  /// </summary>
  TErrorModel = class
  private
    FErro: string;
  public
    /// <summary>
    /// Mensagem de erro descritiva
    /// </summary>
    property erro: string read FErro write FErro;
  end;

  /// <summary>
  /// Modelo para representar a m�dia de prioridade
  /// </summary>
  TMediaPrioridadeModel = class
  private
    FMedia: Double;
  public
    /// <summary>
    /// Valor da m�dia calculada
    /// </summary>
    property media: Double read FMedia write FMedia;
  end;

  /// <summary>
  /// Modelo para representar o total de tarefas conclu�das
  /// </summary>
  TTotalConcluidasModel = class
  private
    FTotal: Integer;
  public
    /// <summary>
    /// Quantidade de tarefas conclu�das
    /// </summary>
    property total: Integer read FTotal write FTotal;
  end;

implementation

end.
