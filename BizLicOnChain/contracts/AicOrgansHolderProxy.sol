pragma solidity ^0.6.0;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

import { StringUtils } from "./StringUtils.sol";

import { ArrayUtils } from "./ArrayUtils.sol";

contract AicOrgansHolderProxy is BaseAicOrgansHolder {
    
    bool internal _initialized = false;
    
    /**
     * 逻辑合约地址
     */
    address currentVersion;
    
    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }
	
	/**
	 * 创建合约
	 */
    constructor() public{
        creator = msg.sender;
    }
    
    /**
     * 初始化合约
     */
    function initialize(address newVersion) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("initialize()"));
        require(sucess,'Fail to execute initialize function.');//初始化合约
        _initialized = true;
    }
    
    /**
     * 合约版本变更
     */
    function changeContract(address newVersion) public onlyCreator{
        require(_initialized);
        currentVersion = newVersion;
    }
    
    /**
     * 将老版本数据加载过来
     */
    function reloadData(address oldVersion) public onlyCreator{
        require(_initialized);
		bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("reloadData(address)",oldVersion));
        require(sucess);
    }
    
     //以下业务函数
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public returns(bool) {
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("addAdmin(address)",admin));
        return (sucess && bytesToBool(result));
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public returns(bool){
       require(_initialized);
       bool sucess;
       bytes memory result;
       (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("removeAdmin(address)",admin));
       return (sucess && bytesToBool(result));
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view returns(address[] memory admins){
        require(_initialized);
        return administrators;//BizlicOnChain(currentVersion).getAdmins();
    }
	
	/**
	 * 确定某地址是否是管理员
	 */
	function isAdmin(address a) public view returns(bool){
		require(_initialized);
		return ArrayUtils.contains(administrators,a);
	}
    
    /**
     * 注册一个发证机关
     */
    function regestOrgan(string memory organCode,string memory organName,address publicKey) public returns(bool){
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("regestOrgan(string,string,address)",organCode,organName,publicKey));
        return (sucess && bytesToBool(result));
    }
    
    function removeOrgan(string memory organCode)public returns(bool) {
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("removeOrgan(string)",organCode));
        return (sucess && bytesToBool(result));
    }
    
    
    /**
     * 获取所有发证机关
     */
    function getOrgan(string memory organCode) public view returns(string memory) {
        require(_initialized);
        if(!aicOrgans[organCode].isUserd){
            return "null";
        }
        string[] memory strArr = new string[](7);
        strArr[0]="{organCode:'";
        strArr[1]=organCode;
        strArr[2]="',organName:'";
        strArr[3]=aicOrgans[organCode].organName;
        strArr[4]="',publicKey:'";
        strArr[5]=StringUtils.address2str(aicOrgans[organCode].publicKey);
        strArr[6]="'}";
        return StringUtils.concat(strArr);
    }
    
    /**
     * 获取所有的发证机关
     */
    function getAllOrganCodes() public view returns(string memory){
        string memory s = '[';
        for(uint64 i = 0;i<aicOrganCodes.length;i++){
            if(i>0){
                s=StringUtils.concat(s,",");
            }
            s=StringUtils.concat(s,"'",aicOrganCodes[i],"'");
        }
        s=StringUtils.concat(s,"]");
        return s;
    }

	 /**
     * 把字节数组转成布尔型
     */
    function bytesToBool(bytes memory b) private pure returns(bool){
        return bytesToUint(b)!=0;
    }
    
    /**
     * 把字节数组转成整数
     */
    function bytesToUint(bytes memory b) private pure returns (uint8){
	    uint8 number = 0;
	    for(uint64 i= 0; i<b.length; i++){
	        number = uint8(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
	    }
	    return number;
	}

}
