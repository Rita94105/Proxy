// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { Merkle } from "murky/src/Merkle.sol";
import { FiatTokenV3 } from "../src/FiatTokenV3.sol";

contract FiatTokenV3Test is Test {
    // Owner and users
    address owner = 0xFcb19e6a322b27c06842A71e8c725399f049AE3a;
    address proxy = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    // Merkle
    bytes32[] public leaf;
    bytes32 public merkleRoot;
    Merkle m = new Merkle();

    // Contracts
    FiatTokenV3 tokenv3;
    FiatTokenV3 proxyTokenv3;

    function setUp() public{
        leaf = new bytes32[](2);
        leaf[0] = keccak256(abi.encodePacked(user1));
        leaf[1] = keccak256(abi.encodePacked(user2));
        merkleRoot = m.getRoot(leaf);
    }

    /*function upgradeToV3() public {
        uint256 forkId = vm.createFork("https://mainnet.infura.io/v3/55ecfe07fecb4b83913c0da51b5ad347");
        vm.selectFork(forkId);
        tokenv3 = new FiatTokenV3();
        vm.startPrank(owner);
        (bool success,) = proxy.call(abi.encodeWithSignature("upgradeTo(address)", address(tokenv3)));
        require(success);
        proxyTokenv3 = FiatTokenV3(proxy);
        assertEq(proxyTokenv3.Version(), "3");
        vm.stopPrank();
    }*/
}