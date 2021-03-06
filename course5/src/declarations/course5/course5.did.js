export const idlFactory = ({ IDL }) => {
  const Wasm_module = IDL.Vec(IDL.Nat8);
  const OperationType = IDL.Variant({
    'addRestricted' : IDL.Null,
    'stop' : IDL.Null,
    'removeRestricted' : IDL.Null,
    'delete' : IDL.Null,
    'create' : IDL.Null,
    'start' : IDL.Null,
    'install' : IDL.Null,
  });
  const anon_class_19_1 = IDL.Service({
    'delete_canister' : IDL.Func([IDL.Principal], [], []),
    'install_code' : IDL.Func([IDL.Principal, IDL.Opt(Wasm_module)], [], []),
    'make_proposal' : IDL.Func(
        [OperationType, IDL.Principal, IDL.Opt(Wasm_module)],
        [],
        [],
      ),
    'remove_proposal' : IDL.Func([IDL.Nat], [], []),
    'start_canister' : IDL.Func([IDL.Principal], [], []),
    'stop_canister' : IDL.Func([IDL.Principal], [], []),
    'vote_proposal' : IDL.Func([IDL.Nat, IDL.Bool], [], []),
  });
  return anon_class_19_1;
};
export const init = ({ IDL }) => {
  return [
    IDL.Record({ 'members' : IDL.Vec(IDL.Principal), 'minimum' : IDL.Nat }),
  ];
};
