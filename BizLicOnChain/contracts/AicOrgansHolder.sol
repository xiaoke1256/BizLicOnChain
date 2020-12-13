pragma solidity ^0.6.0;

import { ArrayUtils } from "./ArrayUtils.sol";
import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

contract AicOrgansHolder is BaseAicOrgansHolder {
    
    constructor() public{
        creator = msg.sender;
    }

     /**
     * 初始化合约(用delegatecall来调用)
     */
    function initialize() external {
        require(creator == tx.origin);
        administrators.push(tx.origin);
    }
    
	/**
	 * 将老版本数据加载过来
	 */
	function reloadData(address oldVersion) public {
	    //.....
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
    function addAdmin(address admin) public onlyAdmin returns (bool) {
        if(!ArrayUtils.contains(administrators,admin)){
            administrators.push(admin);
        }
        return true;
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin returns (bool) {
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       ArrayUtils.remove(administrators,admin);
       return true;
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
    function regestOrgan(string memory organCode,string memory organName,address publicKey) public onlyAdmin returns (bool) {
        //检查名称有没有，code有没有
        require(bytes(organCode).length>0);
        require(bytes(organName).length>0);
        aicOrgans[organCode].organCode = organCode;
        aicOrgans[organCode].organName = organName;
        aicOrgans[organCode].publicKey = publicKey;
        aicOrgans[organCode].isUsed = true;
        
        aicOrganCodes.push(organCode);
        return true;
    }
    
    /**
     * 删除一个发证机关
     */
    function removeOrgan(string memory organCode) public onlyAdmin returns (bool) {
        require(bytes(organCode).length>0);
        delete aicOrgans[organCode];
        ArrayUtils.remove(aicOrganCodes,organCode);
        return true;
    }

}
