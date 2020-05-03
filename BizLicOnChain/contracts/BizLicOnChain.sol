pragma solidity ^0.4.25;

import { ArrayUtils } from "./ArrayUtils.sol";

contract BizlicOnChain {
    address creator;
    /*
     * 管理员
     */
    address[] administrators;

    constructor() public{
        creator = msg.sender;
        administrators.push(creator);
    }
    
    /**
     * 仅管理员才可以执行此
     */
    modifier onlyAdmin() {
		require(ArrayUtils.contains(administrators,msg.sender),"Unauthorized operation!");
		_;
    }
    
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public onlyAdmin{
        if(!ArrayUtils.contains(administrators,admin)){
            administrators.push(admin);
        }
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin{
       // 从 administrators中删除指定的管理员
       require(administrators.length>1,"At least one administrator exist in this System!");
       ArrayUtils.remove(administrators,admin);
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view returns(address[] memory admins){
        admins = administrators;
    }
    
}
