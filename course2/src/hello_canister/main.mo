import Principal "mo:base/Principal";
import TrieSet "mo:base/TrieSet";
import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Option "mo:base/Option";

import IC "./ic";
import GLOBAL_INFO "./global_info";
/*
 传入参数说明：
 1. min 为最小通过提案的成员数量
 2. total 为总成员数
 3. members 成员
*/
actor class (min : Nat, total : Nat, members : [Principal]) = self {

    private let ic : IC.Self = actor "aaaaa-aa";
    
    //canisters
    private stable var canisters: Trie.Trie<Principal, GLOBAL_INFO.CanisterInfo> = Trie.empty<Principal, GLOBAL_INFO.CanisterInfo>();
    
    // members 集合 ， 数组转化为集合，防止重复
    private stable var memberSet : TrieSet.Set<Principal> = TrieSet.fromArray<Principal>(members, Principal.hash, Principal.equal);
    
    // proposals 集合
    private stable var proposals : Trie.Trie<Nat, GLOBAL_INFO.Proposal> = Trie.empty<Nat, GLOBAL_INFO.Proposal>();

    private stable var proposalId : Nat = 0 ; 

    // create canister 
    public shared ({caller}) func create_canister() : async ?Principal{
        // check
        assert (check_member(caller));
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
     public shared ({caller})  install_code(canister_id : Principal, wasm_module : ?GLOBAL_INFO.Wasm_module) : async () {
        await ic.install_code ({
            arg = [];
            wasm_module = Option.unwrap(wasm_module);
            mode = #install;
            canister_id = canister_id;
        });
       
    };
 

    // delete_canister
    public shared ({caller})  delete_canister(canister_id : Principal) : async () { 
        let res = await ic.delete_canister({canister_id = canister_id});
    };

     // start_canister
     public shared ({caller})  start_canister(canister_id : Principal) : async () { 
        let res = await ic.start_canister ({ canister_id = canister_id});
    };

    // stop_canister
     public shared ({caller})  stop_canister(canister_id : Principal) : async () { 
        let res = await ic.stop_canister ({ canister_id = canister_id});
    };
    // add_restricted
    private func add_restricted(canister_id : Principal) : () {
        let new_canister_info : GLOBAL_INFO.CanisterInfo = {
            canister_id = canister_id;
            is_restricted = true;
        };
        canisters := Trie.replace(canisters, {hash = Principal.hash(canister_id); key =  canister_id}, Principal.equal, ?new_canister_info).0;
    };
    
    // remove_restricted
    private func remove_restricted(canister_id : Principal) : () {
        let new_canister_info : GLOBAL_INFO.CanisterInfo = {
            canister_id = canister_id;
            is_restricted = false;
        };
        canisters := Trie.replace(canisters, {hash = Principal.hash(canister_id); key =  canister_id}, Principal.equal, ?new_canister_info).0;
    };
 

};