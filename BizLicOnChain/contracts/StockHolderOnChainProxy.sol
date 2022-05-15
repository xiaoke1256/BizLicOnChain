pragma solidity ^0.6.0;

import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { BizLicOnChainProxy } from "./BizLicOnChainProxy.sol";
import { StringUtils } from "./StringUtils.sol";

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
    
    function getCurrentVersion() public view returns (address){
        return currentVersion;
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
		require(_initialized,'has not inited.');

        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putStockHolder(string,string,string,string,uint256)",uniScId,investorCetfHash,investorName,stockRightDetail,cptAmt));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
		return bytesToBool(result);
    }
    
    /**
     * 设立股权(市监局操作)，
     * 股东的新增修改操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     */
    function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName,address payable investorAccount,string memory stockRightDetail,uint cptAmt) public returns (bool){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putStockHolder(string,string,string,address,string,uint256)",uniScId,investorCetfHash,investorName,investorAccount,stockRightDetail,cptAmt));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
		return bytesToBool(result);
    }

	/**
     * 修改股东的股权交易地址
     */
	function putStockHolderAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public returns (bool){
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("putStockHolderAccount(string,string,address)",uniScId,investorCetfHash,investorAccount));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
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
    function increCpt(string memory uniScId,string memory investorCetfHash,string memory stockRightDetail,uint amt) public returns (bool){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("increCpt(string,string,string,uint256)",uniScId,investorCetfHash,stockRightDetail,amt));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
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
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
    }
	
	/**
	 * 查看现有股东(按uniScId)
	 */
	function getStockHolders(string memory uniScId) public returns (string memory){
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("getStockHolders(string)",uniScId));
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(string));
	}
	
	/** 查单个股东 */
	function getStockHolder(string memory uniScId,string memory investorCetfHash) public returns (string memory){
		require(_initialized);
	    if(bytes(stockHolders[uniScId][investorCetfHash].investorCetfHash).length==0 || bytes(stockHolders[uniScId][investorCetfHash].uniScId).length==0){
	    	return 'null';
	    }
	    string memory s = '';

	    s=StringUtils.concat(s,'{');
		s=StringUtils.concat(s,'"uniScId":"',stockHolders[uniScId][investorCetfHash].uniScId,'"');
		s=StringUtils.concat(s,',');
		s=StringUtils.concat(s,'"investorName":"',stockHolders[uniScId][investorCetfHash].investorName,'"');
		s=StringUtils.concat(s,',');
		s=StringUtils.concat(s,'"investorAccount":"',StringUtils.address2str(stockHolders[uniScId][investorCetfHash].investorAccount),'"');
		s=StringUtils.concat(s,',');
		s=StringUtils.concat(s,'"investorCetfHash":"',stockHolders[uniScId][investorCetfHash].investorCetfHash,'"');
		s=StringUtils.concat(s,',');

		if(bytes(stockHolders[uniScId][investorCetfHash].stockRightDetail).length>0){
		  s=StringUtils.concat(s,'"stockRightDetail":', stockHolders[uniScId][investorCetfHash].stockRightDetail);
		}

		s=StringUtils.concat(s,',');
		s=StringUtils.concat(s,'"merkel":"',StringUtils.bytes32ToString(stockHolders[uniScId][investorCetfHash].merkel),'"');
		s=StringUtils.concat(s,',');
		s=StringUtils.concat(s,'"cptAmt":',StringUtils.uint2str(stockHolders[uniScId][investorCetfHash].cptAmt),'');
		s=StringUtils.concat(s,'}');
		return s;
	}

	/**
	 *	检查股东账号
	 */
	function checkStockHoldersAccount(string memory uniScId,string memory investorCetfHash,address account)public returns(bool) {
		require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("checkStockHoldersAccount(string,string,address)",uniScId,investorCetfHash,account));
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
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
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
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
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return abi.decode(result,(uint));
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
