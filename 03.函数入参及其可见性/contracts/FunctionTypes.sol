// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FunctionTypes {
    // public: 可以从外部和内部访问, 自带一个get方法
    uint256 public number = 5;

    // payable: 可以接受 ETH 到合约
    constructor() payable {}

    // external: 只能从合约外部访问（但内部可以通过 `this.f()` 来调用，`f`是函数名）。
    function add() external {
        number = number + 1;
    }

    // external: 只能从合约外部访问（但内部可以通过 `this.f()` 来调用，`f`是函数名）。
    // pure: 纯纯牛马, 基本上和合约没有一毛钱关系, 任何一个合约把这个代码放进去都能用。
    function addPure(
        uint256 _number
    ) external pure returns (uint256 new_number) {
        new_number = _number + 1;
    }

    // external: 只能从合约外部访问（但内部可以通过 `this.f()` 来调用，`f`是函数名）。
    // view: 看客
    function addView() external view returns (uint256 new_number) {
        new_number = number + 1;
    }

    // internal: 内部函数, 只能被合约内部调用
    function minus() internal {
        number = number - 1;
    }

    // external: 只能从合约外部访问（但内部可以通过 `this.f()` 来调用，`f`是函数名）。
    // 合约内的函数可以调用内部函数
    function minusCall() external {
        minus();
    }

    // external: 只能从合约外部访问（但内部可以通过 `this.f()` 来调用，`f`是函数名）。
    // payable: 递钱，能给合约支付eth的函数
    function minusPayable() external payable returns (uint256 balance) {
        balance = address(this).balance;
    }
}
