pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";
import { IntUtils } from "./IntUtils.sol";
import { ArrayUtils } from "./ArrayUtils.sol";
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
    function initialize(address newVersion,address newBizLicContract) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        bizLicContract = newBizLicContract;
        aicOrganHolder = BizLicOnChainProxy(newBizLicContract).getAicOrganHolder();
        _initialized = true;
    }
    

}
