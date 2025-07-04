import { Component, Inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { CommonModule } from '@angular/common';
import { Tarefa } from '../../models/tarefa.model';
import { TarefaService } from '../../services/tarefa.service';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';

@Component({
  selector: 'app-atualizar-status-dialog',
  standalone: true,
  templateUrl: './atualizar-status-tarefa-dialog.component.html',
  styleUrls: ['./atualizar-status-tarefa-dialog.component.css'],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatSnackBarModule
  ]
})
export class AtualizarStatusDialogComponent {
  statusForm: FormGroup;
  statusOpcoes: string[] = ['Pendente', 'Em Andamento', 'Concluído'];

  constructor(
    private dialogRef: MatDialogRef<AtualizarStatusDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public tarefa: Tarefa,
    private fb: FormBuilder,
    private tarefaService: TarefaService,
    private snackBar: MatSnackBar
  ) {
    this.statusForm = this.fb.group({
      status: [tarefa.status, Validators.required]
    });
  }

  salvar(): void {
    const novoStatus = this.statusForm.value.status;
    if (this.tarefa && this.tarefa.id !== undefined && this.tarefa.id !== null) {
      this.tarefaService.atualizarStatus(this.tarefa.id.toString(), novoStatus).subscribe({
        next: () => {
          this.snackBar.open('Status atualizado com sucesso!', 'Fechar', { duration: 3000 });
          this.dialogRef.close(true);
        },
        error: (err) => {
          console.error('Erro ao atualizar status:', err);
          this.snackBar.open('Erro ao atualizar status.', 'Fechar', { duration: 3000 });
        }
      });
    } else {
      this.snackBar.open('Tarefa inválida. Não foi possível atualizar o status.', 'Fechar', { duration: 3000 });
    }
  }

  cancelar(): void {
    this.dialogRef.close(false);
  }
}
