pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";
import { ArrayUtils } from "./ArrayUtils.sol";
import { StringUtils } from "./StringUtils.sol";

contract StockRightApplyOnChain is BaseStockRightApplyOnChain {
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
		require(bytes(investorCetfHash).length>0);
        require(bytes(transferorCetfHash).length>0);
		//出在让方存这个股东，且账号就是操作人。
		bool sucess;
        bytes memory result;
		(sucess,result)= stockHolderContract.call(abi.encodeWithSignature("checkStockHoldersAccount(string,string,address)",uniScId,transferorCetfHash,tx.origin));
		require(sucess,'Remote invork fail!');
		require(abi.decode(result,(bool)),'You are not the stock Holder!');
		//把所有的申请案号拿出来取其最大者。
		require(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash),'This investor are in apply flow,please finish the flow then start this flow.');
		stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
		stockRightApplys[uniScId][investorCetfHash].investorName=investorName;
		stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockRightApplys[uniScId][investorCetfHash].merkel=merkel;
		stockRightApplys[uniScId][investorCetfHash].cptAmt=cptAmt;
		stockRightApplys[uniScId][investorCetfHash].price=price;
		stockRightApplys[uniScId][investorCetfHash].status='待董事会确认';
		stockRightApplyKeys[uniScId].push(investorCetfHash);
		return true;
	}

	/**
      设置新股东账号
	  uniScId 统一社会信用码
      investorCetfHash 新股东身份证件信息
      investorAccount 新股东账号
    */
	function setNewStockHolderAccount(string memory uniScId,string memory investorCetfHash,address investorAccount) public returns (bool){
        require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
		//出在让方存这个股东，且账号就是操作人。
		string memory transferorCetfHash = stockRightApplys[uniScId][investorCetfHash].transferorCetfHash;
		//require(stockHolders[uniScId][transferorCetfHash].investorAccount==tx.origin);
		//状态是否正确
        require(StringUtils.equals(stockRightApplys[uniScId][investorCetfHash].status,'待董事会确认'),'This apply at the wrong state.');
		stockRightApplys[uniScId][investorCetfHash].investorAccount=investorAccount;
		return true;
	}
    
    //出让方公司的董事会确认转让
	function comfirmByDirectors(string memory uniScId,string memory investorCetfHash) public returns (bool){
		require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
		//TODO 检查当前账号就是公司的董事会账号
		//状态是否正确
		require(StringUtils.equals(stockRightApplys[uniScId][investorCetfHash].status,'待董事会确认'),'This apply at the wrong state.');
		stockRightApplys[uniScId][investorCetfHash].status='待付款';
		return true;
	}
    
    //受让方出资
	function payForStock(string memory uniScId,string memory investorCetfHash)public payable returns (bool){
		require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
		require(msg.value>0);
		//检查出资额
		require(msg.value>=stockRightApplys[uniScId][investorCetfHash].price);
		stockRightApplys[uniScId][investorCetfHash].price=msg.value;//把实际支付金额放到price中
		stockRightApplys[uniScId][investorCetfHash].status='发证机关备案';
		return true;
	}
	
    
    //工商局备案(市监局操作)


}
