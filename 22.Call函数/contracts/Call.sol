// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Call {
    // Response 事件用于输出 `call` 的结果，包括成功与否 (`success`) 和返回数据 (`data`)
    event Response(bool success, bytes data);

    // 该函数用于调用另一个合约的 `setX` 方法，并可以选择发送 ETH
    function callSetX(address payable _addr, uint256 x) public payable {
        // 使用 low-level 的 `call` 调用另一个合约的 `setX` 方法，并发送一定数量的 ETH
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );

        // 发射 Response 事件，记录调用的结果
        emit Response(success, data);
    }

    // 该函数用于调用另一个合约的 `getX` 方法，并返回结果
    function callGetX(address _addr) external returns (uint256) {
        // 使用 low-level 的 `call` 调用另一个合约的 `getX` 方法
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        // 发射 Response 事件，记录调用的结果
        emit Response(success, data);

        // 解码返回的数据，将其转换为 uint256 类型，并返回
        return abi.decode(data, (uint256));
    }

    // 该函数尝试调用另一个合约中不存在的方法 `foo`
    function callNonExist(address _addr) external {
        // 尝试调用另一个合约中不存在的方法 `foo`
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        // 发射 Response 事件，记录调用的结果
        emit Response(success, data);
    }
}
