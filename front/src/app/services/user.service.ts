import {Inject, Injectable} from '@angular/core';
import {LOCAL_STORAGE, StorageService} from 'ngx-webstorage-service';
import {User, UserAdapter} from "../model/user";
import {ApiService} from "./api.service";
import {HttpClient, HttpHeaders} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class UserService extends ApiService {
  private resource = '/users';
  private urlCurrent = 'me';
  private urlPost = '/posts';
  private user: User;

  constructor(@Inject(LOCAL_STORAGE) private storage: StorageService, private adapter: UserAdapter, private http: HttpClient) {
    super();
  }

  public setUser(user) {
    this.user = user;
  }

  public getUser(): User {
    return this.user;
  }

  public setAccessToken(token: string):void {
    this.storage.set('Access-Token', token);
  }

  public removeAccessToken():void {
    this.storage.clear();
  }

  public getAccessToken():boolean {
    return this.storage.get('Access-Token');
  }

  show() {
    this.httpOptions = {
      headers: new HttpHeaders(
        { 'Content-Type': 'application/json', 'Authorization': `bearer ${this.storage.get('Access-Token')}` })
    };
    return new Promise((resolve, reject) => {
      this.http.get(`${this.url_base}${this.resource}/${this.urlCurrent}`, this.httpOptions)
        .subscribe((result: any) => {
          this.setUser(this.adapter.adapt(result.user));
          resolve(true);
        }, (error) => {
          reject(error);
        });
    });
  }

  index(){
    this.httpOptions = {
      headers: new HttpHeaders(
        { 'Content-Type': 'application/json', 'Authorization': `bearer ${this.storage.get('Access-Token')}` })
    };
    return new Promise((resolve, reject) => {
      this.http.get(`${this.url_base}${this.resource}`, this.httpOptions)
        .subscribe((result: any) => {
          resolve(result.users);
        }, (error) => {
          reject(error);
        });
    });
  }

  post(value) {
    this.httpOptions = {
      headers: new HttpHeaders(
        { 'Content-Type': 'application/json', 'Authorization': `bearer ${this.storage.get('Access-Token')}` })
    };
    return new Promise((resolve, reject) => {
      const data = {
        "post": {
          message: value.message,
        }
      };

      this.http.post(`${this.url_base}${this.urlPost}`, data, this.httpOptions)
        .subscribe((result: any) => {
          resolve(true);
        }, (error) => {
          reject(error);
        });
    });
  }

  follow(id) {
    this.httpOptions = {
      headers: new HttpHeaders(
        { 'Content-Type': 'application/json', 'Authorization': `bearer ${this.storage.get('Access-Token')}` })
    };
    return new Promise((resolve, reject) => {
      this.http.post(`${this.url_base}${this.resource}/${id}/follow`, null, this.httpOptions)
        .subscribe((result: any) => {
          resolve(true);
        }, (error) => {
          reject(error);
        });
    });
  }

  unFollow(id) {
    this.httpOptions = {
      headers: new HttpHeaders(
        { 'Content-Type': 'application/json', 'Authorization': `bearer ${this.storage.get('Access-Token')}` })
    };
    return new Promise((resolve, reject) => {
      this.http.post(`${this.url_base}${this.resource}/${id}/unfollow`, null, this.httpOptions)
        .subscribe((result: any) => {
          resolve(true);
        }, (error) => {
          reject(error);
        });
    });
  }


}
