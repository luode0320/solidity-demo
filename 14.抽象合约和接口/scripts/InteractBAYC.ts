import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = "InteractBAYC";

// 调用合约方法
async function exec(contract: any) {
    // 定义事件监听器的回调函数
    const onTransfer = (from: any, to: any, tokenId: any) => {
        console.log(`Transfer event: from=${from}, to=${to}, tokenId=${tokenId.toString()}`);
    };

    // 设置事件监听器
    contract.on("Transfer", onTransfer);

    // 获取当前用户地址
    const [deployer] = await ethers.getSigners();
    const deployerAddress = deployer.address;

    // 查询 BAYC 的余额
    console.log("balanceOfBAYC(): 查询 BAYC 的余额...");
    const balance = await contract.balanceOfBAYC(deployerAddress);
    console.log(`balanceOfBAYC(): 当前用户的 BAYC 余额: ${balance.toString()}`);

    // 安全转账 BAYC
    console.log("safeTransferFromBAYC(): 安全转账 BAYC...");
    const toAddress = "0xYourReceiverAddressHere"; // 替换为实际的接收者地址
    const tokenId = 1; // 替换为实际的 tokenId
    await contract.safeTransferFromBAYC(deployerAddress, toAddress, tokenId);

    // 再次查询 BAYC 的余额
    console.log("balanceOfBAYC(): 再次查询 BAYC 的余额...");
    const newBalance = await contract.balanceOfBAYC(deployerAddress);
    console.log(`balanceOfBAYC(): 当前用户的 BAYC 余额: ${newBalance.toString()}`);

    // 等待一段时间以确保事件被触发
    await new Promise(resolve => setTimeout(resolve, 5000));

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