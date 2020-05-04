pragma solidity ^0.4.25;

/**
 * 合约代理
 */
contract BizLicOnChainProxy {
    address owner;
    
     /*
     * 管理员
     */
    address[] administrators;
    
    /**
     * 真正的合约地址
     */
    address public currentVersion;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
	
	/**
	 * 创建合约
	 */
    constructor(address initAddr) public{
        owner = msg.sender;
        currentVersion = initAddr;
    }
    
    /**
     * 合约版本变更
     */
    function changeContract(address newVersion) public onlyOwner{
        currentVersion = newVersion;
    }
    
    function() public {
        require(currentVersion.delegatecall(msg.data));
    }
    
}
