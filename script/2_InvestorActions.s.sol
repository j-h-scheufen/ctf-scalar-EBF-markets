// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {CTFHelpers} from "./CTFHelpers.sol";
import {IConditionalTokens} from "./interfaces/IConditionalTokens.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract InvestorActions is Script {
    IConditionalTokens public ctf;
    IERC20 public dai;
    address public oracle;
    string[8] categories;

    function run() external {
        categories = CTFHelpers.getCategories();

        // Read deployment values from broadcast
        address ctfAddress = vm.envAddress("CTF_ADDRESS");
        address collateralAddress = vm.envAddress("COLLATERAL_ADDRESS");
        oracle = vm.envAddress("ORACLE_ADDRESS");

        ctf = IConditionalTokens(ctfAddress);
        dai = IERC20(collateralAddress);

        vm.startBroadcast();

        // Example: Investor betting on high social impact (score 8) and biodiversity (score 7)
        bytes32 socialImpactCondition = ctf.getConditionId(
            oracle,
            CTFHelpers.generateQuestionId(categories[2], block.timestamp), // Social Impact
            CTFHelpers.SCORE_RANGE
        );

        bytes32 biodiversityCondition = ctf.getConditionId(
            oracle,
            CTFHelpers.generateQuestionId(categories[1], block.timestamp), // Biodiversity
            CTFHelpers.SCORE_RANGE
        );

        // Approve tokens for trading
        dai.approve(ctfAddress, 100 ether);

        // Buy position for social impact score of 8
        uint[] memory partition = new uint[](1);
        partition[0] = 1 << 8; // Position for score 8
        ctf.splitPosition(
            collateralAddress,
            bytes32(0),
            socialImpactCondition,
            partition,
            50 ether
        );

        // Buy position for biodiversity score of 7
        partition[0] = 1 << 7; // Position for score 7
        ctf.splitPosition(
            collateralAddress,
            bytes32(0),
            biodiversityCondition,
            partition,
            50 ether
        );

        vm.stopBroadcast();
    }
} 