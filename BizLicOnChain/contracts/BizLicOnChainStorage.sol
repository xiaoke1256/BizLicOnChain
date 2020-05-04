pragma solidity ^0.4.25;

/**
 * 合约的存储模块。
 */
contract BizLicOnChainStorage {
    address creator;

    constructor() public{
        creator = msg.sender;
    }
}
