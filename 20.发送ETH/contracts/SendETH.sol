// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 3种方法发送ETH
// - `call`没有`gas`限制，最为灵活，**是最提倡的方法**；
// - `transfer`有`2300 gas`限制，但是发送失败会自动`revert`交易，是次优选择；
// - `send`有`2300 gas`限制，而且发送失败不会自动`revert`交易，**几乎没有人用它**。

error SendFailed(); // 用send发送ETH失败error
error CallFailed(); // 用call发送ETH失败error

contract SendETH {
    // 构造函数，payable使得部署的时候可以转eth进去
    constructor() payable {}

    // receive方法，接收eth时被触发
    receive() external payable {}

    // 用transfer()发送ETH
    function transferETH(address payable _to, uint256 amount) external payable {
        _to.transfer(amount);
    }

    // send()发送ETH
    function sendETH(address payable _to, uint256 amount) external payable {
        // 处理下send的返回值，如果失败，revert交易并发送error
        bool success = _to.send(amount);
        if (!success) {
            revert SendFailed();
        }
    }

    // call()发送ETH
    function callETH(address payable _to, uint256 amount) external payable {
        // 处理下call的返回值，如果失败，revert交易并发送error
        (bool success, ) = _to.call{value: amount}("");
        if (!success) {
            revert CallFailed();
        }
    }
}
