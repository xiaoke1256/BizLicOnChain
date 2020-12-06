pragma solidity ^0.6.0;

import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { BizLicOnChainProxy } from "./BizLicOnChainProxy.sol";

contract StockHolderOnChainProxy is BaseStockHolderOnChain {

    constructor() public{
        creator = msg.sender;
    }
    
    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }
    
    /**
     * 初始化合约
     * newVersion 合约新版本
     * bizLicContract 管理营业执照的合约
     */
    function initialize(address newVersion,address newBizLicContract) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        bizLicContract = newBizLicContract;
        aicOrganHolder = BizLicOnChainProxy(newBizLicContract).getAicOrganHolder();
        _initialized = true;
    }
    
    /**
     * 版本发生变化
     */
    function changeCurrentVersion(address newVersion)public onlyCreator{
        require(_initialized);
        currentVersion = newVersion;
    }
    
    /**
     * 管理营业执照的合约版本发生变化
     */
    function changeBizLicContract(address newBizLicContract)public onlyCreator{
        require(_initialized);
        bizLicContract = newBizLicContract;
        aicOrganHolder = BizLicOnChainProxy(newBizLicContract).getAicOrganHolder();
    }

	/**
     * 设立股权(市监局操作)，
     * 股东的新增修改操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     */
    function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName,string memory stockRightDetail,uint cptAmt) public returns (bool){
		require(_initialized);
		require(uint160(currentVersion)>0,'currentVersion is Empty!');
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putStockHolder(string,string,string,string,uint256)",uniScId,investorCetfHash,investorName,stockRightDetail,cptAmt));
        require(sucess,'remote invork fail when putStockHolder!');
		require(bytesToBool(result),'return wrong');
		return (sucess && bytesToBool(result));
    }
    
    /**
     * 设立股权(市监局操作)，
     * 股东的新增修改操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     */
    function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName,address payable investorAccount,string memory stockRightDetail,uint cptAmt) public returns (bool){
    	require(_initialized);
		require(uint160(currentVersion)>0,'currentVersion is Empty!');
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putStockHolder(string,string,string,address,string,uint256)",uniScId,investorCetfHash,investorName,investorAccount,stockRightDetail,cptAmt));
        require(sucess,'remote invork fail when putStockHolder!');
		require(bytesToBool(result),'return wrong');
		return (sucess && bytesToBool(result));
    }

	/**
     * 修改股东的股权交易地址
     */
	function putStockHolderAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public returns (bool){
		require(_initialized);
		require(uint160(currentVersion)>0,'currentVersion is Empty!');
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putStockHolderAccount(string,string,address)",uniScId,investorCetfHash,investorAccount));
        require(sucess,'remote invork fail when putStockHolder!');
		require(bytesToBool(result),'return wrong');
		return (sucess && bytesToBool(result));
	}
    
	/**
     * 增减资(市监局操作)
     * uniScId 统一社会信用码
     * investorNo 股东编号
     * investorCetfHash 股东身份信息（用于核对）
     * stockRightDetail 增减资,肯定会引起股权详情的变化
     * amt 增资额度，可以为负 
     */
    function increCpt(string memory uniScId,string memory investorCetfHash,string memory stockRightDetail,int amt) public returns (bool){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("increCpt(string,string,string,int256)",uniScId,investorCetfHash,stockRightDetail,amt));
        if(!sucess){
        	//远程调用失败
        	string memory errorMsg = string(result);
        	require(sucess,errorMsg);
        }
        require(bytesToBool(result),'调用远程函数逻辑出错，请检查一下参数,及余额.');
        return bytesToBool(result);
    }
	
	/**
	 * 取消股权(市监局操作),删除股东
	 */
    function removeStockHolder(string memory uniScId,string memory investorCetfHash)public returns (bool){
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("removeStockHolder(string,string)",uniScId,investorCetfHash));
        return (sucess && bytesToBool(result));
    }
	
	/**
	 * 查看现有股东(按uniScId)
	 */
	function getStockHolders(string memory uniScId) public returns (string memory){
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("getStockHolders(string)",uniScId));
		require(sucess,'remote invork fail!');
        return abi.decode(result,(string));
	}

	/**
	 *	检查股东账号
	 */
	function checkStockHoldersAccount(string memory uniScId,string memory investorCetfHash,address account)public returns(bool) {
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("checkStockHoldersAccount(string,string,address)",uniScId,investorCetfHash,account));
		require(sucess,'remote invork fail!');
		return abi.decode(result,(bool));
	}
	
	/**
	 * 获取股东账号
	 */
	function getStockHoldersAccount(string memory uniScId,string memory investorCetfHash)public returns(address) {
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("getStockHoldersAccount(string,string)",uniScId,investorCetfHash));
		require(sucess,'remote invork fail when getStockHoldersAccount!');
		return abi.decode(result,(address));
	}
	
	 /**
	 * 查看现有股东的出资
	 */
	function getStockHolderCptAmt(string memory uniScId,string memory investorCetfHash) public returns (uint){
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("getStockHolderCptAmt(string,string)",uniScId,investorCetfHash));
		require(sucess,'remote invork fail when getStockHolderCptAmt!');
        return abi.decode(result,(uint));
	}
	
    /**
     * 把字节数组转成布尔型
     */
    function bytesToBool(bytes memory b) private pure returns(bool){
        return abi.decode(result,(bool));
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
