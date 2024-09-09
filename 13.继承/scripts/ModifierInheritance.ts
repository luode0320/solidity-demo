import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = "Identifier";

// 调用合约方法
async function exec(contract: any) {
    // 测试合法情况
    console.log("调用 getExactDividedBy2And3(6):");
    try {
        const result = await contract.getExactDividedBy2And3(6);
        console.log(`getExactDividedBy2And3(6) 合法情况: (${result[0]}, ${result[1]})`);
    } catch (error: any) {
        console.error(`错误: ${error.message}`);
    }

    // 测试非法情况
    console.log("调用 getExactDividedBy2And3(9):");
    try {
        const result = await contract.getExactDividedBy2And3(9);
        console.log(`getExactDividedBy2And3(9) 非法情况: (${result[0]}, ${result[1]})`);
    } catch (error: any) {
        console.error(`错误: ${error.message}`);
    }

    // 测试不使用修饰符的情况
    console.log("调用 getExactDividedBy2And3WithoutModifier(9):");
    try {
        const result = await contract.getExactDividedBy2And3WithoutModifier(9);
        console.log(`getExactDividedBy2And3WithoutModifier(9) 不继承修饰符: (${result[0]}, ${result[1]})`);
    } catch (error: any) {
        console.error(`错误: ${error.message}`);
    }
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