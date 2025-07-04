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
import { MatDialog } from '@angular/material/dialog';
import { NovaTarefaDialogComponent } from '../nova-tarefa-dialog/nova-tarefa-dialog.component';
import { AtualizarStatusDialogComponent } from '../atualizar-status-tarefa-dialog/atualizar-status-tarefa-dialog.component';
import { ConfirmDialogComponent } from '..//confirm-dialog/confirm-dialog.component';

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
    FormsModule,
    ConfirmDialogComponent
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
  dataHoraCriacao: Date | null = null;

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private tarefaService: TarefaService,
    private snackBar: MatSnackBar,
    private cdRef: ChangeDetectorRef,
    private dialog: MatDialog,
  ) { }

  ngOnInit(): void {
    this.carregarTarefas();
    this.carregarEstatisticas();
    this.dataHoraCriacao = new Date();
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

  alterarStatus(tarefa: Tarefa, novoStatus: string): void {
    if (!confirm(`Deseja alterar o status da tarefa "${tarefa.titulo}" para "${novoStatus}"?`)) return;

    if (tarefa.id === undefined || tarefa.id === null) {
      this.snackBar.open('ID da tarefa não definido. Não é possível alterar o status.', 'Fechar', { duration: 3000 });
      return;
    }

    this.tarefaService.atualizarStatus(tarefa.id.toString(), novoStatus).subscribe({
      next: () => {
        this.snackBar.open('Status atualizado com sucesso!', 'Fechar', { duration: 3000 });
        this.carregarTarefas(); // ou recarregue a lista de tarefas
      },
      error: (err) => {
        console.error('Erro ao atualizar status:', err);
        this.snackBar.open('Erro ao atualizar status da tarefa.', 'Fechar', { duration: 3000 });
      }
    });
  }

  removerTarefa(tarefa: Tarefa): void {
    console.log('[DEBUG] tarefa recebida para exclusão:', tarefa);
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      data: {
        mensagem: `Deseja realmente excluir a tarefa "${tarefa.titulo}"?`
      }
    });

    dialogRef.afterClosed().subscribe(confirmado => {
      if (confirmado) {
        if (tarefa.id === undefined || tarefa.id === null) {
          this.snackBar.open('ID da tarefa não definido.', 'Fechar', { duration: 3000 });
          return;
        }

        this.tarefaService.remover(tarefa.id.toString()).subscribe({
          next: () => {
            this.snackBar.open('Tarefa excluída com sucesso!', 'Fechar', { duration: 3000 });
            this.carregarTarefas();
          },
          error: () => {
            this.snackBar.open('Erro ao excluir tarefa.', 'Fechar', { duration: 3000 });
          }
        });
      }
    });
  }

  prioridadeParaTexto(value: number): string {
    switch (value) {
      case 1: return 'Baixo';
      case 2: return 'Médio';
      case 3: return 'Alto';
      default: return 'Desconhecida';
    }
  }

  abrirFormulario(): void {
    const dialogRef = this.dialog.open(NovaTarefaDialogComponent, {
      width: '500px'
    });

    dialogRef.afterClosed().subscribe((resultado) => {
      if (resultado) {
        this.carregarTarefas(); // recarrega a lista se salvou
      }
    });
  }

  abrirDialogAtualizarStatus(tarefa: Tarefa): void {
    const dialogRef = this.dialog.open(AtualizarStatusDialogComponent, {
      width: '400px',
      data: tarefa
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.carregarTarefas(); // Atualize a tabela
      }
    });
  }
}