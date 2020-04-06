import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './pages/login/login.component';
import { HomeComponent } from './pages/user/home/home.component';
import {UsersComponent} from "./pages/users/users.component";

const routes: Routes = [
  { path: '', component: LoginComponent },
  { path: 'user', component: HomeComponent },
  { path: 'users', component: UsersComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
