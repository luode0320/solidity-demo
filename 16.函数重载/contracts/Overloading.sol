// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "hardhat/console.sol";

contract Overloading {
    // 无参数版本
    function saySomething() public pure returns (string memory) {
        return ("Nothing");
    }

    // 接受一个字符串参数的版本
    function saySomething(
        string memory something,
        string memory something2
    ) public pure returns (string memory, string memory) {
        return (something, something2);
    }

    // 重构会异常, 因为编译器无法识别重构的函数
    function f(uint8 _in) public pure returns (uint8 out) {
        console.log("f(uint8 _in)");
        out = _in;
    }

    // 重构会异常, 因为编译器无法识别重构的函数
    function f(uint256 _in) public pure returns (uint256 out) {
        console.log("f(uint256 _in)");
        out = _in;
    }
}
