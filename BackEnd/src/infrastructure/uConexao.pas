unit uConexao;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.Win.ADODB,
  Data.DB,
  ActiveX;          // <--- para CoInitialize e CoUninitialize;

type
  TConexao = class
  private
    FConnection: TADOConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TADOConnection;
  end;

implementation

{ TConexao }

constructor TConexao.Create;
begin
  CoInitialize(nil);      // Inicializa COM
  FConnection := TADOConnection.Create(nil);
  try
    FConnection.LoginPrompt := False;
    FConnection.ConnectionString :=
      'Provider=MSDASQL.1;' +             // Provider ODBC
      'DSN=APIHorseODBC;' +              // Nome do DSN (já configurado)
      'Uid=sa;' +                        // Usuário do SQL Server (ajuste se necessário)
      'Pwd=sua_senha_aqui;';             // Senha do SQL Server

    FConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar: ' + E.Message);
  end;
end;

destructor TConexao.Destroy;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
  FreeAndNil(FConnection);
  CoUninitialize;      // Libera COM
  inherited;
end;

function TConexao.GetConnection: TADOConnection;
begin
  Result := FConnection;
end;

end.

