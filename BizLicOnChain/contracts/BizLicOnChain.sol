pragma solidity ^0.5.0;

contract BizlicOnchain {
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
        for(uint i=0;i< administrators.length;i++){
            if(administrators[i] == msg.sender){
                _;
            } 
        }
    }
    
    /**
     * 添加一个管理员
     */
    function addAdmin(address admin) public onlyAdmin{
        administrators.push(admin);
    }
    
     /**
     * 删除一个管理员
     */
    function removeAdmin(address admin) public onlyAdmin{
        //从 administrators中删除指定的管理员
        
    }
    
    /**
     * 获取所有的管理员
     */
    function getAdmins() public view returns(address[] memory){
        return administrators;
    }
    
}
