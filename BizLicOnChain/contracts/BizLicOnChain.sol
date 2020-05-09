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
    
    address[] administrators;

    constructor() public{
        creator = tx.origin;
    }

    /**
     * 初始化合约(用call来调用)
     */
    function initialize() external {
        require(creator == tx.origin);
        owner = msg.sender;
    }
    
    /**
     * 初始化业务数据(用delegatecall来调用)
     */
    function initDatas() external {
        require(creator == tx.origin);
        administrators.push(tx.origin);
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
        admins administrators
    }
    
}
