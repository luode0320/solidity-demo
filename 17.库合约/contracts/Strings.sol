// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 提供字符串转换功能的库
library Strings {
    // 存储十六进制字符的常量
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev 将一个无符号整数转换为其 ASCII 字符串十进制表示形式。
     *
     * @param value 要转换的无符号整数。
     * @return 一个表示该整数的字符串。
     */
    function toString(uint256 value) public pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        // 计算数字的位数
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        // 创建一个足够大的字节数组来存储结果
        bytes memory buffer = new bytes(digits);
        // 逐位构建字符串
        while (value != 0) {
            digits -= 1;
            // 取模得到最后一位数字，并转换为 ASCII 字符
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            // 更新值
            value /= 10;
        }
        // 将字节数组转换为字符串并返回
        return string(buffer);
    }

    /**
     * @dev 将一个无符号整数转换为其 ASCII 字符串十六进制表示形式。
     *
     * @param value 要转换的无符号整数。
     * @return 一个表示该整数的十六进制字符串。
     */
    function toHexString(uint256 value) public pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        // 计算十六进制表示的长度
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        // 使用固定长度的版本进行转换
        return toHexString(value, length);
    }

    /**
     * @dev 将一个无符号整数转换为其 ASCII 字符串十六进制表示形式，并指定固定长度。
     *
     * @param value 要转换的无符号整数。
     * @param length 要生成的字符串的长度。
     * @return 一个表示该整数的十六进制字符串。
     */
    function toHexString(
        uint256 value,
        uint256 length
    ) public pure returns (string memory) {
        // 创建一个足够大的字节数组来存储结果，包括前缀 "0x"
        bytes memory buffer = new bytes(2 * length + 2);
        // 初始化字符串前缀 "0x"
        buffer[0] = "0";
        buffer[1] = "x";
        // 从右向左填充十六进制字符
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            // 右移四位以获取下一个十六进制位
            value >>= 4;
        }
        // 确保所有位都已正确填充
        require(value == 0, "Strings: hex length insufficient");
        // 将字节数组转换为字符串并返回
        return string(buffer);
    }
}
