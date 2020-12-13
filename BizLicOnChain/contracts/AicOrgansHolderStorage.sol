pragma solidity ^0.6.0;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

import { ArrayUtils } from "./ArrayUtils.sol";

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
    	require(proxy != address(0),'proxy contract\'s adress must be set.');
    	require(logic != address(0),'logic contract\'s adress must be set.');
    	_;
    }
    
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public isInitialized returns (bool) {
        if(!ArrayUtils.contains(administrators,admin)){
            administrators.push(admin);
        }
        return true;
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public isInitialized returns (bool) {
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       ArrayUtils.remove(administrators,admin);
       return true;
    }
    
     /**
     * 获取所有的管理员
     */
    function getAdmins() public view isInitialized returns(address[] memory admins){
        return administrators;
    }
    
    /**
     * 新增或修改一个发证机关
     */
    function putOrgan(string memory organCode,string memory organName,address publicKey) public isInitialized returns (bool) {
        aicOrgans[organCode].organCode = organCode;
        aicOrgans[organCode].organName = organName;
        aicOrgans[organCode].publicKey = publicKey;
        aicOrgans[organCode].isUsed = true;
        if(!ArrayUtils.contains(aicOrganCodes,organCode)){
        	aicOrganCodes.push(organCode);
        }
        return true;
    }
}