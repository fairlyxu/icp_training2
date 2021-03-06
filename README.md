# icp_training2
ICP区块链开发进阶课程-20220515


# hello_canister

Welcome to your new hello_canister project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with hello_canister, see the following documentation available online:

- [Quick Start](https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html)
- [Motoko Programming Language Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)
- [Motoko Language Quick Reference](https://sdk.dfinity.org/docs/language-guide/language-manual.html)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.ic0.app)

If you want to start working on your project right away, you might want to try the following commands:

```bash
dfx new hello_canister
cd hello_canister/
dfx help
dfx config --help
```

## Running the project locally

If you want to test your project locally, you can use the following commands:

```bash
# Starts the replica, running in the background
dfx start --background

# Deploys your canisters to the replica and generates your candid interface
dfx deploy
```

Once the job completes, your application will be available at `http://localhost:8000?canisterId={asset_canister_id}`.

Additionally, if you are making frontend changes, you can start a development server with

```bash
npm start
```

Which will start a server at `http://localhost:8080`, proxying API requests to the replica at port 8000.

### Note on frontend environment variables

If you are hosting frontend code somewhere without using DFX, you may need to make one of the following adjustments to ensure your project does not fetch the root key in production:

- set`NODE_ENV` to `production` if you are using Webpack
- use your own preferred method to replace `process.env.NODE_ENV` in the autogenerated declarations
- Write your own `createActor` constructor


### II 和相关依赖安装
https://github.com/dfinity/agent-js/tree/main/packages
```bash
npm i --save @dfinity/auth-client
npm i --save @dfinity/agent
npm i --save @dfinity/identity
npm i --save @dfinity/authentication
```

### 生成测试用的 principal id 
dfx identity --help
```bash
dfx identity new alice   
dfx identity use alice
dfx identity get-principal  
```
```bash
dfx identity use default
dfx identity get-principal  
dfx identity whoami   //default
```
```bash
dfx identity new bob 
dfx identity use bob 
dfx identity get-principal 
```


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
didc bind -t mo ic.did > src/hello_canister/ic.mo
```

## 启动、部署和测试调用

* 启动服务
```bash
dfx start --background
```

