import { Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { UserService } from './user.service';
import { UserAdapter } from '../model/user'
import { HttpClient } from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class LoginService extends ApiService {
  private resource = '/users/login';

  constructor(public http: HttpClient, private adapter: UserAdapter, private userService: UserService) {
    super();
  }

  create(values) {
    return new Promise((resolve, reject) => {
      const data = {
        "auth": {
          email: values.email,
          password: values.password,
        }
      };
      this.http.post(`${this.url_base}${this.resource}`, data, this.httpOptions)
        .subscribe((result: any) => {
          this.userService.setAccessToken(result.headers.get('Access-Token'));
          resolve(true);
        }, (error) => {
          reject(error);
        });
    });
  }
}
