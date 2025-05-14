// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {CTFHelpers} from "./CTFHelpers.sol";
import {IConditionalTokens} from "./interfaces/IConditionalTokens.sol";

contract ResolveMarket is Script {
    IConditionalTokens public ctf;
    string[8] categories;

    function run() external {
        categories = CTFHelpers.getCategories();

        // Read deployment values from broadcast
        address ctfAddress = vm.envAddress("CTF_ADDRESS");
        ctf = IConditionalTokens(ctfAddress);

        vm.startBroadcast();

        // Example final scores for each category
        uint8[] memory finalScores = new uint8[](CTFHelpers.NUM_CATEGORIES);
        finalScores[0] = 7; // Water Cycle
        finalScores[1] = 8; // Biodiversity
        finalScores[2] = 8; // Social Impact
        finalScores[3] = 6; // Soil Health
        finalScores[4] = 7; // Carbon Cycle
        finalScores[5] = 8; // Economic Health
        finalScores[6] = 9; // Community Vitality
        finalScores[7] = 7; // Management

        // Resolve each category
        for (uint i = 0; i < CTFHelpers.NUM_CATEGORIES; i++) {
            bytes32 questionId = CTFHelpers.generateQuestionId(
                categories[i],
                block.timestamp
            );
            
            // Create payout vector (1 for the actual score, 0 for others)
            uint[] memory payouts = new uint[](CTFHelpers.SCORE_RANGE);
            payouts[finalScores[i]] = 1;

            // Report outcome
            ctf.reportPayouts(questionId, payouts);
        }

        vm.stopBroadcast();
    }
} 