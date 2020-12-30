pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

import { StringUtils } from "./StringUtils.sol";

import { ArrayUtils } from "./ArrayUtils.sol";

contract AicOrgansHolderProxy /*is BaseAicOrgansHolder*/ {

	address creator;
	
	address storageContract;
	
    /**
     * 逻辑合约地址
     */
    address logicVersion;
    
    bool internal _initialized = false;
    
  
    
    modifier onlyCreator() {
        require(msg.sender == creator,'Only creator can excute this function');
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
    function initialize(address newVersion,address store) public onlyCreator{
        require(!_initialized,'Has inited!');
        bool sucess;
        bytes memory result;
        storageContract = store;
        (sucess,result)= storageContract.call(abi.encodeWithSignature("setProxy(address)",address(this)));
        if(!sucess){
        	require(sucess,parseErrMsg(result));//初始化合约
        }
        logicVersion = newVersion;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("initialize()"));
        if(!sucess){
        	require(sucess,parseErrMsg(result));//初始化合约
        }
        _initialized = true;
    }
    
    /**
     * 合约版本变更
     */
    function changeLogic(address newVersion) public onlyCreator{
        require(_initialized);
        logicVersion = newVersion;
        //要把逻辑合约地址通知存储合约
        bool sucess;
        (sucess,)= storageContract.call(abi.encodeWithSignature("setLogic(address)",logicVersion));
         require(sucess,'Fail to execute changeLogic function.');//初始化合约
    }
    
    /**
     * TODO 更换存储合约
     */
     
    
    /**
     * 将老版本数据加载过来
     */
    function reloadData(address oldVersion) public onlyCreator{
        require(_initialized);
		bool sucess;
        (sucess,)= logicVersion.delegatecall(abi.encodeWithSignature("reloadData(address)",oldVersion));
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
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("addAdmin(address)",admin));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return (sucess && bytesToBool(result));
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public returns(bool){
       require(_initialized);
       bool sucess;
       bytes memory result;
       (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("removeAdmin(address)",admin));
       if(!sucess){
       	  require(sucess,parseErrMsg(result));
       }
       return (sucess && bytesToBool(result));
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public returns(address[] memory admins){
        require(_initialized,'Has not inited.');
        bool sucess;
        bytes memory result;
        (sucess,result) = logicVersion.delegatecall(abi.encodeWithSignature("getAdmins()"));
        if(!sucess){
       	   require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(address[]));
    }
	
	/**
	 * 确定某地址是否是管理员
	 */
	function isAdmin(address a) public view returns(bool){
		require(_initialized);
		//return ArrayUtils.contains(administrators,a);
		return false;
	}
    
    /**
     * 注册一个发证机关
     */
    function regestOrgan(string memory organCode,string memory organName,address publicKey) public returns(bool){
        require(_initialized,'Has not inited!');
        bool sucess;
        bytes memory result;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("regestOrgan(string,string,address)",organCode,organName,publicKey));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return (sucess && bytesToBool(result));
    }
    
    function removeOrgan(string memory organCode)public returns(bool) {
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("removeOrgan(string)",organCode));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return (sucess && bytesToBool(result));
    }
    

    function getOrganName(string memory organCode) private returns (string memory) {
    	bool sucess;
        bytes memory result;
        (sucess,result) = storageContract.call(abi.encodeWithSignature("getOrganName(string)",organCode));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(string));
    }
    
    function getIsUsed(string memory organCode) private returns (bool) {
    	bool sucess;
        bytes memory result;
        (sucess,result) = storageContract.call(abi.encodeWithSignature("getIsUsed(string)",organCode));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(bool));
    }
    
    function getPublicKey(string memory organCode) private returns (address) {
    	bool sucess;
        bytes memory result;
        (sucess,result) = storageContract.call(abi.encodeWithSignature("getOrganName(string)",organCode));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(address));
    }
    
    
    /**
     * 获取所有发证机关
     */
    function getOrgan(string memory organCode) public returns(string memory) {
        require(_initialized);
        if(!getIsUsed(organCode)){
            return "null";
        }
        string memory organName = getOrganName(organCode);
        address publicKey = getPublicKey(organCode);
        string[] memory strArr = new string[](7);
        strArr[0]="{organCode:'";
        strArr[1]=organCode;
        strArr[2]="',organName:'";
        strArr[3]=organName;
        strArr[4]="',publicKey:'";
        strArr[5]=StringUtils.address2str(publicKey);
        strArr[6]="'}";
        return StringUtils.concat(strArr);
    }
    
    /**
     * 获取所有的发证机关
     */
    function getAllOrganCodes() public returns(string[] memory){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= storageContract.call(abi.encodeWithSignature("getAllOrganCodes()"));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(string[]));
    }

	 /**
     * 把字节数组转成布尔型
     */
    function bytesToBool(bytes memory b) private pure returns(bool){
        return abi.decode(b,(bool));
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
