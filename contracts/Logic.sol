// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Logic {
    uint256 magicNumber;

    constructor() {
        magicNumber = 0x42;
    }

    function setMagicNumber(uint256 newMagicNumber) public {
        magicNumber = newMagicNumber;
    }
    function getMagicNumber() public view returns (uint256){
      return magicNumber;
    }
}
