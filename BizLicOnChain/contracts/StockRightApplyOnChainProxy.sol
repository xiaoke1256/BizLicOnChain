pragma solidity ^0.6.0;

import { StockHolderOnChainProxy } from "./StockHolderOnChainProxy.sol";
import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";


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
    function initialize(address newVersion,address newStockHolderContract) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        stockHolderContract = newStockHolderContract;
        aicOrganHolder = StockHolderOnChainProxy(stockHolderContract).getAicOrganHolder();
        _initialized = true;
    }
    

}
