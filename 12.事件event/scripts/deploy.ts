import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = process.env.DEPLOY_CONTRACT_NAME!;

// 调用合约方法
async function exec(contract: any) {
    const onTransfer = (from: any, to: any, value: any, event: any) => {
        console.log(`事件监听器: ${from} => ${to}: ${value}`);
    }
    // 设置事件监听器
    contract.on("Transfer", onTransfer);

    // 创建新账户
    const [deployer, newAccount] = await ethers.getSigners();

    // 转账
    console.log("Transfer: 代币转账...");
    await contract._transfer(deployer.address, newAccount.address, 10000);
    console.log(`${deployer.address} 转账 ${newAccount.address} 10000 个代币`);

    const balanceAfterTransfer = await contract._balances(deployer.address);
    const newAccountBalance = await contract._balances(newAccount.address);
    console.log(`${deployer.address} 获取转账后的余额:`, balanceAfterTransfer.toString());
    console.log(`${newAccount.address} 获取转账后的余额:`, newAccountBalance.toString());

    // 设置堵塞, 因为监听是 4s 轮询的方式, 所以需要等待 4s
    await new Promise(res => setTimeout(() => res(null), 5000));
    // 移除事件监听器
    contract.removeListener("Transfer", onTransfer);
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