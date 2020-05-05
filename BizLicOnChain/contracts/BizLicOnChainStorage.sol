pragma solidity ^0.4.25;

/**
 * 合约的存储模块。
 */
contract BizLicOnChainStorage {
    address creator;
    
    /*
     * 管理员
     */
    address[] administrators;

    constructor() public{
        creator = msg.sender;
    }
}
