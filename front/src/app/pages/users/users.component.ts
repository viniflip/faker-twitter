import { Component, OnInit } from '@angular/core';
import {UserService} from "../../services/user.service";
import * as _ from 'lodash';
import {User} from "../../model/user";
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.css']
})
export class UsersComponent implements OnInit {
  users: any;
  currentUser: User;
  constructor(private userService: UserService,
              private toastr: ToastrService,) { }

  ngOnInit() {
    this.refreshUsers();
    this.refreshUser();
    this.currentUser = this.userService.getUser();
  }

  refreshUsers(){
    this.userService.index().then((response) => {
      this.users = response;
    }).catch((err: any) => {});
  }

  refreshUser(){
    this.userService.show().then((response) => {
      this.currentUser = this.userService.getUser();
    }).catch((err: any) => {});
  }

  checkFollowing(user){
    console.log(this.currentUser);
    return _.findIndex(this.currentUser.followingRelationships, function(o) { return o["following"]["id"] == user.id; }) !== -1;
  }

  follow(user){
    this.userService.follow(user.id).then((response) => {
      this.toastr.success(`Following ${user.name}`, 'Success' );
      this.refreshUser();
    }).catch((err: any) => {});
  }

  unFollow(user){
    this.userService.unFollow(user.id).then((response) => {
      this.toastr.success(`Unfollowed ${user.name}`, 'Success' );
      this.refreshUser();
    }).catch((err: any) => {});
  }

}
