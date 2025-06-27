import { Routes } from '@angular/router';
import { TarefasComponent } from './pages/tarefas/tarefas.component';

export const routes: Routes = [
  { path: '', redirectTo: 'tarefas', pathMatch: 'full' },
  { path: 'tarefas', component: TarefasComponent }
];
