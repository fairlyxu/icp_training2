import Principal "mo:base/Principal";

module {

    public type Wasm_module = [Nat8];

    public type CanisterInfo = {
        canister_id: Principal;
        is_restricted: Bool;  // 是否需要投票的标志
    };

    public type OperationType = {
        #create;
        #install; 
        #start;
        #stop;
        #delete; 
        #addRestricted; //增加限制,添加权限也需要
        #removeRestricted; // 解除限制
    };

    public type Proposal = {
        proposal_id : Nat;
        proposal_maker : Principal;
        operation_type : OperationType;
        canister_id : Principal;
        wasm_module : ?Wasm_module; // 只在install 时候需要
        proposal_approve_num : Nat;  // 该提案的赞同数量
        proposal_approvers : [Principal];
        proposal_refuse_num : Nat;  //该提案的反对数量
        proposal_refusers: [Principal];
        proposal_completed: Bool;  //该提案的是否已经执行过了
    };

};