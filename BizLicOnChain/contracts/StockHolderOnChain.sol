pragma solidity ^0.6.0;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";

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
    
    //设立股权(市监局操作)
    
    //增减资(市监局操作)
    
    //取消股权(市监局操作)
    
    //发起转让
    
    //出让方公司的董事会确认转让
    
    //受让方出资
    
    //工商局备案(市监局操作)

}
