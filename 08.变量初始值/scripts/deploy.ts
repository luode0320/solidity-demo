import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = process.env.DEPLOY_CONTRACT_NAME!;

// 调用合约方法
async function exec(contract: any) {
    console.log("_bool 默认值:", await contract._bool());

    console.log("_string 默认值:", await contract._string());

    console.log("_int 默认值:", await contract._int());

    console.log("_uint 默认值:", await contract._uint());

    console.log("_address 默认值:", await contract._address());

    console.log("_bytest1 默认值:", await contract._bytest1);

    console.log("_bytest2 默认值:", await contract._bytest2);

    console.log("_enum 默认值:", await contract._enum());

    console.log("_staticArray[0] 默认值:", await contract._staticArray(0));

    console.log("_mapping 默认值:", await contract._mapping(0));

    console.log("student 默认值:", await contract.student());

    console.log("_bool2 默认值:", await contract._bool2());

    // 调用 delete 函数
    await contract.d();
    console.log("_bool2 delete 后默认值:", await contract._bool2());
}

// 定义一个异步函数 main，用于部署合约。
async function main() {
    console.log("_________________________启动部署________________________________");
    const [deployer] = await ethers.getSigners();
    console.log("部署地址:", deployer.address);

    // 获取账户的余额
    const balance = await deployer.provider.getBalance(deployer.address);
    // 将余额转换为以太币 (ETH)
    console.log("账户余额 balance(wei):", balance.toString());
    const balanceInEther = ethers.formatEther(balance);
    console.log("账户余额 balance(eth):", balanceInEther);

    console.log("_________________________部署合约________________________________");
    // 获取合约工厂。
    const contractFactory = await ethers.getContractFactory(contractName);
    // 部署合约
    const contract = await contractFactory.deploy();
    //  等待部署完成
    await contract.waitForDeployment()
    console.log(`合约地址: ${contract.target}`);

    console.log("_________________________合约调用________________________________");
    await exec(contract);
}

// 执行 main 函数，并处理可能发生的错误。
main()
    .then(() => process.exit(0)) // 如果部署成功，则退出进程。
    .catch(error => {
        console.error(error); // 如果发生错误，则输出错误信息。
        process.exit(1); // 退出进程，并返回错误代码 1。
    });