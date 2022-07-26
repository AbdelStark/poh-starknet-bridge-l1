// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/ProofOfHumanityStarkNetBridge.sol";

contract ProofOfHumanityStarkNetBridgeTest is Test {
    address constant POH_PROXY_ADDRESS =
        0x1dAD862095d40d43c2109370121cf087632874dB;
    address constant STARKNET_MESSAGING_ADDRESS =
        0xc662c410C0ECf747543f5bA90660f6ABeBD9C8c4;
    uint256 constant REGISTRY_CONTRACT = 1;
    uint256 constant REGISTER_SELECTOR =
        453167574301948615256927179001098538682611778866623857597439531518333154691;
    uint256 constant USER_1_L2_ADDRESS = 1000;
    address constant UNKNOWN_USER = address(0);
    ProofOfHumanityStarkNetBridge pohBridge;

    function setUp() public {
        pohBridge = new ProofOfHumanityStarkNetBridge(
            POH_PROXY_ADDRESS,
            STARKNET_MESSAGING_ADDRESS
        );
        pohBridge.configureL2Parameters(REGISTRY_CONTRACT, REGISTER_SELECTOR);
    }

    function testConfigureL2ParametersMustOnlyBeSetOnce() public {
        vm.expectRevert(
            "ProofOfHumanityStarkNetBridge: L2 parameters can be set only once"
        );
        pohBridge.configureL2Parameters(REGISTRY_CONTRACT, REGISTER_SELECTOR);
    }

    function testConfigureL2ParametersOnlyCallableByOwner() public {
        ProofOfHumanityStarkNetBridge notConfiguredBridge = new ProofOfHumanityStarkNetBridge(
                POH_PROXY_ADDRESS,
                STARKNET_MESSAGING_ADDRESS
            );
        vm.prank(UNKNOWN_USER);
        vm.expectRevert("Ownable: caller is not the owner");
        notConfiguredBridge.configureL2Parameters(
            REGISTRY_CONTRACT,
            REGISTER_SELECTOR
        );
    }

    function testRegisterToL2RequireL2ParametersToBeSet() public {
        ProofOfHumanityStarkNetBridge notConfiguredBridge = new ProofOfHumanityStarkNetBridge(
                POH_PROXY_ADDRESS,
                STARKNET_MESSAGING_ADDRESS
            );
        vm.expectRevert(
            ProofOfHumanityStarkNetBridge.L2ParametersNotSet.selector
        );
        notConfiguredBridge.registerToL2(USER_1_L2_ADDRESS);
    }
}
