import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = process.env.DEPLOY_CONTRACT_NAME!;

// 创建一个新的测试地址作为新的所有者
const newOwnerAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

// 调用合约方法
async function exec(contract: any) {
    // 创建一个映射来记录每次调用的 gas 成本
    const gasCosts: Record<string, any> = {};

    // 准备一个 tokenId
    const tokenId = 124;

    // 调用 transferOwner1 方法
    try {
        const tx1 = await contract.transferOwner1(tokenId, newOwnerAddress);
        const receipt1 = await tx1.wait();
        gasCosts["transferOwner1 error"] = receipt1.gasUsed;
    } catch (error: any) {
        console.error("transferOwner1 failed:", error.message);
        const receipt1 = await ethers.provider.getTransactionReceipt(error.transactionHash);
        gasCosts["transferOwner1 error"] = receipt1?.gasUsed || null;
    }

    // 调用 transferOwner2 方法
    try {
        const tx2 = await contract.transferOwner2(tokenId, newOwnerAddress);
        const receipt2 = await tx2.wait();
        gasCosts["transferOwner2 require"] = receipt2.gasUsed.toNumber();
    } catch (error: any) {
        console.error("transferOwner2 failed:", error.message);
        const receipt2 = await ethers.provider.getTransactionReceipt(error.transactionHash);
        gasCosts["transferOwner2 require"] = receipt2?.gasUsed || null;
    }

    // 调用 transferOwner3 方法
    try {
        const tx3 = await contract.transferOwner3(tokenId, newOwnerAddress);
        const receipt3 = await tx3.wait();
        gasCosts["transferOwner3 assert"] = receipt3.gasUsed.toNumber();
    } catch (error: any) {
        console.error("transferOwner3 failed:", error.message);
        const receipt3 = await ethers.provider.getTransactionReceipt(error.transactionHash);
        gasCosts["transferOwner3 assert"] = receipt3?.gasUsed || null;
    }

    // 输出 gas 成本
    for (const method in gasCosts) {
        console.log(`${method}: gas 消耗 ${gasCosts[method]}`);
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