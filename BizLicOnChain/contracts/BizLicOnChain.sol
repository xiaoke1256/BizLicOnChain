pragma solidity ^0.5.0;

import { ArrayUtils } from "./ArrayUtils.sol";
import { BaseBizLicOnChain } from "./BaseBizLicOnChain.sol";

contract BizLicOnChain is BaseBizLicOnChain {
    /**
     * 创建者
     */
    address creator;
    
    address[] administrators;
    
    /**
     * 所有工商机关
     */
    mapping(string => AicOrgan) aicOrgans;
    
    /* 用来占位 */
    bool internal _initialized = false;
    
    /**
     * 逻辑合约地址 用来占位
     */
    address currentVersion;

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
    function regestOrgan(string memory organCode,string memory organName,bytes memory publicKey) public onlyAdmin {
        //检查名称有没有，code有没有
        require(bytes(organCode).length>0);
        require(bytes(organName).length>0);
        aicOrgans[organCode].organCode = organCode;
        aicOrgans[organCode].organName = organName;
        aicOrgans[organCode].publicKey = publicKey;
        aicOrgans[organCode].isUserd = true;
    }
    
    /**
     * 删除一个发证机关
     */
    function removeOrgan(string memory organCode) public onlyAdmin {
        require(bytes(organCode).length>0);
        delete aicOrgans[organCode];
    }
    
//    /**
//     * 获取所有发证机关
//     */
//    function getOrgan(string organCode) public view onlyAdmin returns(string memoery)  {
//        AicOrgan memory organ = aicOrgans[organCode];
//        return StringUtils.concat(["{organCode:'",organCode,"',organName:'",organ.organName,"',publicKey:'",string(organ.publicKey),"'}"]);
//    }
    
}
