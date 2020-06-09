pragma solidity ^0.6.0;

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
    
    /*
     * 所有营业执照（key是组织机构代码，value是营业执照内容的json）
     */
    mapping(string => BizLic) bizLics;
    
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
    function regestOrgan(string memory organCode,string memory organName,address publicKey) public {
        require(_initialized);
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("regestOrgan(string,string,address)",organCode,organName,publicKey));
        require(sucess);
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
     * 往区块链上新增或修改一个证书
     * uniScId: 统一社会信用码，作为企业的唯一标识
     * organCode: 发证机关
     * licContent: 证书内容（拼成json）
     * sign: 电子签名
     * 
     */
    function putLic(string memory uniScId,string memory organCode,string memory licContent,string memory sign) public {
        require(_initialized);
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("putLic(string,string,string,string)",uniScId,organCode,licContent,sign));
        require(sucess);
    }
    
     /**
     * 删除一个证书
     * uniScId: 统一社会信用码，作为企业的唯一标识
     * 
     */
    function removeLic(string memory uniScId) public{
        require(_initialized);
        bool sucess;
        (sucess,)= currentVersion.delegatecall(abi.encodeWithSignature("removeLic(string)",uniScId));
        require(sucess);
    }
    
    /**
     * 获取证书内容
     */
    function getLicContent(string memory uniScId) public view returns(string memory)  {
        require(_initialized);
        return bizLics[uniScId].licContent;
    }
    
}
