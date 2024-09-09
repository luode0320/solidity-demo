// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ValueTypes {
    // 布尔值
    bool public _bool = true;
    // 布尔运算
    bool public _bool1 = !_bool; // 取非 -> false
    bool public _bool2 = _bool && _bool1; // 与 -> false
    bool public _bool3 = _bool || _bool1; // 或 -> true
    bool public _bool4 = _bool == _bool1; // 相等 -> false
    bool public _bool5 = _bool != _bool1; // 不相等 -> true

    // 整数
    int public _int = -1; // 整数，包括负数(-2^255 到 2^255 - 1)
    uint public _uint = 1; // 正整数(0 到 2^256 - 1)
    uint256 public _number = 20220330; // 256位正整数(0 到 2^256 - 1)
    // 整数运算
    uint256 public _number1 = _number + 1; // +，-，*，/
    uint256 public _number2 = 2 ** 2; // 指数
    uint256 public _number3 = 7 % 2; // 取余数
    bool public _numberbool = _number2 > _number3; // 比大小

    // 地址
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    address payable public _address1 = payable(_address); // payable address，可以转账、查余额
    uint256 public balance = _address1.balance; // balance是address的一个属性

    // 固定长度的字节数组
    bytes32 public _byte32 = "MiniSolidity"; // bytes32: 0x4d696e69536f6c69646974790000000000000000000000000000000000000000
    bytes1 public _byte = _byte32[0]; // bytes1: 0x4d

    // 用 enum 将 uint 0， 1， 2表示为Buy, Hold, Sell
    enum ActionSet {
        Buy,
        Hold,
        Sell
    }
    // 创建 enum 变量 action
    ActionSet public action = ActionSet.Buy;

    // enum 可以和 uint 显式的转换
    function enumToUint() external view returns (uint) {
        return uint(action);
    }
}
