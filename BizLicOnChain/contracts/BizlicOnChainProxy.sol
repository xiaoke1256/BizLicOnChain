pragma solidity ^0.4.25;

/**
 * 合约代理
 */
contract BizLicOnChainProxy {
    
    address creator;
    
     /*
     * 管理员
     */
    address[] administrators;
    
    /**
     * 逻辑合约地址
     */
    address public currentVersion;
    
    /**
     * 存储合约地址
     */
    address public storageVersion;
    
    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }
	
	/**
	 * 创建合约
	 */
    constructor() public{
        creator = msg.sender;
    }
    
    /**
     * 初始化合约
     */
    function initialize(address newVersion) public{
        currentVersion = newVersion;
    }
    
    /**
     * 合约版本变更
     */
    function changeContract(address newVersion) public onlyCreator{
        currentVersion = newVersion;
        currentVersion.delegatecall(bytes4(keccak256("initialize(address,address)")),address(this),storageVersion);
    }
    
    function() public {
        require(currentVersion.delegatecall(msg.data));
    }
    
}
