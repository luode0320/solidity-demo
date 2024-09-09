import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = process.env.DEPLOY_CONTRACT_NAME!;

// 调用合约方法
async function exec(contract: any) {
    console.log("获取合约变量:");
    console.log("  number:", await contract.number());

    console.log("\n调用 add() 函数,给 number 加 1 :");
    await contract.add();
    console.log("  number:", await contract.number());

    console.log("\n调用 addPure() 函数, 不改变合约 number 状态:");
    const newNumberPure = await contract.addPure(10);
    console.log("  newNumberPure:", newNumberPure);
    console.log("  number:", await contract.number());

    console.log("\n调用 addView() 函数,只读不修改 number 本身:");
    const newNumberView = await contract.addView();
    console.log("  newNumberView:", newNumberView);
    console.log("  number:", await contract.number()); // 注意: addView() 不修改 number

    console.log("\n调用 minusCall() 函数, 内部对 number - 1:");
    await contract.minusCall();
    console.log("  number:", await contract.number());

    console.log("\n调用 minusPayable() 函数,并转账 100eth 到合约账户:");
    const balanceAfterPayable = await contract.minusPayable({ value: ethers.parseEther('100') });
    console.log("  balance:", balanceAfterPayable.value);
    console.log("  number:", await contract.number());
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