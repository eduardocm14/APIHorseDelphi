export interface Tarefa {
  id?: string;
  titulo: string;
  descricao: string;
  prioridade: number; // 1: Baixo, 2: Médio, 3: Alto
  status: string;
  dataCriacao?: string;
  dataConclusao?: string;
}