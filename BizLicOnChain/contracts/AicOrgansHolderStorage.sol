pragma solidity ^0.6.0;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

contract AicOrgansHolderProxy is BaseAicOrgansHolder {
    /**代理合约的地址*/
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
       require(msg.sender == creator,'only creator can use this function.');
       _;
    }
    
    /**
            设置代理合约的地址
    */
    function setProxy(address proxyAddress) public onlyCreator returns(bool){
    	proxy = proxyAddress;
    }
    
    /**
            设置逻辑合约的地址
    */
    function setLogic(address logicAddress) public onlyCreator returns(bool){
    	logic = logicAddress;
    }
    
    /**
           是否已完成初始化？
    */
    modifier isInitialized() {
    	require(proxy != address(0),'proxy contract'a adress must be set.');
    	require(logic != address(0),'logic contract'a adress must be set.');
    	_;
    }
}