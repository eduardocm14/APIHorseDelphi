import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NovaTarefaDialogComponent } from './nova-tarefa-dialog.component';

describe('NovaTarefaDialogComponent', () => {
  let component: NovaTarefaDialogComponent;
  let fixture: ComponentFixture<NovaTarefaDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NovaTarefaDialogComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(NovaTarefaDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
