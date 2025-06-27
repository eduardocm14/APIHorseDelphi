import { Component, OnInit, ViewChild, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { TarefaService } from '../../services/tarefa.service';
import { Tarefa } from '../../models/tarefa.model';
import { CommonModule } from '@angular/common';
import { MatTableModule, MatTableDataSource } from '@angular/material/table';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { FormsModule } from '@angular/forms';
import { forkJoin } from 'rxjs';

@Component({
  selector: 'app-tarefas',
  standalone: true,
  imports: [
    CommonModule,
    MatTableModule,
    MatPaginatorModule,
    MatIconModule,
    MatButtonModule,
    MatSelectModule,
    MatSnackBarModule,
    FormsModule
  ],
  templateUrl: './tarefas.component.html',
  styleUrls: ['./tarefas.component.css']
})
export class TarefasComponent implements OnInit, AfterViewInit {
  dataSource = new MatTableDataSource<Tarefa>();
  displayedColumns: string[] = ['id', 'titulo', 'descricao', 'prioridade', 'status', 'criacao', 'conclusao', 'acoes'];
  statusList: string[] = ['Pendente', 'Em Andamento', 'Concluída'];

  totalTarefas = 0;
  mediaPrioridade = 0;
  totalConcluidas = 0;

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private tarefaService: TarefaService,
    private snackBar: MatSnackBar,
    private cdRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.carregarTarefas();
    this.carregarEstatisticas();
  }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
  }

  carregarTarefas(): void {
    this.tarefaService.listar().subscribe({
      next: (dados) => {
        console.log('[DEBUG] Tarefas recebidas:', dados);
        this.dataSource.data = dados;
        this.cdRef.detectChanges();
      },
      error: (erro) => {
        const mensagem = erro.status === 0
          ? 'Erro de conexão com o servidor. Verifique se a API está rodando.'
          : `Erro ao carregar tarefas: ${erro.message}`;
        this.snackBar.open(mensagem, 'Fechar', { duration: 5000 });
      }
    });
  }

  carregarEstatisticas(): void {
    forkJoin({
      total: this.tarefaService.buscarTotal(),
      media: this.tarefaService.buscarMediaPrioridade(),
      concluidas: this.tarefaService.buscarTotalConcluidas7Dias()
    }).subscribe({
      next: ({ total, media, concluidas }) => {
        this.totalTarefas = total.totalTarefas;
        this.mediaPrioridade = media.media;
        this.totalConcluidas = concluidas.totalConcluidas;
        this.cdRef.detectChanges();
      },
      error: () => {
        this.snackBar.open('Erro ao carregar estatísticas.', 'Fechar', { duration: 5000 });
      }
    });
  }

  atualizarStatus(tarefa: Tarefa): void {
    if (!tarefa.id || !tarefa.status) return;

    this.tarefaService.atualizarStatus(tarefa.id, tarefa.status).subscribe({
      next: () => this.snackBar.open('Status atualizado com sucesso!', 'Fechar', { duration: 3000 }),
      error: () => this.snackBar.open('Erro ao atualizar status.', 'Fechar', { duration: 3000 })
    });
  }

  removerTarefa(id: string): void {
    this.tarefaService.remover(id).subscribe({
      next: () => {
        this.snackBar.open('Tarefa removida com sucesso!', 'Fechar', { duration: 3000 });
        this.carregarTarefas();
        this.carregarEstatisticas();
      },
      error: () => this.snackBar.open('Erro ao remover tarefa.', 'Fechar', { duration: 3000 })
    });
  }
}