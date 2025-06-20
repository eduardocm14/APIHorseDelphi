object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 
    'Controle de Tarefas - Prova T'#233'cnica para Vaga de Desenvolvedor D' +
    'elphi'
  ClientHeight = 576
  ClientWidth = 1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object btnListarTarefas: TButton
    Left = 0
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Listar Tarefas'
    TabOrder = 0
    OnClick = btnListarTarefasClick
  end
  object btnNovaTarefa: TButton
    Left = 199
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Incluir'
    TabOrder = 1
  end
  object btnAtualizarStatus: TButton
    Left = 398
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Atualizar Status'
    TabOrder = 2
  end
  object btnRemovarTarefa: TButton
    Left = 597
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Remover'
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1090
    Height = 89
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 4
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 89
    Width = 1090
    Height = 432
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 696
    Top = 536
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 800
    Top = 528
  end
  object RESTResponse1: TRESTResponse
    Left = 896
    Top = 536
  end
end
