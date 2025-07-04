import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule, FormsModule } from '@angular/forms';
import { MatDialogRef, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { CommonModule } from '@angular/common';

import { TarefaService } from '../../services/tarefa.service';

@Component({
  selector: 'app-nova-tarefa-dialog',
  standalone: true,
  templateUrl: './nova-tarefa-dialog.component.html',
  styleUrls: ['./nova-tarefa-dialog.component.css'], // <- importante
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatSnackBarModule
  ]
})
export class NovaTarefaDialogComponent {
  tarefaForm: FormGroup;

  constructor(
    private dialogRef: MatDialogRef<NovaTarefaDialogComponent>,
    private fb: FormBuilder,
    private tarefaService: TarefaService,
    private snackBar: MatSnackBar
  ) {
    this.tarefaForm = this.fb.group({
      titulo: ['', Validators.required],
      descricao: [''],
      prioridade: [2, Validators.required],
      status: ['Aberto', Validators.required]
    });
  }

  private mapToApiFormat(form: any): any {
    return {
      Titulo: form.titulo,
      Descricao: form.descricao,
      Prioridade: form.prioridade,
      Status: form.status
    };
  }

  salvar(): void {
    if (this.tarefaForm.invalid) return;

    const novaTarefa = this.mapToApiFormat(this.tarefaForm.value);
    console.log('Enviando tarefa:', novaTarefa);

    this.tarefaService.criar(novaTarefa).subscribe({
      next: () => {
        this.snackBar.open('Tarefa criada com sucesso!', 'Fechar', { duration: 3000 });
        this.dialogRef.close(true);
      },
      error: (err) => {
        console.log('Tarefa:', novaTarefa);
        console.error('Erro ao salvar:', err);
        this.snackBar.open('Erro ao criar tarefa.', 'Fechar', { duration: 3000 });
      }
    });
  }

  cancelar(): void {
    this.dialogRef.close(false);
  }
}