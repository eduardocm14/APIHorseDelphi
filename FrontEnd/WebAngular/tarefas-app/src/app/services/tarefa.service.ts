import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Tarefa } from '../models/tarefa.model';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class TarefaService {
  private baseUrl = 'http://localhost:9000/v1/tarefas'; // Substituir com a URL real da API
  private headers = new HttpHeaders({
    'Content-Type': 'application/json',
    'x-api-key': 'minha-chave-secreta-123'
  });

  constructor(private http: HttpClient) {}

  listar(): Observable<Tarefa[]> {
    return this.http.get<any[]>(this.baseUrl, { headers: this.headers }).pipe(
      map(dados =>
        dados.map(t => ({
          id: t.ID,
          titulo: t.Titulo,
          descricao: t.Descricao,
          prioridade: t.Prioridade,
          status: t.Status,
          dataCriacao: t.DataCriacao,
          dataConclusao: t.DataConclusao
        }))
      )
    );
  }

  criar(tarefa: Tarefa): Observable<any> {
    return this.http.post(this.baseUrl, tarefa, { headers: this.headers });
  }

  atualizarStatus(id: string, novoStatus: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/${id}/atualizar-status`, { status: novoStatus }, { headers: this.headers });
  }

  remover(id: string): Observable<any> {
    return this.http.delete(`${this.baseUrl}/${id}`, { headers: this.headers });
  }

  buscarTotal(): Observable<{ totalTarefas: number }> {
    return this.http.get<{ totalTarefas: number }>(`${this.baseUrl}/total`, { headers: this.headers });
  }

  buscarMediaPrioridade(): Observable<{ media: number }> {
    return this.http.get<{ media: number }>(`${this.baseUrl}/media-prioridade-pendentes`, { headers: this.headers });
  }

  buscarTotalConcluidas7Dias(): Observable<{ totalConcluidas: number }> {
    return this.http.get<{ totalConcluidas: number }>(`${this.baseUrl}/concluidas-ultimos-7-dias`, { headers: this.headers });
  }
}