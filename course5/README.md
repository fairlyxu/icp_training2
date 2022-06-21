# course5
* 1）前端对 canister 进行操作，包括 create_canister, install_code, start_canister, stop_canister, delete_canister。对被限权的 Canister 的操作时，会发起新提案。
* 2）前端可以上传 Wasm 代码，用于 install_code。
* 3）前端发起提案和投票的操作。
* 4）支持增加和删除小组成员的提案。
* 5）让多人钱包接管自己（对钱包本身的操作，比如升级，需要走提案流程）

dfx deploy 参数 即`用 Actor Class 参数来初始化 M, N, 以及最开始的小组成员（principal id)`
```bash 
dfx deploy course5 --argument '(record {minimum=1; members=vec {principal "54dz2-4wkpu-xqyva-45om5-lciwq-kl62c-l7dno-iwcms-pdoea-jj3vb-wqe"; principal "6p25l-itkzz-crd3k-534mc-fq4sj-oz5rl-4cldf-nkaxr-bpasr-2wl4e-lqe"; principal "zzpvw-spsbb-pcnsc-23gpy-ykq5i-6q27a-j7n7x-nqmp3-fb6y2-3eq26-pqe"}})'

```