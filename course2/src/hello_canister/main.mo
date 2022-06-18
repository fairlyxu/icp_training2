import Principal "mo:base/Principal";
import TrieSet "mo:base/TrieSet";
import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Option "mo:base/Option";

import IC "./ic";
import GLOBAL_INFO "./global_info";
 

actor class (threshold : Nat, total : Nat, members : [Principal]) = self {

    private let ic : IC.Self = actor "aaaaa-aa";
    
    //canisters
    private stable var canisters: Trie.Trie<Principal, GLOBAL_INFO.CanisterInfo> = Trie.empty<Principal, GLOBAL_INFO.CanisterInfo>();
    // members
    private stable var memberSet : TrieSet.Set<Principal> = TrieSet.fromArray<Principal>(members, Principal.hash, Principal.equal);
    // proposals
    private stable var proposals : Trie.Trie<Nat, GLOBAL_INFO.Proposal> = Trie.empty<Nat, GLOBAL_INFO.Proposal>();

    private stable var proposalId : Nat = 0 ;
 
 

   private func checkMember(member: Principal) : Bool {
        TrieSet.mem(memberSet, member, Principal.hash(member), Principal.equal);
    };

    // create canister 
    public shared ({caller}) func create_canister() : async ?Principal{
        // check
        assert (checkMember(caller));
        let settings = {
            freezing_threshold = null;
            controllers = ?[Principal.fromActor(self)];
            memory_allocation = null;
            compute_allocation = null;
        };
 
        let create_res  = await ic.create_canister({settings = ? settings});

        //appending canister to canisters
        canisters := Trie.put(
            canisters, 
            {hash = Principal.hash(create_res.canister_id); key = create_res.canister_id}, 
            Principal.equal, 
            {canister_id = create_res.canister_id; is_restricted = false}
        ).0;
        return ?create_res.canister_id;
    };

    // install 
    private func install_code(canister_id : Principal, wasm_module : ?GLOBAL_INFO.Wasm_module) : async () {
        await ic.install_code ({
            arg = [];
            wasm_module = Option.unwrap(wasm_module);
            mode = #install;
            canister_id = canister_id;
        });
       
    };
 

    // delete_canister
    private func delete_canister(canister_id : Principal) : async () { 
        let res = await ic.delete_canister({canister_id = canister_id});
    };

     // start_canister
    private func start_canister(canister_id : Principal) : async () { 
        let res = await ic.start_canister ({ canister_id = canister_id});
    };

    // stop_canister
    private func stop_canister(canister_id : Principal) : async () { 
        let res = await ic.stop_canister ({ canister_id = canister_id});
    };
 

};