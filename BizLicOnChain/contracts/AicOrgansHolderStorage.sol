pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

import { ArrayUtils } from "./ArrayUtils.sol";

contract AicOrgansHolderStorage is BaseAicOrgansHolder {
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
     	只允许逻辑合约来调用
     */
    modifier onlyLogic() {
    	require(logic == msg.sender,'only logic contract can invoke this function.');
    	_;
    }
    
    /**
     	只允许逻辑合约或代理来调用
     */
    modifier onlyLogicOrProxy() {
    	require(logic == msg.sender || proxy == msg.sender ,'only logic contract can invoke this function.');
    	_;
    }
    
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public onlyLogic returns (bool) {
        if(!ArrayUtils.contains(getAdmins(),admin)){
            administrators.push(admin);
        }
        return true;
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyLogic returns (bool) {
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       ArrayUtils.remove(administrators,admin);
       return true;
    }
    
     /**
     * 获取所有的管理员
     */
    function getAdmins() public view onlyLogicOrProxy returns(address[] memory admins){
        return administrators;
    }
    
    /**
     * 新增或修改一个发证机关
     */
    function putOrgan(string memory organCode,string memory organName,address publicKey) public onlyLogic returns (bool) {
        aicOrgans[organCode].organCode = organCode;
        aicOrgans[organCode].organName = organName;
        aicOrgans[organCode].publicKey = publicKey;
        aicOrgans[organCode].isUsed = true;
        if(!ArrayUtils.contains(aicOrganCodes,organCode)){
        	aicOrganCodes.push(organCode);
        }
        return true;
    }
    
    /** 获取所有发证机关编号 */
    function getAllOrganCodes() public view onlyLogic returns(string[] memory){
    	return aicOrganCodes;
    }
    
    //以下设置各个字段
    function setOrganCode(string memory organCode) public onlyLogic returns (bool) {
    	aicOrgans[organCode].organCode = organCode;
    	aicOrgans[organCode].isUsed = true;
    	if(!ArrayUtils.contains(aicOrganCodes,organCode)){
        	aicOrganCodes.push(organCode);
        }
        return true;
    }
    
    function setOrganName(string memory organCode,string memory organName) public onlyLogic returns (bool) {
    	aicOrgans[organCode].organName = organName;
    	aicOrgans[organCode].isUsed = true;
    	if(!ArrayUtils.contains(aicOrganCodes,organCode)){
        	aicOrganCodes.push(organCode);
        }
        return true;
    }
    
    function setPublicKey(string memory organCode,address publicKey) public onlyLogic returns (bool) {
    	aicOrgans[organCode].publicKey = publicKey;
    	aicOrgans[organCode].isUsed = true;
    	if(!ArrayUtils.contains(aicOrganCodes,organCode)){
        	aicOrganCodes.push(organCode);
        }
        return true;
    }
    
    /**
     * 删除一个发证机关
     */
    function removeOrgan(string memory organCode) public onlyLogic returns (bool) {
        require(bytes(organCode).length>0);
        delete aicOrgans[organCode];
        ArrayUtils.remove(aicOrganCodes,organCode);
        return true;
    }
    
    //以下获取各个字段
    function getOrganName(string memory organCode) public view onlyLogic returns (string memory) {
    	return aicOrgans[organCode].organName;
    }
    
    function getPublicKey(string memory organCode) public view onlyLogic returns (address) {
    	return aicOrgans[organCode].publicKey;
    }
}