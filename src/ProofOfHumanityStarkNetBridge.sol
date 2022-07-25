// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "openzeppelin-contracts/contracts/utils/Context.sol";
import "src/interfaces/IProofOfHumanityProxy.sol";

contract ProofOfHumanityStarkNetBridge is Context{

    IProofOfHumanityProxy private _pohProxy;

    constructor(address pohProxy_){
        _pohProxy = IProofOfHumanityProxy(pohProxy_);
    }

    function registerToL2(address _who) public {

    }

    function registerToL2() public {
        registerToL2(_msgSender());
    }

}
