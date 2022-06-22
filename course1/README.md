# course1
## 要求：
* 1. 主 canister 界面（至少）实现以下方法：
service : {
append: (vec text) -> () oneway;
view: (nat, nat) -> (View);
}
* 2. 假定其中使用的每个 Logger 只能存放 100 条记录，满了之后需要自动创建新的 Logger actor 来存放新的记录。
* 3. 使用 vessel 来导入 ic-logger 里面 Logger module，并且不能修改 Logger module 本身的代码。
* 4. 提交项目源代码的仓库（不要求部署到主网）。
* 5.可以不考虑权限问题。
* 注意：请提交部署代码的GitHub链接。
