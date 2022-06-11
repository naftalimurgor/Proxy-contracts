// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./lib/StorageSlot.sol";

contract Proxy {
    // -1 to increase the uniqueness of the address
    bytes32 private constant __IMPL_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    function setImplementation(address implementation_) public {
        StorageSlot.setAddress(__IMPL_SLOT, implementation_);
    }

    function getImplementation() public view returns (address) {
        return StorageSlot.getAddressAt(__IMPL_SLOT);
    }

    fallback() external {}

    function _delegate(address _implAddress) internal virtual {
        assembly {
            // save call data to a specific memory slot
            // mload reads 32bytes from a specific index
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            // relay call to the proxy contract
            let result := delegatecall(
                gas(),
                _implAddress,
                ptr,
                calldatasize(),
                0,
                0
            )
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            // check result and revert or return accordingly
            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }
}
