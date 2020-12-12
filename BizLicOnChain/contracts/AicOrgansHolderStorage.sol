pragma solidity ^0.6.0;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

contract AicOrgansHolderProxy is BaseAicOrgansHolder {
    /**存储合约的地址*/
    address proxy;
    /**逻辑合约的地址*/
    address logic;
    
    /**
	 * 创建合约
	 */
    constructor() public{
        creator = msg.sender;
    }
    
    /**
           仅创建本合约的地址才可以调用
     */
    modifier onlyCreator() {
       require(msg.sender == creator);
       _;
    }
}