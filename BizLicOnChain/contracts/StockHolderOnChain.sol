pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { IntUtils } from "./IntUtils.sol";

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
        stockHolders[uniScId][investorNo].merkel=keccak256(abi.encode(investorName,investorAccount,investorCetfHash,bytes(stockRightDetail)));
        stockHolders[uniScId][investorNo].cptAmt=cptAmt;
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
        stockHolders[uniScId][investorNo].merkel=keccak256(abi.encode(investorName,investorAccount,investorCetfHash,bytes(stockRightDetail)));
        stockHolders[uniScId][investorNo].cptAmt=cptAmt;
        return true;
    }
    
    /**
     * 增减资(市监局操作)
     * uniScId 统一社会信用码
     * investorNo 股东编号
     * investorCetfHash 股东身份信息（用于核对）
     * stockRightDetail 增减资有肯定会引起股权详情的变化
     * amt 增资额度，可以为负
     */
    function increCpt(string memory uniScId,uint investorNo,bytes32 investorCetfHash,string memory stockRightDetail,int amt)public onlyAdmin returns (bool){
        return true;
    }
    
    //取消股权(市监局操作),删除股东
    
    //发起转让
    
    //出让方公司的董事会确认转让
    
    //受让方出资
    
    //工商局备案(市监局操作)
    
    //查看现有股东(按uniScId)
    
    //查看交易中的股权

}
