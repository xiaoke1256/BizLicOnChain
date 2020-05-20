pragma solidity ^0.4.25;

import { BizLicOnChain } from "./BizLicOnChain.sol";

import { StringUtils } from "./StringUtils.sol";

/**
 * 合约代理
 */
contract BizLicOnChainProxy {
    
    address creator;
    
     /*
     * 管理员
     */
    address[] administrators;
    
    /**
     * 工商局
     */
    struct AicOrgan{
        string organCode;//机关代码
        string organName;//机关名称
        bytes publicKey;//公钥
    }
    
    /**
     * 所有工商机关
     */
    mapping(string => AicOrgan) aicOrgans;
    
    /**
     * 逻辑合约地址
     */
    address currentVersion;
    
    
    bool internal _initialized = false;
    
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
        require(currentVersion.delegatecall(bytes4(keccak256("initialize()"))),'Fail to execute initialize function.');//初始化合约
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
        require(currentVersion.delegatecall(bytes4(keccak256("addAdmin(address)")),admin));
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public{
       require(_initialized);
       require(currentVersion.delegatecall(bytes4(keccak256("removeAdmin(address)")),admin));
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
    function regestOrgan(string organCode,string organName,string publicKey) public {
        require(_initialized);
        require(currentVersion.delegatecall(bytes4(keccak256("regestOrgan(string,string,bytes)")),organCode,organName,bytes(publicKey)));
    }
    
    
    /**
     * 获取所有发证机关
     */
    function getOrgan(string organCode) public view returns(string memoery) {
        require(_initialized);
        AicOrgan memory organ = aicOrgans[organCode];
        if(organ.organCode==''){
            return '';
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
        return StringUtils.concat("{organCode:'",organ.organCode);
    }
    
}
