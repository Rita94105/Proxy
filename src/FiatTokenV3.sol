// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract FiatTokenV3{
    //same slot as FiatTokenV2_1
    //Ownerable
    address private _owner;
    //Pausable
    address public pauser;
    bool public paused = false;
    //Blacklistable
    address public blacklister;
    mapping(address => bool) internal blacklisted;
    //FiatTokenV1
    string public name;
    string public symbol;
    uint8 public decimals;
    string public currency;
    address public masterMinter;
    bool internal initialized;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    uint256 internal totalSupply_ = 0;
    mapping(address => bool) internal minters;
    mapping(address => uint256) internal minterAllowed;
    //Rescuable
    address private _rescuer;
    //EIP712Domain
    bytes32 public DOMAIN_SEPARATOR;
    //EIP3009
    mapping(address => mapping(bytes32 => bool)) private _authorizationStates;
    //EIP2612
    mapping(address => uint256) private _permitNonces;
    //FiatTokenV2
    uint8 internal _initializedVersion;

    bytes32 private merkleRoot;
    mapping(address account => uint256) private _balances;

    modifier onlyWhite(bytes32[] memory _merkleProof) {
        require(inWhitelist(_merkleProof, msg.sender),"not in whitelist");
        _;
    }

    function v3Initialize(bytes32 _merkleRoot) external{
        require(_initializedVersion == 2);
        merkleRoot = _merkleRoot;
        _initializedVersion = 3;
    }

    function inWhitelist(bytes32[] memory _merkleProof, address _who) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(_who));
        return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
    }

    function mint(bytes32[] memory _merkleProof, uint256 amount) onlyWhite(_merkleProof) external {
        // TODO:
        // 1. Check if the user is in the whitelist
        // 2. if user is in the whitelist, mint the token without limitation
        totalSupply_ += amount;
        _balances[msg.sender] += amount;
    }

    function transfer(bytes32[] memory _merkleProof,address recipient, uint256 amount) onlyWhite(_merkleProof) public {
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
    }

    function Version() external pure returns (string memory) {
        return "3";
    }
    
}