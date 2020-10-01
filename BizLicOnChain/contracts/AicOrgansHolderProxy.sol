pragma solidity ^0.6.0;

import { BaseAicOrgansHolder } from "./BaseAicOrgansHolder.sol";

contract AicOrgansHolderProxy is BaseAicOrgansHolder {
    
    constructor() public{
        creator = msg.sender;
    }

    // TODO Add functions


}
