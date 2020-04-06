import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../services/user.service';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {User} from "../../../model/user";
import * as _ from "lodash";

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  maxChars: Number;
  user: User;
  postForm: FormGroup;
  constructor(private userService: UserService,
              private formBuilder: FormBuilder) {
    this.maxChars = 280;
  }


  getUser(): User{
    return this.user;
  }

  ngOnInit() {
    this.postForm = this.formBuilder.group({
      message: ['', Validators.required]
    });
    this.refreshUser();
  }

  refreshUser(){
    this.userService.show().then((response) => {
      this.user = this.userService.getUser();
    }).catch((err: any) => {});
  }

  createPost() {
    if (this.postForm.invalid) {
      return;
    } else {
      this.userService.post(this.postForm.value).then((response) => {
        this.postForm.controls["message"].setValue('');
        this.refreshUser();
      }).catch((err: any) => {});
    }
  }
}
