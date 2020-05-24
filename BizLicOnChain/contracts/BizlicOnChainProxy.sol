pragma solidity ^0.5.0;

import { BaseBizLicOnChain } from "./BaseBizLicOnChain.sol";

import { StringUtils } from "./StringUtils.sol";

/**
 * 合约代理
 */
contract BizLicOnChainProxy is BaseBizLicOnChain {
    
    address creator;
    
     /*
     * 管理员
     */
    address[] administrators;
    
    /**
     * 所有工商机关
     */
    mapping(string => AicOrgan) aicOrgans;
    
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
        administrators = BizLicOnChainProxy(oldVersion).getAdmins();
        //....
    }
    
     //以下业务函数
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public {
        require(_initialized);
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("addAdmin(address)",admin));
        require(sucess);
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public{
       require(_initialized);
       bool sucess;
       (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("removeAdmin(address)",admin));
       require(sucess);
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view returns(address[] memory admins){
        require(_initialized);
        return administrators;//BizlicOnChain(currentVersion).getAdmins();
    }
    
    /**
     * 注册一个发证机关
     */
    function regestOrgan(string memory organCode,string memory organName,string memory publicKey) public {
        require(_initialized);
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("regestOrgan(string,string,bytes)",organCode,organName,bytes(publicKey)));
        require(sucess);
//        aicOrgans[organCode].organCode = organCode;
//        aicOrgans[organCode].organName = organName;
//        aicOrgans[organCode].publicKey = bytes(publicKey);
//        aicOrgans[organCode].isUserd = true;
    }
    
    function removeOrgan(string memory organCode)public {
        require(_initialized);
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("removeOrgan(string)",organCode));
        require(sucess);
    }
    
    
    /**
     * 获取所有发证机关
     */
    function getOrgan(string memory organCode) public view returns(string memory) {
        require(_initialized);
        if(!aicOrgans[organCode].isUserd){
            return "";
        }
        //string[] strArr;
        // = ["{organCode:'",organCode,"',organName:'",organ.organName,"',publicKey:'",string(organ.publicKey),"'}"]
        //strArr.push("{organCode:'");
        //strArr.push(organCode);
        //strArr.push("',organName:'");
        //strArr.push(organ.organName);
        //strArr.push("',publicKey:'");
        //strArr.push(string(organ.publicKey));
        //strArr.push("'}");
        return StringUtils.concat("{organCode:'",aicOrgans[organCode].organCode);
    }
    
}
