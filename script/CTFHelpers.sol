// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {IConditionalTokens} from "./interfaces/IConditionalTokens.sol";

library CTFHelpers {
    // Dynamic addresses to be set during deployment/initialization
    address public constant ZERO_ADDRESS = address(0);
    
    uint constant NUM_CATEGORIES = 8;
    uint constant SCORE_RANGE = 11; // 0 to 10 inclusive
    uint constant COLLATERAL_AMOUNT = 1000 ether;

    function getCategories() internal pure returns (string[8] memory) {
        return [
            "Water Cycle",
            "Biodiversity",
            "Social Impact",
            "Soil Health",
            "Carbon Cycle",
            "Economic Health",
            "Community Vitality",
            "Management"
        ];
    }

    function generateQuestionId(string memory category, uint256 timestamp) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("EBF evaluation for ", category, timestamp)
        );
    }
} 