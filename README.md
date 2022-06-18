# icp_training2
ICP区块链开发进阶课程-20220515

## 安装 didc 工具

 * 下载Mac版本
```bash
https://github.com/dfinity/candid/releases
```
 * 修改名称
```bash
mv didc-macos didc
```
 * 修改可执行权限
```bash
chmod a+x didc
```
 * 移动到bin目录
```bash
sudo mv didc /usr/local/bin
```

## 安装 ic-repl 工具

 * 下载Mac版本
```bash
https://github.com/chenyan2002/ic-repl/releases
```
 * 修改可执行权限
```bash
chmod a+x ic-repl-macos
```
 * 移动到bin目录
```bash
sudo mv ic-repl-macos /usr/local/bin/ic-repl
```



## IC Manager did 接口编译

 * 下载
```bash
https://github.com/dfinity/interface-spec/blob/master/spec/ic.did
```

 * 编译成motoko文件
```bash
didc bind -t mo ic.did > src/dynamic_canister/ic.mo
```

## 启动、部署和测试调用

* 启动服务
```bash
dfx start --background
```

