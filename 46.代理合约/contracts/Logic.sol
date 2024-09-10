// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.21;

import "hardhat/console.sol";

/**
 * @dev 逻辑合约，执行被委托的调用
 */
contract Logic {
    address public implementation; // 与Proxy保持一致，防止插槽冲突
    uint public x = 99;
    event CallSuccess(uint increment);

    // 这个函数会释放LogicCalled并返回一个uint。ethers不会收到这个结果, 所以我们用event获取
    // 函数selector: 0xd09de08a
    function increment() external returns (uint) {
        console.log("Logic: increment");
        emit CallSuccess(x + 1);
        return x + 1;
    }
}
