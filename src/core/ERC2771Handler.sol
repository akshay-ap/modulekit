// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title Handler Context - Allows the fallback handler to extract addition context from the
 * calldata
 * @dev The fallback manager appends the following context to the calldata:
 *      1. Fallback manager caller address (non-padded)
 * based on
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/f8cc8b844a9f92f63dc55aa581f7d643a1bc5ac1/contracts/metatx/ERC2771Context.sol
 * @author Richard Meissner - @rmeissner
 */
contract ERC2771Handler {
    error ERC2771Unauthorized();

    modifier onlySmartAccount() {
        if (msg.sender != _msgSender()) {
            revert ERC2771Unauthorized();
        }
        _;
    }

    /**
     * @notice Allows fetching the original caller address.
     * @dev This is only reliable in combination with a FallbackManager that supports this (e.g. Safe
     * contract >=1.3.0).
     *      When using this functionality make sure that the linked _manager (aka msg.sender)
     * supports this.
     *      This function does not rely on a trusted forwarder. Use the returned value only to
     *      check information against the calling manager.
     * @return sender Original caller address.
     */
    function _msgSender() internal pure returns (address sender) {
        // The assembly code is more direct than the Solidity version using `abi.decode`.
        /* solhint-disable no-inline-assembly */
        /// @solidity memory-safe-assembly
        assembly {
            sender := shr(96, calldataload(sub(calldatasize(), 20)))
        }
        /* solhint-enable no-inline-assembly */
    }

    /**
     * @notice Returns the FallbackManager address
     * @return Fallback manager address
     */
    function _manager() internal view returns (address) {
        return msg.sender;
    }
}
