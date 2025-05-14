// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockERC20} from "./mocks/MockERC20.sol";
import {CTFHelpers} from "./CTFHelpers.sol";
import {IConditionalTokens} from "./interfaces/IConditionalTokens.sol";

contract DeployContracts is Script {
    // Gnosis Chain CTF deployment
    address constant GNOSIS_CTF = 0xC59b0e4De5F1248C1140964E0fF287B192407E0C;

    event Deployed(address ctf, address collateralToken, address oracle);

    function run() external {
        vm.startBroadcast();

        // Deploy mock ERC20 for testing
        MockERC20 mockDai = new MockERC20("Mock DAI", "mDAI", 18);
        
        // For testing, we'll use msg.sender as oracle
        address oracle = msg.sender;

        // Mint initial supply to deployer and some test users
        address deployer = msg.sender;
        address testUser1 = vm.addr(1);
        address testUser2 = vm.addr(2);
        
        mockDai.mint(deployer, 1_000_000 ether);
        mockDai.mint(testUser1, 100_000 ether);
        mockDai.mint(testUser2, 100_000 ether);

        // Emit deployment info for subsequent scripts
        emit Deployed(GNOSIS_CTF, address(mockDai), oracle);

        vm.stopBroadcast();
    }
} 