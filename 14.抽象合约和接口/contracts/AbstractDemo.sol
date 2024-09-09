// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

abstract contract AbstractBase {
    string public name = "Base";

    function getAlias() public pure virtual returns (string memory);
}

contract AbstractBaseImpl is AbstractBase {
    function getAlias() public pure override returns (string memory) {
        return "BaseImpl";
    }
}
