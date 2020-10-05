pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { IntUtils } from "./IntUtils.sol";
import { StringUtils } from "./StringUtils.sol";
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
		require(AicOrgansHolderProxy(aicOrganHolder).isAdmin(tx.origin),"Unauthorized operation!");
		_;
    }
    
    /**
     * 设立股权(市监局操作)，
     * 股东的新增操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     * investorAccount 股东账号地址（不知道的话可以为0x0） 
     */
    function addStockHolder(string memory uniScId,string memory investorName,address investorAccount,bytes32 investorCetfHash,
       		string memory stockRightDetail,uint cptAmt
    	) public onlyAdmin returns (bool){
    	require(bytes(uniScId).length>0);
    	require(bytes(investorName).length>0);
    	require(investorCetfHash.length>0);
    	require(bytes(stockRightDetail).length>0);
    	require(cptAmt>0);
    	
        uint[] memory investorNos = stockHoldersNos[uniScId];
        uint investorNo = IntUtils.max(investorNos)+1;
        stockHoldersNos[uniScId].push(investorNo);
        stockHolders[uniScId][investorNo].uniScId=uniScId;
        stockHolders[uniScId][investorNo].investorNo=investorNo;
        stockHolders[uniScId][investorNo].investorName=investorName;
        stockHolders[uniScId][investorNo].investorAccount=investorAccount;
        stockHolders[uniScId][investorNo].investorCetfHash=investorCetfHash;
        stockHolders[uniScId][investorNo].stockRightDetail=stockRightDetail;
        stockHolders[uniScId][investorNo].merkel=keccak256(abi.encode(investorName,investorAccount,investorCetfHash));
        stockHolders[uniScId][investorNo].cptAmt=cptAmt;
        //TODO 投资金额变化肯定会造成整个企业的注册资金变化。
        return true;
    }
    
    /**
     * 修改股权(市监局操作)，
     * 股东的修改操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     * investorAccount 股东账号地址（不知道的话可以为0x0） 
     */
    function modifyStockHolder(string memory uniScId,uint investorNo,string memory investorName,address investorAccount,bytes32 investorCetfHash,
       		string memory stockRightDetail,uint cptAmt
    	) public onlyAdmin returns (bool){
    	require(bytes(uniScId).length>0);
    	require(investorNo>0);
    	require(bytes(investorName).length>0);
    	require(investorCetfHash.length>0);
    	require(bytes(stockRightDetail).length>0);
    	require(cptAmt>0);
    	//要求stockHolders中这条记录已经存在。
        require(stockHolders[uniScId][investorNo].investorNo>0);
        
        stockHolders[uniScId][investorNo].uniScId=uniScId;
        stockHolders[uniScId][investorNo].investorNo=investorNo;
        stockHolders[uniScId][investorNo].investorName=investorName;
        stockHolders[uniScId][investorNo].investorAccount=investorAccount;
        stockHolders[uniScId][investorNo].investorCetfHash=investorCetfHash;
        stockHolders[uniScId][investorNo].stockRightDetail=stockRightDetail;
        stockHolders[uniScId][investorNo].merkel=keccak256(abi.encode(investorName,investorAccount,investorCetfHash));
        stockHolders[uniScId][investorNo].cptAmt=cptAmt;
        //TODO 投资金额变化肯定会造成整个企业的注册资金变化。
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
    function increCpt(string memory uniScId,uint investorNo,bytes32 investorCetfHash,string memory stockRightDetail,int amt)public onlyAdmin returns (bool){
        require(bytes(uniScId).length>0);
        require(investorNo>0);
    	require(investorCetfHash.length>0);
    	require(bytes(stockRightDetail).length>0);
    	require(amt!=0);
        
        //核对身份
        require(stockHolders[uniScId][investorNo].investorCetfHash==investorCetfHash);
        //要求stockHolders中这条记录已经存在。
        require(stockHolders[uniScId][investorNo].investorNo>0);
        //余额必须大于0
        require(int(stockHolders[uniScId][investorNo].cptAmt)+amt>=0);
        if(int(stockHolders[uniScId][investorNo].cptAmt)+amt==0){
            //取消股权
            return removeStockHolder(uniScId,investorNo);
        }
        
        stockHolders[uniScId][investorNo].cptAmt=uint(int(stockHolders[uniScId][investorNo].cptAmt)+amt);
        stockHolders[uniScId][investorNo].stockRightDetail=stockRightDetail;
        //TODO 投资金额变化肯定会造成整个企业的注册资金变化。
        
        return true;
    }
    
    /**
	 * 取消股权(市监局操作),删除股东
	 */
    function removeStockHolder(string memory uniScId,uint investorNo)public onlyAdmin returns (bool){
        require(bytes(uniScId).length>0);
        require(investorNo>0);
        //要求stockHolders中这条记录已经存在。
        require(stockHolders[uniScId][investorNo].investorNo>0);
        delete stockHolders[uniScId][investorNo];
		ArrayUtils.remove(stockHoldersNos[uniScId],investorNo);
		//TODO 投资金额变化肯定会造成整个企业的注册资金变化。
		return true;
    }
    
    /**
	 *发起股权转让
	 * uniScId 统一社会信用码
	 * transferorInvestorNo 出让方股东编号
	 * investorName 受让方股东姓名
	 * investorAccount 受让方股东账号
	 * merkel 默克尔值
	 * cptAmt 转让份额（元）
	 * price 转让价格（以太币，wei）
	 * 返回申请号
	 */
	function startStockTransfer(string memory uniScId,uint transferorInvestorNo,string memory investorName,
			address investorAccount,bytes32 merkel,uint cptAmt,uint price)public returns (uint){
		require(bytes(uniScId).length>0);
        require(transferorInvestorNo>0);
		//出在让方存这个股东，且账号就是操作人。
		require(stockHolders[uniScId][transferorInvestorNo].investorAccount==tx.origin);
		//把所有的申请案号拿出来取其最大者。
		uint[] memory applyNos = stockRightApplyNos[uniScId];
		uint appNo = IntUtils.max(applyNos)+1;
		stockRightApplys[uniScId][appNo].uniScId=uniScId;
		stockRightApplys[uniScId][appNo].appNo=appNo;
		stockRightApplys[uniScId][appNo].transferorInvestorNo=transferorInvestorNo;
		stockRightApplys[uniScId][appNo].investorName=investorName;
		stockRightApplys[uniScId][appNo].investorAccount=investorAccount;
		stockRightApplys[uniScId][appNo].merkel=merkel;
		stockRightApplys[uniScId][appNo].cptAmt=cptAmt;
		stockRightApplys[uniScId][appNo].price=price;
		stockRightApplys[uniScId][appNo].status='待董事会确认';
		return appNo;
	}
    
    //出让方公司的董事会确认转让
    
    //受让方出资
    
    //工商局备案(市监局操作)
    
    /**
	 * 查看现有股东(按uniScId)
	 */
	function getStockHolders(string memory uniScId) public view returns (string memory){
		require(bytes(uniScId).length>0);
		uint[] memory investorNos = stockHoldersNos[uniScId];
		//拼成json
		string memory s = '';
		s=StringUtils.concat(s,'[');
		for(uint i=0;i<investorNos.length;i++){
		     if(i>0){
                s=StringUtils.concat(s,",");
            }
			uint investorNo = investorNos[i];
			s=StringUtils.concat(s,'{');
			s=StringUtils.concat(s,'"uniScId":"',stockHolders[uniScId][investorNo].uniScId,'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorNo":',StringUtils.uint2str(stockHolders[uniScId][investorNo].investorNo),'');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorName":"',stockHolders[uniScId][investorNo].investorName,'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorAccount":"',StringUtils.address2str(stockHolders[uniScId][investorNo].investorAccount),'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"investorCetfHash":"',StringUtils.bytes32ToString(stockHolders[uniScId][investorNo].investorCetfHash),'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"stockRightDetail":',stockHolders[uniScId][investorNo].stockRightDetail,'');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"merkel":"',StringUtils.bytes32ToString(stockHolders[uniScId][investorNo].merkel),'"');
			s=StringUtils.concat(s,',');
			s=StringUtils.concat(s,'"cptAmt":',StringUtils.uint2str(stockHolders[uniScId][investorNo].cptAmt),'');
			s=StringUtils.concat(s,'}');
		}
		s=StringUtils.concat(s,']');
		return s;
	}
    
    //查看交易中的股权（申请案）

}
