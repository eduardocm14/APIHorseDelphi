-- Criar o banco de dados
CREATE DATABASE ApiHorse;
GO

-- Selecionar o banco de dados
USE ApiHorse;
GO

-- Criar a tabela Tarefas
CREATE TABLE Tarefas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(255) NOT NULL,
    Descricao NVARCHAR(MAX) NULL,
    Prioridade INT NOT NULL, -- 1'Baixo', 2'Médio', 3'Alto'
    Status NVARCHAR(50) NOT NULL, -- 'Aguardando', 'Andamento', 'Concluída', etc.
    DataCriacao DATETIME DEFAULT GETDATE() NOT NULL,
    DataConclusao DATETIME NULL
);
