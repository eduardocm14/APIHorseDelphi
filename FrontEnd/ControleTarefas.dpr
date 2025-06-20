program ControleTarefas;

uses
  Vcl.Forms,
  uForm.Principal in 'uForm.Principal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
