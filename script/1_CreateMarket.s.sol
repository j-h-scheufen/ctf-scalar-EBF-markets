// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {CTFHelpers} from "./CTFHelpers.sol";
import {IConditionalTokens} from "./interfaces/IConditionalTokens.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract CreateMarket is Script {
    IConditionalTokens public ctf;
    IERC20 public dai;
    address public oracle;
    string[8] categories;

    bytes32[] public conditionIds;
    bytes32[] public questionIds;

    function run() external {
        categories = CTFHelpers.getCategories();

        // Read deployment values from broadcast
        address ctfAddress = vm.envAddress("CTF_ADDRESS");
        address collateralAddress = vm.envAddress("COLLATERAL_ADDRESS");
        oracle = vm.envAddress("ORACLE_ADDRESS");

        ctf = IConditionalTokens(ctfAddress);
        dai = IERC20(collateralAddress);

        vm.startBroadcast();

        // Create conditions for each EBF category
        for (uint i = 0; i < CTFHelpers.NUM_CATEGORIES; i++) {
            bytes32 questionId = CTFHelpers.generateQuestionId(
                categories[i],
                block.timestamp
            );
            questionIds.push(questionId);

            // Prepare condition with SCORE_RANGE outcomes (0-10)
            ctf.prepareCondition(oracle, questionId, CTFHelpers.SCORE_RANGE);
            
            // Store conditionId for future reference
            conditionIds.push(ctf.getConditionId(
                oracle,
                questionId,
                CTFHelpers.SCORE_RANGE
            ));
        }

        // Fund the market with initial liquidity
        dai.approve(ctfAddress, CTFHelpers.COLLATERAL_AMOUNT);
        
        // Split positions for each category
        for (uint i = 0; i < CTFHelpers.NUM_CATEGORIES; i++) {
            uint[] memory partition = new uint[](CTFHelpers.SCORE_RANGE);
            for (uint j = 0; j < CTFHelpers.SCORE_RANGE; j++) {
                partition[j] = 1 << j;
            }
            
            ctf.splitPosition(
                collateralAddress,
                bytes32(0),
                conditionIds[i],
                partition,
                CTFHelpers.COLLATERAL_AMOUNT / CTFHelpers.NUM_CATEGORIES
            );
        }

        vm.stopBroadcast();
    }
} 