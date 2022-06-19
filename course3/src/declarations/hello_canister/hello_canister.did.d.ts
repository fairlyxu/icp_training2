import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type OperationType = { 'addRestricted' : null } |
  { 'stop' : null } |
  { 'removeRestricted' : null } |
  { 'delete' : null } |
  { 'create' : null } |
  { 'start' : null } |
  { 'install' : null };
export type Wasm_module = Array<number>;
export interface anon_class_17_1 {
  'create_canister' : ActorMethod<[], [] | [Principal]>,
  'make_proposal' : ActorMethod<
    [OperationType, Principal, [] | [Wasm_module]],
    undefined,
  >,
  'vote_proposal' : ActorMethod<[bigint, boolean], undefined>,
}
export interface _SERVICE extends anon_class_17_1 {}
