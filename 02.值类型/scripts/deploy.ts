import { ethers } from "hardhat";
import dotenv from "dotenv";

// 加载环境变量
dotenv.config();

// 需要部署的合约名称
const contractName: string = process.env.DEPLOY_CONTRACT_NAME!;

// 调用合约方法
async function exec(contract: any) {
    console.log("获取合约变量:");
    console.log("  _bool:", await contract._bool());
    console.log("  _bool1:", await contract._bool1());
    console.log("  _bool2:", await contract._bool2());
    console.log("  _bool3:", await contract._bool3());
    console.log("  _bool4:", await contract._bool4());
    console.log("  _bool5:", await contract._bool5());

    console.log("  _int:", await contract._int());
    console.log("  _uint:", await contract._uint());
    console.log("  _number:", await contract._number());
    console.log("  _number1:", await contract._number1());
    console.log("  _number2:", await contract._number2());
    console.log("  _number3:", await contract._number3());
    console.log("  _numberbool:", await contract._numberbool());

    console.log("  _address:", await contract._address());
    console.log("  _address1:", await contract._address1());
    console.log("  balance:", await contract.balance());

    console.log("  _byte32:", await contract._byte32());
    console.log("  _byte:", await contract._byte());

    console.log("  action:", await contract.action());
    console.log("  enumToUint:", await contract.enumToUint());
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