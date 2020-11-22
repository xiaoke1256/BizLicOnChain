pragma solidity ^0.6.0;

import { StockHolderOnChainProxy } from "./StockHolderOnChainProxy.sol";
import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";

import { StringUtils } from "./StringUtils.sol";


contract StockRightApplyOnChainProxy is BaseStockRightApplyOnChain {
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
    function initialize(address newVersion,address newStockHolderContract) public onlyCreator returns (bool){
        require(!_initialized,"The contract has inited!");
        currentVersion = newVersion;
        stockHolderContract = newStockHolderContract;
        aicOrganHolder = StockHolderOnChainProxy(stockHolderContract).getAicOrganHolder();
        _initialized = true;
		return true;
    }
    
	/**
	 *发起股权转让
	 * uniScId 统一社会信用码
	 * transferorCetfHash 出让方股东身份证件信息
	 * investorName 受让方股东姓名
	 * investorCetfHash 受让方股东身份证件信息
	 * merkel 默克尔值
	 * cptAmt 转让份额（元）
	 * price 转让价格（以太币，wei）
	 * 返回是否成功
	 */
	function startStockTransfer(string memory uniScId,string memory transferorCetfHash,string memory investorName,
			string memory investorCetfHash,bytes32 merkel,uint cptAmt,uint price)public returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("startStockTransfer(string,string,string,string,bytes32,uint256,uint256)",uniScId,
			transferorCetfHash,investorName,investorCetfHash,merkel,cptAmt,price));
        return (sucess && bytesToBool(result));
	}
	
	/**
      设置新股东账号
	  uniScId 统一社会信用码
      investorCetfHash 新股东身份证件信息
      investorAccount 新股东账号
    */
	function setNewStockHolderAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("setNewStockHolderAccount(string,string,address)",uniScId,
			investorCetfHash,investorAccount));
        return (sucess && bytesToBool(result));
	}
	
	 //出让方公司的董事会确认转让
	function comfirmByDirectors(string memory uniScId,string memory investorCetfHash) public returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("comfirmByDirectors(string,string)",uniScId,investorCetfHash));
        return (sucess && bytesToBool(result));
	}
	
	//受让方出资
	function payForStock(string memory uniScId,string memory investorCetfHash)public payable returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("payForStock(string,string)",uniScId,investorCetfHash));
        return (sucess && bytesToBool(result));
	}
	
	/**
     * 工商局备案(市监局操作)
     * uniScId 统一社会信用码
     * investorCetfHash 受让方股东身份证件信息
     * isPass 是否审核通过
     * reason 审核不通过原因
     */
    function backUp(string memory uniScId,string memory investorCetfHash,bool isPass,string memory reason)public returns (bool){
    	require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("backUp(string,string,bool,string)",uniScId,investorCetfHash,isPass,reason));
        if(!sucess){
        	//远程调用失败
        	string memory msg = string(result);
        	require(sucess,msg);
        }
        require(bytesToBool(result),'调用远程函数逻辑出错，请检查一下参数,及余额.');
        return bytesToBool(result);
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
	
	function isInited() public view returns(bool){
	    return _initialized;
	}

	/** 
     获取Keys
     */
	function getStockRightApplyKeysByUniScId(string memory uniScId) public returns (string memory){
		string memory s = '[';
        for(uint64 i = 0;i<stockRightApplyKeys[uniScId].length;i++){
            if(i>0){
                s=StringUtils.concat(s,",");
            }
            s=StringUtils.concat(s,"'",stockRightApplyKeys[uniScId][i],"'");
        }
        s=StringUtils.concat(s,"]");
        return s;
	}

    /** 
     获取Keys
     */
	function getStockRightApply(string memory uniScId,string memory investorCetfHash) public returns (string memory){
		string memory s = '{';
		string memory lUniScId = stockRightApplys[uniScId][investorCetfHash].uniScId;
        string memory transferorCetfHash = stockRightApplys[uniScId][investorCetfHash].transferorCetfHash;
		string memory lInvestorCetfHash = stockRightApplys[uniScId][investorCetfHash].investorCetfHash;
		string memory investorName = stockRightApplys[uniScId][investorCetfHash].investorName;
		uint price = stockRightApplys[uniScId][investorCetfHash].price;
		address investorAccount = stockRightApplys[uniScId][investorCetfHash].investorAccount;
		string memory stockRightDetail = stockRightApplys[uniScId][investorCetfHash].stockRightDetail;
		bytes32 merkel = stockRightApplys[uniScId][investorCetfHash].merkel;
		uint cptAmt = stockRightApplys[uniScId][investorCetfHash].cptAmt;
		string memory isSuccess = stockRightApplys[uniScId][investorCetfHash].isSuccess;
		string memory status = stockRightApplys[uniScId][investorCetfHash].status;
		s=StringUtils.concat(s,"uniScId:'",lUniScId,"'");
		s=StringUtils.concat(s,"investorCetfHash:'",lInvestorCetfHash,"'");
		s=StringUtils.concat(s,",transferorCetfHash:'",transferorCetfHash,"'");
		s=StringUtils.concat(s,",investorName:'",investorName,"'");
		s=StringUtils.concat(s,",price:'",StringUtils.uint2str(price),"'");
		s=StringUtils.concat(s,",investorAccount:'",StringUtils.address2str(investorAccount),"'");
		s=StringUtils.concat(s,",stockRightDetail:'",stockRightDetail,"'");
		s=StringUtils.concat(s,",merkel:'",StringUtils.bytes32ToString(merkel),"'");
		s=StringUtils.concat(s,",cptAmt:'",StringUtils.uint2str(cptAmt),"'");
		s=StringUtils.concat(s,",isSuccess:'",isSuccess,"'");
		s=StringUtils.concat(s,",status:'",status,"'");
		s=StringUtils.concat(s,"}");
        return s;
	}
}
