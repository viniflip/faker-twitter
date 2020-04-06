import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { LoginService } from '../../services/login.service';
import { Router } from '@angular/router';
import { ToastrService } from "ngx-toastr";
import {RegisterService} from "../../services/register.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup;
  registerForm: FormGroup;
  constructor(private formBuilder: FormBuilder,
              private router: Router,
              private toastr: ToastrService,
              public loginService: LoginService,
              public registerService: RegisterService) { }

  ngOnInit() {
    this.loginForm = this.formBuilder.group({
      email: ['', Validators.required],
      password: ['', Validators.required]
    });

    this.registerForm = this.formBuilder.group({
      name: ['', Validators.required],
      email: ['', Validators.required],
      password: ['', Validators.required],
      confirm: ['', Validators.required],
    });
  }

  login(){
    if (this.loginForm.invalid) {
      return;
    } else {
      this.loginService.create(this.loginForm.value).then((response) => {
        this.router.navigateByUrl('/user');
      }).catch((err: any) => {
        this.toastr.error(err.message, 'Error' );
      });
    }
  }

  register(){
    if (this.registerForm.invalid) {
      return;
    } else {
      this.registerService.create(this.registerForm.value).then((response) => {
        this.router.navigateByUrl('/user');
      }).catch((err: any) => {
        this.toastr.error(err.message, 'Error' );
      });
    }

  }

}
