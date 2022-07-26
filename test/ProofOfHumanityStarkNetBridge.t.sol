// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/ProofOfHumanityStarkNetBridge.sol";
import "src/interfaces/IProofOfHumanityProxy.sol";
import "src/interfaces/IStarkNetMessaging.sol";

contract ProofOfHumanityStarkNetBridgeTest is Test {
    /// CONSTANTS
    address constant POH_PROXY_ADDRESS =
        0x1dAD862095d40d43c2109370121cf087632874dB;
    address constant STARKNET_MESSAGING_ADDRESS =
        0xc662c410C0ECf747543f5bA90660f6ABeBD9C8c4;
    uint256 constant REGISTRY_CONTRACT = 1;
    uint256 constant REGISTER_SELECTOR =
        453167574301948615256927179001098538682611778866623857597439531518333154691;
    address constant USER_1_L1_ADDRESS = address(1001);
    uint256 constant USER_1_L2_ADDRESS = 2001;
    address constant UNKNOWN_USER = address(0);

    /// FIELDS
    ProofOfHumanityStarkNetBridge pohBridge;

    /// EVENTS
    event L2RegistrationTriggered(
        address indexed _submissionID,
        uint256 _l2RecipientAddress,
        uint256 _timestamp
    );

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

    function testRegisterToL2WhenUserIsRegistered() public {
        // Call with user 1 L1 address
        vm.startPrank(USER_1_L1_ADDRESS);
        // Set timestamp to 1234
        uint256 currentTimestamp = 1234;
        vm.warp(currentTimestamp);
        // Mock isRegistered and return true
        vm.mockCall(
            POH_PROXY_ADDRESS,
            abi.encodeWithSelector(IProofOfHumanityProxy.isRegistered.selector),
            abi.encode(true)
        );
        // Mock sendMessageToL2
        vm.mockCall(
            STARKNET_MESSAGING_ADDRESS,
            abi.encodeWithSelector(IStarkNetMessaging.sendMessageToL2.selector),
            abi.encode(bytes32(0))
        );

        // Check emitted event
        vm.expectEmit(true, false, false, true);
        emit L2RegistrationTriggered(
            USER_1_L1_ADDRESS,
            USER_1_L2_ADDRESS,
            currentTimestamp
        );
        // Call registerToL2
        pohBridge.registerToL2(USER_1_L2_ADDRESS);

        vm.stopPrank();
    }

    function testRegisterToL2WhenUserIsNotRegistered() public {
        // Call with user 1 L1 address
        vm.startPrank(USER_1_L1_ADDRESS);
        // Mock isRegistered and return false
        vm.mockCall(
            POH_PROXY_ADDRESS,
            abi.encodeWithSelector(IProofOfHumanityProxy.isRegistered.selector),
            abi.encode(false)
        );
        // Expect revert
        vm.expectRevert(
            abi.encodeWithSignature("NotRegistered(address)", USER_1_L1_ADDRESS)
        );
        // Call registerToL2
        pohBridge.registerToL2(USER_1_L2_ADDRESS);
        vm.stopPrank();
    }
}
