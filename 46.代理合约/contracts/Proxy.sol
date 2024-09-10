// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.21;

import "hardhat/console.sol";

/**
 * @dev Proxy合约的所有调用都通过`delegatecall`操作码委托给另一个合约执行。后者被称为逻辑合约（Implementation）。
 *
 * 委托调用的返回值，会直接返回给Proxy的调用者
 */
contract Proxy {
    address public implementation; // 逻辑合约地址。implementation合约同一个位置的状态变量类型必须和Proxy合约的相同，不然会报错。

    /**
     * @dev 初始化逻辑合约地址
     */
    constructor(address implementation_) {
        implementation = implementation_;
    }

    /**
     * @dev 回调函数，调用`_delegate()`函数将本合约的调用委托给 `implementation` 合约
     */
    fallback() external payable {
        _delegate();
    }

    receive() external payable {}

    /**
     * 函数selector: 0xd09de08a
     * @dev 将调用委托给逻辑合约运行
     */
    function _delegate() internal {
        console.log("Proxy: _delegate");
        address _implementation = implementation;
        assembly {
            // 将 msg.data 拷贝到内存里
            // calldatacopy 操作码的参数: 内存起始位置，calldata 起始位置，calldata 长度
            // 这里将整个 calldata 复制到内存的起始位置 0
            calldatacopy(0, 0, calldatasize())

            // 利用 delegatecall 调用 implementation 合约
            // delegatecall 操作码的参数：gas, 目标合约地址，input mem 起始位置，input mem 长度，output area mem 起始位置，output area mem 长度
            // output area 起始位置和长度位置，所以设为 0
            // delegatecall 成功返回 1，失败返回 0
            let result := delegatecall(
                gas(),
                _implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // 将 return data 拷贝到内存
            // returndatacopy 操作码的参数：内存起始位置，returndata 起始位置，returndata 长度
            // 这里将整个 returndata 复制到内存的起始位置 0
            returndatacopy(0, 0, returndatasize())

            // 根据 delegatecall 的结果进行不同的处理
            switch result
            // 如果delegate call失败，revert
            case 0 {
                revert(0, returndatasize())
            }
            // 如果delegate call成功，返回mem起始位置为0，长度为returndatasize()的数据（格式为bytes）
            default {
                return(0, returndatasize())
            }
        }
    }
}
