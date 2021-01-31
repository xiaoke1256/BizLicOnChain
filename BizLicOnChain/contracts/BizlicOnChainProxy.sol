pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { BaseBizLicOnChain } from "./BaseBizLicOnChain.sol";

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";

import { StringUtils } from "./StringUtils.sol";

/**
 * 合约代理
 */
contract BizLicOnChainProxy is BaseBizLicOnChain {
    
    address creator;
    
    /*
     * 所有营业执照（key是组织机构代码，value是营业执照的内容）
     */
    mapping(string => BizLic) bizLics;
    
    /**
     * 所有企业的统一社会信用码
     */
    string[] uniScIds;
    
    bool internal _initialized = false;
	
	/**
     * 发证机关合约地址
     */
    address aicOrganHolder;
    
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
    function initialize(address newVersion,address newAicOrganHolder) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
		aicOrganHolder = newAicOrganHolder;
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
	 * 工商机关版本发生变化
	 */
	function setAicOrganHolder(address newVersion) public onlyCreator{
		require(_initialized);
		aicOrganHolder = newVersion;
	}
	
	
	function getCurrentVersion() public view returns (address){
	    return currentVersion;
	}
	
	function getAicOrganHolder() public view returns (address){
	    return aicOrganHolder;
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
        (sucess,result)= aicOrganHolder.call(abi.encodeWithSignature("addAdmin(address)",admin));
        return (sucess && bytesToBool(result));
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public returns(bool){
       require(_initialized);
       bool sucess;
       bytes memory result;
       (sucess,result)= aicOrganHolder.call(abi.encodeWithSignature("removeAdmin(address)",admin));
       return (sucess && bytesToBool(result));
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public returns(address[] memory admins){
        require(_initialized);
        return AicOrgansHolderProxy(aicOrganHolder).getAdmins();
    }
    
    /**
     * 注册一个发证机关
     */
    function regestOrgan(string memory organCode,string memory organName,address publicKey) public returns(bool){
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= aicOrganHolder.call(abi.encodeWithSignature("regestOrgan(string,string,address)",organCode,organName,publicKey));
        return (sucess && bytesToBool(result));
    }
    
    function removeOrgan(string memory organCode)public returns(bool) {
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= aicOrganHolder.call(abi.encodeWithSignature("removeOrgan(string)",organCode));
        return (sucess && bytesToBool(result));
    }
    
    
    /**
     * 获取指定发证机关
     */
    function getOrgan(string memory organCode) public returns(string memory) {
        require(_initialized);
		//bool sucess;
        //bytes memory result;
		return AicOrgansHolderProxy(aicOrganHolder).getOrgan(organCode);
		//(sucess,result)= aicOrganHolder.call(abi.encodeWithSignature("getOrgan(string)",organCode));
		//require(sucess);
		//return string(result);
    }
    
    /**
     * 获取所有的发证机关
     */
    function getAllOrganCodes() public returns(string[] memory){
		//bool sucess;
        //bytes memory result;
		return AicOrgansHolderProxy(aicOrganHolder).getAllOrganCodes();
		//(sucess,result)= aicOrganHolder.call(abi.encodeWithSignature("getAllOrganCodes()"));
		//require(sucess);
		//return string(result);
    }
    
    /**
     * 往区块链上新增或修改一个证书
     * uniScId: 统一社会信用码，作为企业的唯一标识
     * organCode: 发证机关
     * licContent: 证书内容（拼成json）
     * sign: 电子签名
     * 
     */
    function putLic(string memory uniScId,string memory organCode,string memory licContent,string memory sign) public returns (bool){
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putLic(string,string,string,string)",uniScId,organCode,licContent,sign));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
    }
    
     /**
     * 删除一个证书
     * uniScId: 统一社会信用码，作为企业的唯一标识
     * 
     */
    function removeLic(string memory uniScId) public returns (bool){
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("removeLic(string)",uniScId));
         if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
    }
    
    /**
     * 获取证书内容
     */
    function getLicContent(string memory uniScId) public view returns(string memory)  {
        require(_initialized);
        return bizLics[uniScId].licContent;
    }
    
    /**
     * 获取证书上的签名
     */
    function getSignByUniScId(string memory uniScId) public view returns(string memory) {
         require(_initialized);
        return bizLics[uniScId].sign;
    }
    
    /**
     * 把字节数组转成布尔型
     */
    function bytesToBool(bytes memory b) private pure returns(bool){
        return abi.decode(b,(bool));
    }
	
	/**
	 * 获取所有的企业社会信用码
	 */
	function getAllUniScIds()public view returns (string memory){
	    string memory s = '[';
        for(uint64 i = 0;i<uniScIds.length;i++){
            if(i>0){
                s=StringUtils.concat(s,",");
            }
            s=StringUtils.concat(s,"'",uniScIds[i],"'");
        }
        s=StringUtils.concat(s,"]");
        return s;
	}
	
	 /**
	 * 解析异常信息。
	 */
	function parseErrMsg(bytes memory b) private pure returns(string memory){
		if(b.length==0){
			return '';
		}
		require(b.length<2**64,"The Array is out of bound.");
		for(uint64 i = 0;i<b.length-4;i++){
        	b[i]=b[i+4];
    	}
    	for(uint i = b.length-4;i<b.length;i++){
    		b[i]=0x0;
    	}
    	return abi.decode(b,(string));
	}
    
}
