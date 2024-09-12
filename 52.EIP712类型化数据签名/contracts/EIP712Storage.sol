// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract EIP712Storage {
    using ECDSA for bytes32;

    //  `EIP712Domain` 的类型哈希，为常量。
    bytes32 private constant EIP712DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );

    // `Storage` 的类型哈希，为常量。
    bytes32 private constant STORAGE_TYPEHASH =
        keccak256("Storage(address spender,uint256 number)");

    // 这是混合在签名中的每个域 (Dapp) 的唯一值
    // 由 `EIP712DOMAIN_TYPEHASH` 以及 `EIP712Domain` （name, version, chainId, verifyingContract）组成，在 `constructor()` 中初始化。
    bytes32 private DOMAIN_SEPARATOR;
    // 合约中存储值的状态变量，可以被 `permitStore()` 方法修改。
    uint256 number;
    //  合约所有者，在 `constructor()` 中初始化，在 `permitStore()` 方法中验证签名的有效性。
    address owner;

    constructor() {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712DOMAIN_TYPEHASH, // type hash
                keccak256(bytes("EIP712Storage")), // domain.name
                keccak256(bytes("1")), // domain.version
                block.chainid, // domain.chainId
                address(this) // domain.verifyingContract
            )
        );
        owner = msg.sender;
    }

    /**
     * @dev Store value in variable
     */
    function permitStore(uint256 _num, bytes memory _signature) public {
        // 检查签名长度，65是标准r,s,v签名的长度
        require(_signature.length == 65, "invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;
        // 目前只能用assembly (内联汇编)来从签名中获得r,s,v的值
        assembly {
            // 读取长度数据后的32 bytes
            r := mload(add(_signature, 0x20))
            // 读取之后的32 bytes
            s := mload(add(_signature, 0x40))
            // 读取最后一个byte
            v := byte(0, mload(add(_signature, 0x60)))
        }

        // 获取签名消息hash
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(STORAGE_TYPEHASH, msg.sender, _num))
            )
        );

        address signer = digest.recover(v, r, s); // 恢复签名者
        require(signer == owner, "EIP712Storage: Invalid signature"); // 检查签名

        // 修改状态变量
        number = _num;
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256) {
        return number;
    }
}
