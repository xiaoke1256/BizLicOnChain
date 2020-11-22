pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { IntUtils } from "./IntUtils.sol";
import { ArrayUtils } from "./ArrayUtils.sol";
import { StringUtils } from "./StringUtils.sol";

contract StockHolderOnChain is BaseStockHolderOnChain {
    constructor() public{
        creator = msg.sender;
    }
    
    /**
     * 仅（市监局）管理员才可以执行
     */
    modifier onlyAdmin() {
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		require(AicOrgansHolderProxy(aicOrganHolder).isAdmin(tx.origin),"Unauthorized operation!");
		_;
    }

	 /**
     * 设立股权(市监局操作)，
     * 股东的新增或修改操作
     * uniScId 统一社会信用码
     * investorCetfHash 股东身份证件号的Hash
     * investorName 股东姓名
     * stockRightDetail 出资详情
     * cptAmt 出资额（人民币元）
     */
    function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName,string memory stockRightDetail,uint cptAmt) public onlyAdmin returns (bool){
    	require(bytes(uniScId).length>0);
    	require(bytes(investorName).length>0);
    	require(bytes(investorCetfHash).length>0);
		//require(bytes(stockRightDetail).length>0);
		require(cptAmt>0);

		if(!ArrayUtils.contains(stockHoldersKeys[uniScId],investorCetfHash)){
			stockHoldersKeys[uniScId].push(investorCetfHash);
		}
        stockHolders[uniScId][investorCetfHash].uniScId=uniScId;
        stockHolders[uniScId][investorCetfHash].investorName=investorName;
        stockHolders[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockHolders[uniScId][investorCetfHash].stockRightDetail=stockRightDetail;
		stockHolders[uniScId][investorCetfHash].cptAmt=cptAmt;
		if(uint160(stockHolders[uniScId][investorCetfHash].investorAccount)>0){
			stockHolders[uniScId][investorCetfHash].merkel=keccak256(abi.encode(investorName,stockHolders[uniScId][investorCetfHash].investorAccount,investorCetfHash));
		}

        return true;
    }
    
    /**
     * 设立股权(市监局操作)，
     * 股东的新增或修改操作
     * uniScId 统一社会信用码
     * investorCetfHash 股东身份证件号的Hash
     * investorName 股东姓名
     * investorAccount 股东交易账号，
     * stockRightDetail 出资详情
     * cptAmt 出资额（人民币元）
     */
    function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName,address payable investorAccount,string memory stockRightDetail,uint cptAmt) public onlyAdmin returns (bool){
		require(uint160(investorAccount)>0);

		if(!ArrayUtils.contains(stockHoldersKeys[uniScId],investorCetfHash)){
			stockHoldersKeys[uniScId].push(investorCetfHash);
		}
		stockHolders[uniScId][investorCetfHash].investorAccount=investorAccount;
        return putStockHolder(uniScId,investorCetfHash,investorName,stockRightDetail,cptAmt);
    }

	/**
     * 修改股东的股权交易地址
     */
	function putStockHolderAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public onlyAdmin returns (bool){
		require(bytes(uniScId).length>0);
		require(bytes(investorCetfHash).length>0);
		require(uint160(investorAccount)>0);

		if(!ArrayUtils.contains(stockHoldersKeys[uniScId],investorCetfHash)){
			stockHoldersKeys[uniScId].push(investorCetfHash);
		}
		stockHolders[uniScId][investorCetfHash].uniScId=uniScId;
		stockHolders[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockHolders[uniScId][investorCetfHash].investorAccount = investorAccount;
		if(bytes(stockHolders[uniScId][investorCetfHash].investorName).length>0){
			stockHolders[uniScId][investorCetfHash].merkel=keccak256(abi.encode(stockHolders[uniScId][investorCetfHash].investorName,investorAccount,investorCetfHash));
		}
		return true;
	}
	
    
    /**
     * 增减资(市监局操作)
     * uniScId 统一社会信用码
     * investorNo 股东编号
     * investorCetfHash 股东身份信息（用于核对）
     * stockRightDetail 增减资,肯定会引起股权详情的变化
     * amt 增资额度，可以为负
     */
    function increCpt(string memory uniScId,string memory investorCetfHash,string memory stockRightDetail,int amt)public onlyAdmin returns (bool){
        require(bytes(uniScId).length>0,'uniScId can not be empty.');
    	require(bytes(investorCetfHash).length>0,'investorCetfHash can not be empty.');
    	//require(bytes(stockRightDetail).length>0,'stockRightDetail can not be empty.');
    	require(amt!=0);
        
        //要求stockHolders中这条记录已经存在。
        require(bytes(stockHolders[uniScId][investorCetfHash].investorCetfHash).length>0,'The investor does not exist.');
        //余额必须大于0
        require(int(stockHolders[uniScId][investorCetfHash].cptAmt)+amt>=0,'The balance is not enough!');
        if(int(stockHolders[uniScId][investorCetfHash].cptAmt)+amt==0){
            //取消股权
            return removeStockHolder(uniScId,investorCetfHash);
        }
        
        stockHolders[uniScId][investorCetfHash].cptAmt=uint(int(stockHolders[uniScId][investorCetfHash].cptAmt)+amt);
        if(bytes(stockRightDetail).length>0)
        	stockHolders[uniScId][investorCetfHash].stockRightDetail=stockRightDetail;
        //TODO 投资金额变化肯定会造成整个企业的注册资金变化。
        
        return true;
    }
    
    /**
	 * 取消股权(市监局操作),删除股东
	 */
    function removeStockHolder(string memory uniScId,string memory investorCetfHash)public onlyAdmin returns (bool){
        require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
        //要求stockHolders中这条记录已经存在。
        require(bytes(stockHolders[uniScId][investorCetfHash].investorCetfHash).length>0);
        delete stockHolders[uniScId][investorCetfHash];
		ArrayUtils.remove(stockHoldersKeys[uniScId],investorCetfHash);
		//TODO 投资金额变化肯定会造成整个企业的注册资金变化。
		return true;
    }
	
	/**
	 * 查看现有股东(按uniScId)
	 */
	function getStockHolders(string memory uniScId) public view returns (string memory){
		require(bytes(uniScId).length>0);
		string[] memory investorCetfHashs = stockHoldersKeys[uniScId];
		//拼成json
		string memory s = '';
		s=StringUtils.concat(s,'[');
		for(uint i=0;i<investorCetfHashs.length;i++){
		     if(i>0){
                s=StringUtils.concat(s,",");
            }
			string memory investorCetfHash = investorCetfHashs[i];
			s=StringUtils.concat(s,'{');
			s=StringUtils.concat(s,'"uniScId":"',stockHolders[uniScId][investorCetfHash].uniScId,'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorName":"',stockHolders[uniScId][investorCetfHash].investorName,'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorAccount":"',StringUtils.address2str(stockHolders[uniScId][investorCetfHash].investorAccount),'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorCetfHash":"',stockHolders[uniScId][investorCetfHash].investorCetfHash,'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"stockRightDetail":',stockHolders[uniScId][investorCetfHash].stockRightDetail,'');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"merkel":"',StringUtils.bytes32ToString(stockHolders[uniScId][investorCetfHash].merkel),'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"cptAmt":',StringUtils.uint2str(stockHolders[uniScId][investorCetfHash].cptAmt),'');
			s=StringUtils.concat(s,'}');
		}
		s=StringUtils.concat(s,']');
		return s;
	}
	
    /**
	 * 查看现有股东的出资
	 */
	function getStockHolderCptAmt(string memory uniScId,string memory investorCetfHash) public view returns (uint){
		return stockHolders[uniScId][investorCetfHash].cptAmt;
	}
    
	/**
     * 检查股东的账号
	 */
    function checkStockHoldersAccount(string memory uniScId,string memory investorCetfHash,address account)public returns(bool) {
		return stockHolders[uniScId][investorCetfHash].investorAccount == account;
	}
	
	/**
	 * 获取股东账号 
	 */
	function getStockHoldersAccount(string memory uniScId,string memory investorCetfHash)public view returns(address) {
		return stockHolders[uniScId][investorCetfHash].investorAccount ;
	}
}
