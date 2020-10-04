pragma solidity ^0.6.0;

import { BaseStockHolderOnChain } from "./BaseStockHolderOnChain.sol";
import { BizLicOnChainProxy } from "./BizLicOnChainProxy.sol";

contract StockHolderOnChainProxy is BaseStockHolderOnChain {

    constructor() public{
        creator = msg.sender;
    }
    
    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }
    
    /**
     * 初始化合约
     * newVersion 合约新版本
     * bizLicContract 管理营业执照的合约
     */
    function initialize(address newVersion,address newBizLicContract) public onlyCreator{
        require(!_initialized);
        currentVersion = newVersion;
        bizLicContract = newBizLicContract;
        aicOrganHolder = BizLicOnChainProxy(newBizLicContract).getAicOrganHolder();
        _initialized = true;
    }
    
    /**
     * 版本发生变化
     */
    function changeCurrentVersion(address newVersion)public onlyCreator{
        require(_initialized);
        currentVersion = newVersion;
    }
    
    /**
     * 
     */
    function changeCizLicContract(address newBizLicContract)public onlyCreator{
        require(_initialized);
        bizLicContract = newBizLicContract;
        aicOrganHolder = BizLicOnChainProxy(newBizLicContract).getAicOrganHolder();
    }
    
    /**
     * 设立股权(市监局操作)，
     * 股东的新增操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     * investorAccount 股东账号地址（不知道的话可以为0x0） 
     */
    function addStockHolder(string memory uniScId,string memory investorName,address investorAccount,bytes32 investorCetfHash,
       		string memory stockRightDetail,uint cptAmt
    	) public returns (bool){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("addStockHolder(string,string,address,bytes32,string,uint)",uniScId,investorName,investorAccount,investorCetfHash,stockRightDetail,cptAmt));
        return (sucess && bytesToBool(result));
    }
    
    
     /**
     * 把字节数组转成布尔型
     */
    function bytesToBool(bytes memory b) private pure returns(bool){
        return bytesToUint(b)!=0;
    }
    
    /**
     * 把字节数组转成整数
     */
    function bytesToUint(bytes memory b) private pure returns (uint8){
	    uint8 number = 0;
	    for(uint64 i= 0; i<b.length; i++){
	        number = uint8(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
	    }
	    return number;
	}

}
