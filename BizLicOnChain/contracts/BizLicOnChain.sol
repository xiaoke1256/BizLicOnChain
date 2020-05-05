pragma solidity ^0.4.25;

import { ArrayUtils } from "./ArrayUtils.sol";

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
        administrators.push(creator);
    }
    
    function getOwner() public view returns (address) {
        return owner;
    }
    
    /**
     * 初始化合约
     */
    function initialize(address owner,address dataStorage) public{
        require(creator == tx.origin);
        require(!_initialized);
        this.owner = owner;
        this.dataStorage = dataStorage;
        _initialized = true;
    }
    
    function resetDataStorage(address dataStorage){
        require(creator == tx.origin);
        address oldDataStorgae = this.dataStorage;
        dataStorage.loadData(oldDataStorgae);//从旧版本的存储合约中加载数据。
        this.dataStorage = dataStorage;
    }
    
     modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    /**
     * 仅管理员才可以执行此
     */
    modifier onlyAdmin() {
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		require(ArrayUtils.contains(administrators,tx.origin),"Unauthorized operation!");
		_;
    }
    
    //以下业务函数
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public onlyAdmin onlyOwner{
        if(!ArrayUtils.contains(administrators,admin)){
            administrators.push(admin);
        }
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin onlyOwner{
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       ArrayUtils.remove(administrators,admin);
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view onlyOwner returns(address[] memory admins){
        admins = administrators;
    }
    
}
