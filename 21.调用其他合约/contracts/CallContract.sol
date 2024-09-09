// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./OtherContract.sol";

// 定义了一个名为 CallContract 的合约，该合约包含了与另一个合约 OtherContract 交互的方法。
contract CallContract {
    // 该函数用于调用 OtherContract 的 setX 方法，并设置 x 的值。
    // 参数:
    // - _Address: OtherContract 的地址。
    // - x: 设置的 x 值。
    function callSetX(address _Address, uint256 x) external {
        // 创建 OtherContract 的实例，并调用其 setX 方法。
        OtherContract(_Address).setX(x);
    }

    // 该函数用于从 OtherContract 获取 x 的值。
    // 参数:
    // - _Address: OtherContract 的实例。
    // 返回:
    // - x: OtherContract 中的 x 值。
    function callGetX(OtherContract _Address) external view returns (uint x) {
        // 直接从传入的 OtherContract 实例中获取 x 的值。
        x = _Address.getX();
    }

    // 该函数同样用于从 OtherContract 获取 x 的值，但通过地址创建 OtherContract 的实例。
    // 参数:
    // - _Address: OtherContract 的地址。
    // 返回:
    // - x: OtherContract 中的 x 值。
    function callGetX2(address _Address) external view returns (uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    // 该函数用于调用 OtherContract 的 setX 方法，并在调用时发送一定数量的 ETH。
    // 参数:
    // - otherContract: OtherContract 的地址。
    // - x: 设置的 x 值。
    // 注释:
    // - 该函数是 payable 的，这意味着它可以接收 ETH。
    // - 在调用 setX 方法时，将 msg.value (即发送给该函数的 ETH 数量) 作为 value 参数传递。
    function setXTransferETH(
        address otherContract,
        uint256 x
    ) external payable {
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}
