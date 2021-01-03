pragma solidity ^0.6.0;

import { ArrayUtils } from "./ArrayUtils.sol";

import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";

contract StockRightApplyOnChainStorage is BaseStockRightApplyOnChain {
	 /**代理合约的地址*/
    address proxy;
    /**逻辑合约的地址*/
    address logic;
    
    /**
	 * 创建合约
	 */
    constructor() public{
        creator = msg.sender;
    }
    
    /**
           仅创建本合约的地址才可以调用
     */
    modifier onlyCreator() {
       require(tx.origin == creator,'Only creator can use this function.');
       _;
    }
    
    /**
            设置代理合约的地址
    */
    function setProxy(address proxyAddress) public onlyCreator returns(bool){
    	proxy = proxyAddress;
    }
    
    /**
            设置逻辑合约的地址
    */
    function setLogic(address logicAddress) public onlyCreator returns(bool){
    	logic = logicAddress;
    }
    
    /**
           是否已完成初始化？
    */
    modifier isInitialized() {
    	require(proxy != address(0),'proxy contract\'s adress must be set.');
    	require(logic != address(0),'logic contract\'s adress must be set.');
    	_;
    }
    
    /**
     	只允许逻辑合约来调用
     */
    modifier onlyLogic() {
    	require(logic == msg.sender,'only logic contract can invoke this function.');
    	_;
    }
    
    /**
     	只允许逻辑合约或代理来调用
     */
    modifier onlyLogicOrProxy() {
    	require(logic == msg.sender || proxy == msg.sender ,'only logic contract can invoke this function.');
    	_;
    }
    
    /**
     * 新增或修改一个申请案
     */
    function putStockRightApply(string memory uniScId,string memory transferorCetfHash,string memory investorName,uint price,address payable investorAccount,
    		string memory investorCetfHash,string memory stockRightDetail,bytes32 merkel,uint cptAmt,string memory isSuccess,
    		string memory status,string memory failReason) public onlyLogic returns (bool) {
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
		stockRightApplys[uniScId][investorCetfHash].transferorCetfHash=transferorCetfHash;
		stockRightApplys[uniScId][investorCetfHash].investorName=investorName;
		stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
		stockRightApplys[uniScId][investorCetfHash].merkel=merkel;
		stockRightApplys[uniScId][investorCetfHash].cptAmt=cptAmt;
		stockRightApplys[uniScId][investorCetfHash].price=price;
		stockRightApplys[uniScId][investorCetfHash].status=status;
		stockRightApplys[uniScId][investorCetfHash].investorAccount=investorAccount;
		stockRightApplys[uniScId][investorCetfHash].stockRightDetail=stockRightDetail;
		stockRightApplys[uniScId][investorCetfHash].isSuccess=isSuccess;
		stockRightApplys[uniScId][investorCetfHash].failReason=failReason;
		if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
		return true;
    }
    
    /**
     * 删除一个申请案
     */
     function removeStockRightApply(string memory uniScId,string memory investorCetfHash) public onlyLogic returns (bool){
     	delete stockRightApplys[uniScId][investorCetfHash];
     	ArrayUtils.remove(stockRightApplyKeys[uniScId],investorCetfHash);
     	return true;
     }
     
    //set
    function setTransferorCetfHash(string memory uniScId,string memory investorCetfHash,string memory transferorCetfHash) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].transferorCetfHash=transferorCetfHash;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setInvestorName(string memory uniScId,string memory investorCetfHash,string memory investorName) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].investorName=investorName;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setMerkel(string memory uniScId,string memory investorCetfHash,bytes32 merkel) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].merkel=merkel;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setCptAmt(string memory uniScId,string memory investorCetfHash,uint cptAmt) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].cptAmt=cptAmt;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setPrice(string memory uniScId,string memory investorCetfHash,uint price) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].price=price;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setStatus(string memory uniScId,string memory investorCetfHash,string memory status) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].status=status;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setInvestorAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].investorAccount=investorAccount;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setStockRightDetail(string memory uniScId,string memory investorCetfHash,string memory stockRightDetail) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].stockRightDetail=stockRightDetail;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setIsSuccess(string memory uniScId,string memory investorCetfHash,string memory isSuccess) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].isSuccess=isSuccess;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    function setFailReason(string memory uniScId,string memory investorCetfHash,string memory failReason) public onlyLogic returns (bool){
    	stockRightApplys[uniScId][investorCetfHash].uniScId=uniScId;
    	stockRightApplys[uniScId][investorCetfHash].investorCetfHash=investorCetfHash;
    	stockRightApplys[uniScId][investorCetfHash].failReason=failReason;
    	if(!ArrayUtils.contains(stockRightApplyKeys[uniScId],investorCetfHash)){
			stockRightApplyKeys[uniScId].push(investorCetfHash);
		}
    	return true;
    }
    
    //get
}