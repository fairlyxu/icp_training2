# course3
## 作业：在第2课作业的基础上，实现以下的功能：
* 用 Actor Class 参数来初始化 M, N, 以及最开始的小组成员（principal id)。（1分）
* 允许发起提案，比如对某个被多人钱包管理的 canister 限制权限。（1分）
* 统计小组成员对提案的投票（同意或否决），并根据投票结果执行决议。（2分）
* 在主网部署，并调试通过。（1 分）
* 本次课程作业先实现基本的提案功能，不涉及具体限权的操作。

## 要求：
* 1.设计发起提案 (propose) 和对提案进行投票 (vote) 的接口。
* 2.实现以下两种提案：
* -开始对某个指定的 canister 限权。
* -解除对某个指定的 canister 限权。
* 3.在调用 IC Management Canister 的时候，给出足够的 cycle。

dfx deploy 参数 即`用 Actor Class 参数来初始化 M, N, 以及最开始的小组成员（principal id)`
```bash 
dfx deploy hello_canister --network=ic  --with-cycles=1000000000000  --argument '(record {minimum=1; members=vec {
    principal "xxxxxx" ;
    principal "xxxxxx"; 
    principal "xxxxxx"; 
    principal "xxxxxx"}})'

```

