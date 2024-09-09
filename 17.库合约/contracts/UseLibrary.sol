// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/utils/Strings.sol";

// 用函数调用另一个库合约
contract UseLibrary {
    // 利用using for操作使用库
    using Strings for uint256;

    function getString1(uint256 _number) public pure returns (string memory) {
        // 库函数会自动添加为uint256型变量的成员
        return _number.toHexString();
    }

    // 直接通过库合约名调用
    function getString2(uint256 _number) public pure returns (string memory) {
        return Strings.toHexString(_number);
    }
}
