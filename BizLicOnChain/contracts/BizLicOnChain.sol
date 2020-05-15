pragma solidity ^0.4.25;

import { ArrayUtils } from "./ArrayUtils.sol";

contract BizLicOnChain {
    /**
     * 创建者
     */
    address creator;
    
    address[] administrators;
    
    /**
     * 工商局
     */
    struct AicOrgan{
        string organName;//机关名称
        string organCode;//机关代码
        bytes publicKey;//公钥
    }
    
    /**
     * 所有工商机关
     */
    mapping(string => AicOrgan) aicOrgans;

    constructor() public{
        creator = tx.origin;
    }

    /**
     * 初始化合约(用delegatecall来调用)
     */
    function initialize() external {
        require(creator == tx.origin);
        administrators.push(tx.origin);
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
    function addAdmin(address admin) public onlyAdmin  {
        if(!ArrayUtils.contains(administrators,admin)){
            administrators.push(admin);
        }
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin {
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       ArrayUtils.remove(administrators,admin);
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view returns(address[] memory){
        return administrators;
    }
    
        
    /**
     * 注册一个发证机关
     */
    function regestOrgan(string organCode,string organName,bytes publicKey) public onlyAdmin {
        //检查名称有没有，code有没有
        aicOrgans[organCode] = AicOrgan(organCode,organName,publicKey);
    }
    
    /**
     * 获取所有发证机关
     */
    function getOrgan(string organCode) public view onlyAdmin returns(string memoery)  {
        AicOrgan organ = aicOrgans[organCode];
        return organ.organName;
    }
    
}
