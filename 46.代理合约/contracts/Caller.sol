// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.21;

import "hardhat/console.sol";

/**
 * @dev Caller合约，调用代理合约，并获取执行结果
 */
contract Caller {
    address public proxy; // 代理合约地址
    event CallSuccess(uint increase);
    event Dynamic(bytes increase);

    constructor(address proxy_) {
        proxy = proxy_;
    }

    // 通过代理合约调用 increase()函数
    function increase() external returns (uint) {
        (, bytes memory data) = proxy.call(
            abi.encodeWithSignature("increment()")
        );
        emit CallSuccess(abi.decode(data, (uint)));
        return abi.decode(data, (uint));
    }
}
