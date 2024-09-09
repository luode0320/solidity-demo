// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DataStorage {
    // x的数据位置是存储。
    // 这是唯一一个
    // 可以省略数据位置。
    uint[] private x = [1, 2, 3];

    // 添加一个视图函数来获取x的值
    function getX() public view returns (uint[] memory) {
        return x;
    }

    // 声明一个storage的变量xStorage，指向x。修改xStorage也会影响x
    function fStorage() public {
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }

    // 声明一个Memory的变量xMemory，复制x。修改xMemory不会影响x
    function fMemory() public view {
        uint[] memory xMemory = x;
        xMemory[0] = 100;
        xMemory[1] = 200;

        uint[] memory xMemory2 = x;
        xMemory2[0] = 300;
    }

    // 参数为calldata数组,不能被修改
    function fCalldata(
        uint[] calldata _x
    ) public pure returns (uint[] calldata) {
        //  _x[0] = 0 // 这样修改会报错
        return (_x);
    }
}
