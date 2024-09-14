// 另一个网络合约的地址
const crosschainAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

// 初始化另一个链的provider
const crosschainProvider = new ethers.providers.JsonRpcProvider('http://127.0.0.1:8546');

// 初始化另一个链的合约实例
const crosschainContract1 = new ethers.Contract(crosschainAddress, abi, crosschainProvider.getSigner(0));

// 监听chain 1的Bridge事件，然后在2上执行mint操作，完成跨链
contract.on(contract.filters["Bridge"](), (user, amount) => {
    console.log("在另一个链执行burn操作");
    // 在另一个链执行burn操作
    crosschainContract1.mint(user, amount);
});