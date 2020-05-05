pragma solidity ^0.4.25;

/**
 * 合约的存储模块。
 */
contract BizLicOnChainStorage {
    address creator;
    
    /**就是Owner的Owner */
    address superOwner;
    bool internal _initialized = false;
    
    /*
     * 管理员
     */
    address[] administrators;

    constructor() public{
        creator = tx.origin;
    }
    
    function initialize(address superOwner) public{
        require(creator == tx.origin);
        require(!_initialized);
        this.superOwner = superOwner;
        _initialized = true;
    }
    
    
    /**
     * 从老版本中加载数据
     */
    function loadData(address oldVersion) public {
        
    }
}
