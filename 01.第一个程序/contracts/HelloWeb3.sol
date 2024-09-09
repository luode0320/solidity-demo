// SPDX-License-Identifier: MIT
// 指定 Solidity 编译器版本大于 0.8.21
pragma solidity ^0.8.21;

// 定义了一个名为 HelloWeb3 的智能合约
contract HelloWeb3 {
    // 定义了一个公共 ( public) 的可读写的字符串 (string) 状态变量，其初始值为 "Hello Web3!"
    string public _string = "Hello Web3!";
}
