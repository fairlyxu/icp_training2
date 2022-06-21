 
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
 1. min 为最小提案数量
 2. total 为总人数
 3. members 成员
*/
actor class (min : Nat, total : Nat, members : [Principal]) = self {

    private let ic : IC.Self = actor("aaaaa-aa");
    
    //canisters
    private stable var canisters: Trie.Trie<Principal, GLOBAL_INFO.CanisterInfo> = Trie.empty<Principal, GLOBAL_INFO.CanisterInfo>();
    
    // members 集合 ， 数组转化为集合，防止重复
    private stable var memberSet : TrieSet.Set<Principal> = TrieSet.fromArray<Principal>(members, Principal.hash, Principal.equal);
    
    // proposals 集合
    private stable var proposals : Trie.Trie<Nat, GLOBAL_INFO.Proposal> = Trie.empty<Nat, GLOBAL_INFO.Proposal>();

    private stable var proposalId : Nat = 0 ; 
    
    // 查询所有成员 
    public shared({ caller }) func show_members() : async [] { 
      Iter.toArray(memberSet.vals());
    };
    //查询所有的提案
    public shared({ caller }) func show_proposals() : async [GLOBAL_INFO.Proposal] { 
      Iter.toArray(proposals.vals());
    };

    //显示所有的Canister
    public shared func show_canisters() : async [GLOBAL_INFO.CanisterInfo] {
      Iter.toArray(canisters.vals());
    }; 

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
    public shared ({caller}) func install_code(canister_id : Principal, wasm_module : ?GLOBAL_INFO.Wasm_module) : async () {
        if(caller != Principal.fromActor(this)){
          //确认是否被限权
          assert (check_member(caller));
          make_proposal (#removeRestricted, canister_id,wasm_module) ;  
        }; 
        await ic.install_code ({
            arg = [];
            wasm_module = Option.unwrap(wasm_module);
            mode = #install;
            canister_id = canister_id;
        }); 
    };
 

    // delete_canister
    public shared ({caller}) func delete_canister(canister_id : Principal) : async () { 
        
        let res = await ic.delete_canister({canister_id = canister_id});
    };

     // start_canister
    public shared ({caller}) func start_canister(canister_id : Principal) : async () {  
        
        let res = await ic.start_canister ({ canister_id = canister_id});
    };

    // stop_canister
    public shared ({caller}) func stop_canister(canister_id : Principal) : async () { 
        let res = await ic.stop_canister ({ canister_id = canister_id});
    };
    // add_restricted
    public func add_restricted(canister_id : Principal) : () { 
      let new_canister_info : GLOBAL_INFO.CanisterInfo = {
            canister_id = canister_id;
            is_restricted = true;
        };
        canisters := Trie.replace(canisters, {hash = Principal.hash(canister_id); key =  canister_id}, Principal.equal, ?new_canister_info).0;
    };
    
    // remove_restricted
    public func remove_restricted(canister_id : Principal) : () {
        let new_canister_info : GLOBAL_INFO.CanisterInfo = {
            canister_id = canister_id;
            is_restricted = false;
        };
        canisters := Trie.replace(canisters, {hash = Principal.hash(canister_id); key =  canister_id}, Principal.equal, ?new_canister_info).0;
    };

    // proposal

     /// 1.生成一个提案
    public shared ({caller})  func  make_proposal (operation_type: GLOBAL_INFO.OperationType, canister_id : Principal, wasm_module: ?GLOBAL_INFO.Wasm_module) : async () {
            //1. 确认是否是团队成员之一
            assert (check_member(caller));
            //2.  确认canister 是否存在
            assert (check_canisterExist(canister_id)); 

            //3. 确认该提案是否有权限限制
            switch (operation_type) { 
                //3.1 如果没有的话就增加 add Restricted, 
                case (#addRestricted) { assert(not check_restricted(canister_id)) };
                //3.2 否则的话就不增加权限限制 /start stop install delete, check canister restricted
                case (_) { assert( check_restricted(canister_id)); };
            };
            //4. 添加到提案队列
            push_proposal(caller, operation_type, canister_id, wasm_module);
    };

    //2. 对提案投票 
    public shared ({caller}) func vote_proposal (proposal_id: Nat, approve: Bool) : async () {
        switch (Trie.get(proposals, {hash = Hash.hash(proposal_id); key = proposal_id}, Nat.equal)) {
            case (?proposal){
                var proposal_approvers = proposal.proposal_approvers;
                var proposal_approve_num = proposal.proposal_approve_num;
                var proposal_refusers = proposal.proposal_refusers;
                var proposal_refuse_num = proposal.proposal_refuse_num;
                //更新提案的赞同和反对的统计数据以及明细数据
                if(approve){
                    proposal_approvers := Array.append([caller], proposal_approvers);
                    proposal_approve_num += 1;
                } else {
                    proposal_refusers := Array.append([caller], proposal_refusers);
                    proposal_refuse_num += 1;
                };
                 //更新提案状态  
                let new_proposal = {
                    proposal_id = proposal.proposal_id;
                    proposal_maker  = proposal.proposal_maker;
                    operation_type = proposal.operation_type;
                    canister_id = proposal.canister_id;
                    wasm_module = proposal.wasm_module;
                    proposal_approve_num = proposal_approve_num;
                    proposal_approvers = proposal_approvers;
                    proposal_refuse_num = proposal_refuse_num;
                    proposal_refusers = proposal_refusers;
                    proposal_completed = false;
                };

                proposals := Trie.replace(proposals, {hash = Hash.hash(proposal_id); key =  proposal_id}, Nat.equal, ?new_proposal).0;
                //判断是否满足执行条件，对提案就行执行
                if ((proposal_approve_num >= min) and (not proposal.proposal_completed)) { 
                    await execute_proposal(new_proposal);

                };

            };
            case (_) { };
        }
    };

    // 3.执行提案
    private func execute_proposal (proposal : GLOBAL_INFO.Proposal) : async () {
        switch (proposal.operation_type) {
            case (#addRestricted) {
                add_restricted(proposal.canister_id);
            };
            case (#removeRestricted) {
                remove_restricted(proposal.canister_id);
            };
            case (#create) {
                let res = await create_canister();
            };
            case (#start) {
                await start_canister(proposal.canister_id);
            };
            case (#stop) {
                await stop_canister(proposal.canister_id);
            };
            case (#install) {
                await install_code(proposal.canister_id, proposal.wasm_module);
            };
            case (#delete) {
                await delete_canister(proposal.canister_id);
            };
        };
        update_proposal(proposal,true) 
      
    };
 

    // 4.提交提案
    private func push_proposal (caller: Principal, operation_type: GLOBAL_INFO.OperationType, canister_id: Principal, wasm_module: ?GLOBAL_INFO.Wasm_module) {
        proposalId += 1;
        proposals :=  Trie.put (proposals, {hash = Hash.hash(proposalId); key =  proposalId}, Nat.equal, {
            proposal_id = proposalId;
            proposal_maker  = caller;
            operation_type = operation_type;
            canister_id = canister_id;
            wasm_module = wasm_module;
            proposal_approve_num = 0;
            proposal_approvers = [];
            proposal_refuse_num = 0;
            proposal_refusers = [];
            proposal_completed = false;
        }).0;
    };

    //检查是否是团队成员
    private func check_member(member: Principal) : Bool {
        TrieSet.mem(memberSet, member, Principal.hash(member), Principal.equal);
    };

    //检查canister是否存在
    private func check_canisterExist(canister_id: Principal) : Bool {
        switch (Trie.get(canisters, {hash = Principal.hash(canister_id); key =  canister_id}, Principal.equal)) {
            case null return false;
            case _ return true;
        };
    };
    //检查是否限权
    private func check_restricted (canister_id : Principal) : Bool {
        switch(Trie.get(canisters, {hash = Principal.hash(canister_id); key = canister_id}, Principal.equal)) {
            case (?canister_info) return canister_info.is_restricted;
            case null return false;

        };
    };

    // 更新提案集合中的提案状态
    private func update_proposal(proposal : GLOBAL_INFO.Proposal, proposal_completed_flag:Bool) : () {
         //生成一个提案对象
        let new_proposal = {
            proposal_id = proposal.proposal_id;
            proposal_maker  = proposal.proposal_maker;
            operation_type = proposal.operation_type;
            canister_id = proposal.canister_id;
            wasm_module = proposal.wasm_module;
            proposal_approve_num = proposal.proposal_approve_num;
            proposal_approvers = proposal.proposal_approvers;
            proposal_refuse_num = proposal.proposal_refuse_num;
            proposal_refusers = proposal.proposal_refusers;
            proposal_completed = proposal_completed_flag;
        };

        //更新提案集合中该提案的属性值
        proposals := Trie.replace(proposals, {hash = Hash.hash(proposal.proposal_id); key =  proposal.proposal_id}, Nat.equal, ?new_proposal).0;
    };


};