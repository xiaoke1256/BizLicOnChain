pragma solidity ^0.4.25;

/**
 * 合约代理
 */
contract BizLicOnChainProxy {
    address creator;

    constructor() public{
        creator = msg.sender;
    }
}
