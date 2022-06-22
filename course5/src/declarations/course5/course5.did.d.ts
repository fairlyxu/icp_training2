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
export interface anon_class_19_1 {
  'delete_canister' : ActorMethod<[Principal], undefined>,
  'install_code' : ActorMethod<[Principal, [] | [Wasm_module]], undefined>,
  'make_proposal' : ActorMethod<
    [OperationType, Principal, [] | [Wasm_module]],
    undefined,
  >,
  'remove_proposal' : ActorMethod<[bigint], undefined>,
  'start_canister' : ActorMethod<[Principal], undefined>,
  'stop_canister' : ActorMethod<[Principal], undefined>,
  'vote_proposal' : ActorMethod<[bigint, boolean], undefined>,
}
export interface _SERVICE extends anon_class_19_1 {}
