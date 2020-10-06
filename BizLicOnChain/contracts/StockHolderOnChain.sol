pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { IntUtils } from "./IntUtils.sol";
import { ArrayUtils } from "./ArrayUtils.sol";

contract StockHolderOnChain is BaseStockHolderOnChain {
    constructor() public{
        creator = msg.sender;
    }
    
    /**
     * 仅（市监局）管理员才可以执行
     */
    modifier onlyAdmin() {
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		//require(AicOrgansHolderProxy(aicOrganHolder).isAdmin(tx.origin),"Unauthorized operation!");
		_;
    }
    
    /**
     * 设立股权(市监局操作)，
     * 股东的新增或修改操作
     * uniScId 统一社会信用码
     * investorCetfHash 股东身份证件号的Hash
     * investorName 股东姓名
     */
    function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName) public onlyAdmin returns (bool){
    	require(bytes(uniScId).length>0);
    	require(bytes(investorName).length>0);
    	require(bytes(investorCetfHash).length>0);

		if(!ArrayUtils.contains(stockHoldersKeys[uniScId],investorCetfHash)){
			stockHoldersKeys[uniScId].push(investorCetfHash);
		}
        stockHolders[uniScId][investorCetfHash].uniScId=uniScId;
        stockHolders[uniScId][investorCetfHash].investorName=investorName;
        stockHolders[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		if(uint160(stockHolders[uniScId][investorCetfHash].investorAccount)>0){
			stockHolders[uniScId][investorCetfHash].merkel=keccak256(abi.encode(investorName,stockHolders[uniScId][investorCetfHash].investorAccount,investorCetfHash));
		}

        return true;
    }

	/**
     * 修改股东的出资信息
	 */
	function putStockHolderCptAmt(string memory uniScId,string memory investorCetfHash,uint cptAmt)public onlyAdmin returns (bool){
		require(bytes(uniScId).length>0);
		require(bytes(investorCetfHash).length>0);
		require(cptAmt>0);
		
		if(!ArrayUtils.contains(stockHoldersKeys[uniScId],investorCetfHash)){
			stockHoldersKeys[uniScId].push(investorCetfHash);
		}
		stockHolders[uniScId][investorCetfHash].uniScId=uniScId;
        stockHolders[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockHolders[uniScId][investorCetfHash].cptAmt=cptAmt;
		//TODO 投资金额变化肯定会造成整个企业的注册资金变化。
		return true;
    }

		/**
     * 修改股东的出资信息
	 */
	function putStockHolderCptDetail(string memory uniScId,string memory investorCetfHash,string memory stockRightDetail)public onlyAdmin returns (bool){
		require(bytes(uniScId).length>0);
		require(bytes(investorCetfHash).length>0);
		require(bytes(stockRightDetail).length>0);
		
		if(!ArrayUtils.contains(stockHoldersKeys[uniScId],investorCetfHash)){
			stockHoldersKeys[uniScId].push(investorCetfHash);
		}
		stockHolders[uniScId][investorCetfHash].uniScId=uniScId;
        stockHolders[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockHolders[uniScId][investorCetfHash].stockRightDetail=stockRightDetail;
		return true;
    }

	/**
     * 修改股东的股权交易地址
     */
	function putStockHolderAccount(string memory uniScId,string memory investorCetfHash,address investorAccount) public onlyAdmin returns (bool){
		require(bytes(uniScId).length>0);
		require(bytes(investorCetfHash).length>0);
		require(uint160(stockHolders[uniScId][investorCetfHash].investorAccount)>0);

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
        require(bytes(uniScId).length>0);
    	require(bytes(investorCetfHash).length>0);
    	require(bytes(stockRightDetail).length>0);
    	require(amt!=0);
        
        //要求stockHolders中这条记录已经存在。
        require(bytes(stockHolders[uniScId][investorCetfHash].investorCetfHash).length>0);
        //余额必须大于0
        require(int(stockHolders[uniScId][investorCetfHash].cptAmt)+amt>=0);
        if(int(stockHolders[uniScId][investorCetfHash].cptAmt)+amt==0){
            //取消股权
            return removeStockHolder(uniScId,investorCetfHash);
        }
        
        stockHolders[uniScId][investorCetfHash].cptAmt=uint(int(stockHolders[uniScId][investorCetfHash].cptAmt)+amt);
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
		require(bytes(uniScId).length>0);
        require(bytes(transferorCetfHash).length>0);
		//出在让方存这个股东，且账号就是操作人。
		require(stockHolders[uniScId][transferorCetfHash].investorAccount==tx.origin);
		//把所有的申请案号拿出来取其最大者。
		require(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash),'This investor are in apply flow,please finish the flow then start this flow.');
		stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
		stockRightApplys[uniScId][investorCetfHash].investorName=investorName;
		stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockRightApplys[uniScId][investorCetfHash].merkel=merkel;
		stockRightApplys[uniScId][investorCetfHash].cptAmt=cptAmt;
		stockRightApplys[uniScId][investorCetfHash].price=price;
		stockRightApplys[uniScId][investorCetfHash].status='待董事会确认';
		return true;
	}
    
    //出让方公司的董事会确认转让
    
    //受让方出资
    
    //工商局备案(市监局操作)
    

}
