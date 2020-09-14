pragma solidity ^0.6.0;

contract StockHolderOnChainProxy {
    address creator;

    constructor() public{
        creator = msg.sender;
    }

}
