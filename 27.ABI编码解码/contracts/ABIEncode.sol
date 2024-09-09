// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ABIEncode {
    // 定义状态变量
    uint x = 10; // 一个整数类型的变量
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71; // 一个地址类型的变量
    string name = "0xAA"; // 一个字符串类型的变量
    uint[2] array = [5, 6]; // 一个包含两个元素的整数数组

    // 使用 abi.encode 编码数据
    function encode() public view returns (bytes memory result) {
        // 将状态变量编码成字节数组，并返回
        result = abi.encode(x, addr, name, array);
    }

    // 使用 abi.encodePacked 编码数据
    function encodePacked() public view returns (bytes memory result) {
        // 将状态变量编码成字节数组，不进行填充，并返回
        result = abi.encodePacked(x, addr, string(name), array);
    }

    // 使用 abi.encodeWithSignature 编码数据
    function encodeWithSignature() public view returns (bytes memory result) {
        // 使用函数签名计算函数选择器，并将状态变量编码成字节数组，附加函数选择器，并返回
        result = abi.encodeWithSignature(
            "foo(uint256,address,string,uint256[2])", // 函数签名
            x, // 第一个参数
            addr, // 第二个参数
            name, // 第三个参数
            array // 第四个参数
        );
    }

    // 使用 abi.encodeWithSelector 编码数据
    function encodeWithSelector() public view returns (bytes memory result) {
        // 手动计算函数选择器，并将状态变量编码成字节数组，附加函数选择器，并返回
        result = abi.encodeWithSelector(
            bytes4(keccak256("foo(uint256,address,string,uint256[2])")), // 函数选择器
            x, // 第一个参数
            addr, // 第二个参数
            name, // 第三个参数
            array // 第四个参数
        );
    }

    // 解码数据
    function decode(
        bytes memory data
    )
        public
        pure
        returns (
            uint dx,
            address daddr,
            string memory dname,
            uint[2] memory darray
        )
    {
        // 将字节数组解码回原始类型
        (dx, daddr, dname, darray) = abi.decode(
            data, // 待解码的字节数组
            (uint, address, string, uint[2]) // 解码的目标类型元组
        );
    }
}
