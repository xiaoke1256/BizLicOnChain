pragma solidity ^0.4.25;

import { BizlicOnChain } from "./BizLicOnChain.sol";

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
    function initialize(address newVersion) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        require(currentVersion.call(bytes4(keccak256("initialize()"))));//初始化合约
        require(currentVersion.delegatecall(bytes4(keccak256("initDatas()"))));//初始化业务数据
        _initialized = true;
    }
    
    /**
     * 合约版本变更
     */
    function changeContract(address newVersion) public onlyCreator{
        currentVersion = newVersion;
        require(currentVersion.delegatecall(bytes4(keccak256("initialize()"))));
    }
    
    /**
     * 将老版本数据加载过来
     */
    function reloadData(address oldVersion) public onlyCreator{
        administrators = BizLicOnChainProxy(oldVersion).getAdmins();
        //....
    }
    
     //以下业务函数
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public {
        require(currentVersion.delegatecall(bytes4(keccak256("addAdmin(address)")),admin));
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public{
       require(currentVersion.delegatecall(bytes4(keccak256("removeAdmin(address)")),admin));
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view returns(address[] memory admins){
        return administrators;
    }
    
}
