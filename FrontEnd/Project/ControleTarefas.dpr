program ControleTarefas;

uses
  Vcl.Forms,
  uForm.Principal in '..\Forms\uForm.Principal.pas' {FormPrincipal},
  uTarefaModel in '..\Models\uTarefaModel.pas',
  uTarefaService in '..\Services\uTarefaService.pas',
  uHTTPStatusPrioridade in '..\Utils\uHTTPStatusPrioridade.pas',
  uEstatisticasDto in '..\DTOs\uEstatisticasDto.pas',
  uAppConsts in '..\Utils\uAppConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
