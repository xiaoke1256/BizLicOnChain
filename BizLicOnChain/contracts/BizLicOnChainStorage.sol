pragma solidity ^0.4.25;

import { ArrayUtils } from "./ArrayUtils.sol";

/**
 * 合约的存储模块。
 */
contract BizLicOnChainStorage {
    address creator;
    
    /**就是Owner的Owner */
    address superOwner;
    bool internal _initialized = false;
    
    /*
     * 管理员
     */
    address[] administrators;

    constructor() public{
        creator = tx.origin;
    }
    
    modifier onlySuperOwner(){
        require(msg.sender.delegatecall(bytes4(keccak256("checkOwner(address)")),superOwner));
        _;
    }
    
    function initialize(address initSuperOwner) public{
        require(creator == tx.origin);
        require(!_initialized);
        superOwner = initSuperOwner;
        _initialized = true;
    }
    
    
    /**
     * 从老版本中加载数据
     */
    function loadData(address oldVersion) public onlySuperOwner {
        //暂不实现
    }
    
    function pushAdmin(address admin) public onlySuperOwner{
        administrators.push(admin);
    }
    
    function removeAdmin(address admin) public onlySuperOwner{
        ArrayUtils.remove(administrators,admin);
    }
    
    function getAdmins() external view returns(address[] memory){
        return administrators;
    }
}
