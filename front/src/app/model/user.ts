import {Adapter} from '../core/adapter';
import {Injectable} from '@angular/core';

export class User {
  public id: number;
  public name: string;
  public email: string;
  public createdAt: string;
  public posts: [];
  public followerRelationships: any;
  public followingRelationships: any;
  constructor(id: number, name: string, email: string, posts: [], followerRelationships: any, followingRelationships: any, createdAt: string) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.posts = posts;
    this.followerRelationships = followerRelationships;
    this.followingRelationships = followingRelationships;
    this.createdAt = createdAt;
  }
}

@Injectable({
  providedIn: 'root'
})
export class UserAdapter implements Adapter<User> {
  adapt(user: any): User {
    return new User(
      user.id,
      user.name,
      user.email,
      user.posts,
      user.follower_relationships,
      user.following_relationships,
      user.created_at
    );
  }
}
