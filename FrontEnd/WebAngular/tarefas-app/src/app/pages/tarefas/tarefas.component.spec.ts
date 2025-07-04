import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TarefasComponent } from './tarefas.component';

describe('Tarefas', () => {
  let component: TarefasComponent;
  let fixture: ComponentFixture<TarefasComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TarefasComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TarefasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
