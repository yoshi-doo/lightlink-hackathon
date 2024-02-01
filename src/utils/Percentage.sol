// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13 .0;

library Percentages {
    function percentage(uint256 amount, uint256 bps) internal pure returns (uint256) {
        require((amount * bps) >= 10_000, "Values round off to zero");
        return (amount * bps) / 10_000;
    }
}
