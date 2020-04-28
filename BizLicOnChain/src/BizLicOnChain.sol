pragma solidity ^0.4.25;

contract Bizliconchain {
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
    modifier onlyAdmin(){
        for(uint i=0;i< administrators.length;i++){
            if(administrators == msg.sender){
                return;
            } 
        }
        require(false);
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
    
   


    // TODO Add functions
    function kill() public {
        if (msg.sender == creator) {
            selfdestruct(creator);
        }
    }
}
