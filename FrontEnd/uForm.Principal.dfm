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
  OnShow = FormShow
  TextHeight = 15
  object btnListarTarefas: TButton
    Left = 0
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Listar Tarefas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnListarTarefasClick
  end
  object btnNovaTarefa: TButton
    Left = 300
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Incluir'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnNovaTarefaClick
  end
  object btnAtualizarStatus: TButton
    Left = 598
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Atualizar Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnAtualizarStatusClick
  end
  object btnRemovarTarefa: TButton
    Left = 897
    Top = 527
    Width = 193
    Height = 41
    Caption = 'Remover'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnRemovarTarefaClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1090
    Height = 57
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object lblTotalTarefas: TLabel
      Left = 24
      Top = 15
      Width = 152
      Height = 17
      Caption = 'N'#250'mero total de tarefas:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMediaPrioridade: TLabel
      Left = 344
      Top = 15
      Width = 268
      Height = 17
      Caption = 'M'#233'dia de prioridade das tarefas pendentes:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotalConcluidas: TLabel
      Left = 712
      Top = 15
      Width = 327
      Height = 17
      Caption = 'Quantidade de tarefas conclu'#237'das nos '#250'ltimos 7 dias:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 57
    Width = 1090
    Height = 464
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 936
    Top = 200
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 944
    Top = 296
  end
  object RESTResponse1: TRESTResponse
    Left = 952
    Top = 384
  end
end
