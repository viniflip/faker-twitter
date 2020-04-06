// app/core/adapter.ts
export interface Adapter<T> {
  adapt(item: any, other: any): T;
}
