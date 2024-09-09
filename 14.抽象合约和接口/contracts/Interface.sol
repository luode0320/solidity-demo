// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

//抽象一个插入排序的接口方法, 让别人了实现
abstract contract InsertionSort {
    function insertionSort(
        uint[] memory a
    ) public pure virtual returns (uint[] memory);
}

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

// 定义 ERC721 接口，ERC721 标准定义了一个非同质化代币（NFT）的行为规范
interface IERC721 is IERC165 {
    // 在转账时被释放，记录代币的发出地址`from`，接收地址`to`和`tokenId`。
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    // 在授权时被释放，记录授权地址`owner`，被授权地址`approved`和`tokenId`。
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    // 在批量授权时被释放，记录批量授权的发出地址`owner`，被授权地址`operator`和授权与否的`approved`。
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // 返回某地址的NFT持有量`balance`
    function balanceOf(address owner) external view returns (uint256 balance);

    // 返回某`tokenId`的主人`owner`。
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // 安全转账（如果接收方是合约地址，会要求实现`ERC721Receiver`接口）。参数为转出地址`from`，接收地址`to`和`tokenId`。
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    // 普通转账，参数为转出地址`from`，接收地址`to`和`tokenId`。
    function transferFrom(address from, address to, uint256 tokenId) external;

    // 授权另一个地址使用你的NFT。参数为被授权地址`approve`和`tokenId`。
    function approve(address to, uint256 tokenId) external;

    // 查询`tokenId`被批准给了哪个地址。
    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    // 将自己持有的该系列NFT批量授权给某个地址`operator`。
    function setApprovalForAll(address operator, bool _approved) external;

    // 查询某地址的NFT是否批量授权给了另一个`operator`地址。
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);

    // 安全转账的重载函数，参数里面包含了`data`。
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

contract InteractBAYC {
    // 利用BAYC地址创建接口合约变量（ETH主网）
    IERC721 BAYC = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);

    // 通过接口调用BAYC的balanceOf()查询持仓量
    function balanceOfBAYC(
        address owner
    ) external view returns (uint256 balance) {
        return BAYC.balanceOf(owner);
    }

    // 通过接口调用BAYC的safeTransferFrom()安全转账
    function safeTransferFromBAYC(
        address from,
        address to,
        uint256 tokenId
    ) external {
        BAYC.safeTransferFrom(from, to, tokenId);
    }
}
