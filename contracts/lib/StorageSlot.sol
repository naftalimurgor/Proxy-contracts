// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library StorageSlot {
    // addresses are byte32 values under the hood.
    // to prevent state collision between the implementaion contract address,
    // we store the contract address at a unique special slot in memory

    function getAddressAt(bytes32 slot) internal view returns (address a) {
        assembly {
          // sload is a lowlevel function to read data at a slot
          a := sload(slot)
        }
    }

    function setAddress(bytes32 slot, address implementationAddress) internal {
      assembly {
        // sstore is lowlevel function to store a value at a certain address
        sstore(slot, implementationAddress)
      }
    }

}
