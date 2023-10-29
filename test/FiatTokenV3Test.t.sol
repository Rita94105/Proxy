// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { Merkle } from "murky/src/Merkle.sol";
import { FiatTokenV3 } from "../src/FiatTokenV3.sol";

contract FiatTokenV3Test is Test {
    // Owner and users
    address owner = 0xFcb19e6a322b27c06842A71e8c725399f049AE3a;
    address proxy = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address admin;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address user3 = makeAddr("user3");

    // Merkle
    bytes32[] public leaf;
    bytes32 public merkleRoot;
    bytes32[] public merkleProof;
    Merkle m = new Merkle();

    // Contracts
    FiatTokenV3 tokenv3;
    FiatTokenV3 proxyTokenv3;

    function setUp() public{
        leaf = new bytes32[](2);
        leaf[0] = keccak256(abi.encodePacked(user1));
        leaf[1] = keccak256(abi.encodePacked(user2));
        merkleRoot = m.getRoot(leaf);
        merkleProof = m.getProof(leaf, 0);
    }

    function bytes32ToAddress(bytes32 _bytes32) internal pure returns (address) {
        return address(uint160(uint256(_bytes32)));
    }

    function testupgradeToV3() public {
        uint256 forkId = vm.createFork("https://mainnet.infura.io/v3/{id}");
        vm.selectFork(forkId);
        tokenv3 = new FiatTokenV3();
        //get admin address through ADMIN_SLOT
        admin = bytes32ToAddress(vm.load(proxy, 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b));
        // upgrade to v3 through admin account
        vm.startPrank(admin);
        (bool success,) = proxy.call(abi.encodeWithSignature("upgradeTo(address)", address(tokenv3)));
        require(success);
        vm.stopPrank();

        vm.startPrank(user1);
        proxyTokenv3 = FiatTokenV3(address(proxy));
        // check if the upgrade is successful
        assertEq(proxyTokenv3.Version(), "3");
        // initialize the new contract
        proxyTokenv3.InitializeV3(merkleRoot);
        // check if the mint is successful through user1 who is in the whitelist
        proxyTokenv3.mint(merkleProof, 10);
        // check if mint is successful
        assertEq(proxyTokenv3.balanceOf(user1), 10);
        // check if the transfer is successful through user1 who is in the whitelist
        proxyTokenv3.transfer(merkleProof, user2, 5);
        // check if transfer is successful
        assertEq(proxyTokenv3.balanceOf(user1), 5);
        assertEq(proxyTokenv3.balanceOf(user2), 5);
        vm.stopPrank();

        /*
        // use user3 who is not in the whitelist to mint token
        // should fail
        vm.startPrank(user3);
        proxyTokenv3.mint(merkleProof, 1);
        assertEq(proxyTokenv3.balanceOf(user3), 0);
        vm.stopPrank();*/
    }
}
