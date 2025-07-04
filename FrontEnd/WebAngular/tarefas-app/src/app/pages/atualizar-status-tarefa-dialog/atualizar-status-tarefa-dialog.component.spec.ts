import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AtualizarStatusTarefaDialogComponent } from './atualizar-status-tarefa-dialog.component';

describe('AtualizarStatusTarefaDialogComponent', () => {
  let component: AtualizarStatusTarefaDialogComponent;
  let fixture: ComponentFixture<AtualizarStatusTarefaDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AtualizarStatusTarefaDialogComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AtualizarStatusTarefaDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
