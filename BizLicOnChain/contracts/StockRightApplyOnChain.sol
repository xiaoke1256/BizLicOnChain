pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";
import { ArrayUtils } from "./ArrayUtils.sol";

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
        require(bytes(transferorCetfHash).length>0);
		//出在让方存这个股东，且账号就是操作人。
		//require(stockHolders[uniScId][transferorCetfHash].investorAccount==tx.origin);
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
    
    //出让方公司的董事会确认转让
    
    //受让方出资
    
    //工商局备案(市监局操作)


}
