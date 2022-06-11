// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Proxy {
    // add implementaion contract address property
    address public implementation;

    function setImplementation(address implementation_) public {
        implementation = implementation_;
    }

    function getImplementation() public view returns (address) {
        return implementation;
    }

    fallback() external {
        assembly {
            // save call data to a specific memory slot
            // mload reads 32bytes from a specific index
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            
            // relay call to the proxy contract
            let result := delegatecall(
                gas(),
                sload(implementation.slot),
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
