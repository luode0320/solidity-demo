// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OtherContract {
    uint256 private _x = 0; // 状态变量_x，用于存储某个数值

    // 当合约接收到 ETH 时记录的事件，记录接收到的金额和剩余的 gas
    event Log(uint256 amount, uint256 gas);

    // fallback 函数允许合约在没有指定函数的情况下接收 ETH
    // 这是一个空的 fallback 函数，它可以接收 ETH 而不执行任何操作
    fallback() external payable {}

    // receive 函数是一个接收 ETH 的快捷方式，仅在接收 ETH 时调用
    // 它与 fallback 函数类似，但只处理以太币的接收
    receive() external payable {}

    // 返回合约当前持有的 ETH 余额
    function getBalance() public view returns (uint256) {
        // 返回合约地址的当前余额
        return address(this).balance;
    }

    // 设置状态变量 _x 的值，并允许同时向合约发送 ETH
    function setX(uint256 x) external payable {
        // 设置状态变量 _x 的值
        _x = x;

        // 如果有 ETH 发送到合约，则记录接收到的金额和剩余的 gas
        if (msg.value > 0) {
            // 触发 Log 事件，记录发送的 ETH 金额以及剩余的 gas
            emit Log(msg.value, gasleft());
        }
    }

    // 获取状态变量 _x 的当前值
    function getX() external view returns (uint256 x) {
        // 返回状态变量 _x 的值
        x = _x;
        return x;
    }
}
