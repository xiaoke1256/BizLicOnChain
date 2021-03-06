pragma solidity ^0.6.0;

import { ArrayUtils } from "./ArrayUtils.sol";

import { StringUtils } from "./StringUtils.sol";

contract AicOrgansHolder {

	address creator;
	
	address storageContract;
    /**
     * 逻辑合约地址(占位用)
     */
    address logicVersion;
    
    bool internal _initialized = false;
    
    constructor() public{
        creator = msg.sender;
    }

     /**
     * 初始化合约(用delegatecall来调用)
     */
    function initialize() external {
        require(creator == tx.origin,'Only creator can invoke the initialize function.');
        require(storageContract != address(0),'The storageContract\'s address can not be empty.');
        bool sucess;
        bytes memory result;
        (sucess,result)= storageContract.call(abi.encodeWithSignature("setLogic(address)",address(this)));
        if(!sucess){
            require(sucess,parseErrMsg(result));
        }
        (sucess,result)= storageContract.call(abi.encodeWithSignature("addAdmin(address)",tx.origin));
        if(!sucess){
            require(sucess,parseErrMsg(result));
        }
        _initialized = true;
    }
    
	/**
	 * 将老版本数据加载过来
	 */
	function reloadData(address oldVersion) public {
	    //.....
	}
    
    /**
     * 仅管理员才可以执行此
     */
    modifier onlyAdmin() {
        address[] memory administrators = getAdmins();
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		require(ArrayUtils.contains(administrators,tx.origin),"Unauthorized operation!");
		_;
    }
    
    //以下业务函数
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public onlyAdmin returns (bool) {
    	bool sucess;
        bytes memory result;
    	(sucess,result)= storageContract.call(abi.encodeWithSignature("addAdmin(address)",admin));
        if(!sucess){
            require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(bool));
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin returns (bool) {
       // 从 administrators中删除指定的管理员
       return true;
       bool sucess;
       bytes memory result;
       (sucess,result)= storageContract.call(abi.encodeWithSignature("removeAdmin(address)",admin));
       if(!sucess){
           require(sucess,parseErrMsg(result));
       }
       return abi.decode(result,(bool));
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public returns(address[] memory){
        bool sucess;
        bytes memory result;
    	(sucess,result)= storageContract.call(abi.encodeWithSignature("getAdmins()"));
    	if(!sucess){
           require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(address[]));
    }
	
	    
    /**
     * 注册一个发证机关
     */
    function regestOrgan(string memory organCode,string memory organName,address publicKey) public onlyAdmin returns (bool) {
     	require(_initialized,'AicOrgansHolder has not inited.');
     	require(storageContract != address(0),'The storage contract has not set.');
        bool sucess;
        bytes memory result;
        (sucess,result)= storageContract.call(abi.encodeWithSignature('putOrgan(string,string,address)',organCode,organName,publicKey));
        if(!sucess){
        	 require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(bool));
    }
    
    /**
     * 删除一个发证机关
     */
    function removeOrgan(string memory organCode) public onlyAdmin returns (bool) {
        bool sucess;
        bytes memory result;
        (sucess,result)= storageContract.call(abi.encodeWithSignature("removeOrgan(string)",organCode));
        if(!sucess){
        	 require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(bool));
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
