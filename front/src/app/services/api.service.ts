import { Injectable } from '@angular/core';
import { HttpHeaders } from "@angular/common/http";
import {LOCAL_STORAGE, StorageService} from 'ngx-webstorage-service';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  protected url_base: string;
  protected httpOptions: {};

  constructor() {
    this.url_base = 'http://localhost:3000/api/v1';
    this.httpOptions = {
      headers: new HttpHeaders(
        { 'Content-Type': 'application/json' }),
      observe: 'response' as 'response'
    };
  }
}
