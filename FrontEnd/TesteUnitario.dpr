program TesteUnitario;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  uTesteSimples in 'Tests\uTesteSimples.pas';

begin
  try
    // Execu��o testes RUN
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

