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
    
    bool internal _initialized = false;
    
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
    function initialize(address newVersion,address newStorageVersion) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        storageVersion = newStorageVersion;
        require(currentVersion.delegatecall(bytes4(keccak256("initialize(address,address)")),address(this),storageVersion));
        _initialized = true;
    }
    
    /**
     * 合约版本变更
     */
    function changeContract(address newVersion) public onlyCreator{
        currentVersion = newVersion;
        require(currentVersion.delegatecall(bytes4(keccak256("initialize(address,address)")),address(this),storageVersion));
    }
    
    /**
     * 合约存储版本变更
     */
    function changeStorage(address newVersion) public onlyCreator{
        storageVersion = newVersion;
        require(currentVersion.delegatecall(bytes4(keccak256("resetDataStorage(address,address)")),newVersion));
    }
    
    function() public {
        require(currentVersion.delegatecall(msg.data));
    }
    
}
