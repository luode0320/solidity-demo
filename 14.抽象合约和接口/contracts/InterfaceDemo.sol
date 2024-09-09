// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface InterfaceBase {
    function getFirstName() external pure returns (string memory);

    function getLastName() external pure returns (string memory);
}

contract InterfaceBaseImpl is InterfaceBase {
    function getFirstName() external pure override returns (string memory) {
        return "Amazing";
    }

    function getLastName() external pure override returns (string memory) {
        return "Ang";
    }
}
