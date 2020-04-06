import {Injectable} from '@angular/core';
import {HttpClient, HttpResponse} from "@angular/common/http";
import {ApiService} from "./api.service";
import {UserService} from "./user.service";
import {UserAdapter} from '../model/user';

@Injectable({
  providedIn: 'root'
})
export class RegisterService extends ApiService {
  private resource = '/users';

  constructor(private http: HttpClient, private adapter: UserAdapter, private userService: UserService) {
    super()
  }

  create(values) {
    return new Promise((resolve, reject) => {
      const data = {
        "user": {
          name: values.name,
          email: values.email,
          password: values.password,
        }
      };

      this.http.post(`${this.url_base}${this.resource}`, data, this.httpOptions)
        .subscribe((result: HttpResponse<any>) => {
          this.userService.setAccessToken(result.headers.get('Access-Token'));
          resolve(this.adapter.adapt(result.body.user));
        }, (error) => {
          reject(error);
        });
    });
  }
}
