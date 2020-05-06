pragma solidity ^0.4.25;

import { ArrayUtils } from "./ArrayUtils.sol";

import { BizLicOnChainStorage } from "./BizLicOnChainStorage.sol";

contract BizlicOnChain {
    /**
     * 创建者
     */
    address creator;
    
    /**
     * 合约存储地址
     */
    address dataStorage;
    
    /**
     * 只允许用该地址来调用
     */
    address owner;
    
    bool internal _initialized = false;

    constructor() public{
        creator = tx.origin;
    }
    
    /**
     * 供存储合约调用检查
     */
    function checkOwner(address toCheck) public view {
        require(toCheck != address(0x0));
        require(toCheck == owner);
    }
    
    /**
     * 初始化合约
     */
    function initialize(address intOwner,address initDataStorage) public{
        require(creator == tx.origin);
        require(!_initialized);
        owner = intOwner;
        dataStorage = initDataStorage;
        require(dataStorage.delegatecall(bytes4(keccak256("pushAdmin(address)")),creator));
        _initialized = true;
    }
    
    function resetDataStorage(address newDataStorage) public {
        require(creator == tx.origin);
        address oldDataStorgae = dataStorage;
        if(oldDataStorgae != address(0x0)){
            require(newDataStorage.delegatecall(bytes4(keccak256("loadData(address)")),oldDataStorgae));//从旧版本的存储合约中加载数据。
        }
        dataStorage = newDataStorage;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    /**
     * 仅管理员才可以执行此
     */
    modifier onlyAdmin() {
        address[] memory administrators = BizLicOnChainStorage(dataStorage).getAdmins();
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		require(ArrayUtils.contains(administrators,tx.origin),"Unauthorized operation!");
		_;
    }
    
    //以下业务函数
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public onlyAdmin onlyOwner{
        address[] memory administrators = BizLicOnChainStorage(dataStorage).getAdmins();
        if(!ArrayUtils.contains(administrators,admin)){
            require(dataStorage.delegatecall(bytes4(keccak256("pushAdmin(address)")),admin));
        }
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin onlyOwner{
       address[] memory administrators = BizLicOnChainStorage(dataStorage).getAdmins();
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       require(dataStorage.delegatecall(bytes4(keccak256("removeAdmin(address)")),admin));
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view onlyOwner returns(address[] memory admins){
        admins = BizLicOnChainStorage(dataStorage).getAdmins();
    }
    
}
