export const idlFactory = ({ IDL }) => {
  const anon_class_13_1 = IDL.Service({
    'create_canister' : IDL.Func([], [IDL.Opt(IDL.Principal)], []),
  });
  return anon_class_13_1;
};
export const init = ({ IDL }) => {
  return [IDL.Nat, IDL.Nat, IDL.Vec(IDL.Principal)];
};
