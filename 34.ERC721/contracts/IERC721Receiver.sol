// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC721接收者接口：合约必须实现这个接口来通过安全转账接收ERC721
interface IERC721Receiver {
    function onERC721Received(
        address operator, // 调用者地址
        address from, // 发送方地址
        uint tokenId, // 转移的 token ID
        bytes calldata data // 附加数据
    ) external returns (bytes4);
}
