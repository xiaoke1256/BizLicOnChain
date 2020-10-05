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
     * 管理营业执照的合约版本发生变化
     */
    function changeBizLicContract(address newBizLicContract)public onlyCreator{
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
     * 修改股权(市监局操作)，
     * 股东的新增操作
     * uniScId 统一社会信用码
     * investorName 股东姓名
     * investorAccount 股东账号地址（不知道的话可以为0x0） 
     */
    function modifyStockHolder(string memory uniScId,uint investorNo,string memory investorName,address investorAccount,bytes32 investorCetfHash,
       		string memory stockRightDetail,uint cptAmt
    	) public returns (bool){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("modifyStockHolder(string,uint,string,address,bytes32,string,uint)",uniScId,investorNo,investorName,investorAccount,investorCetfHash,stockRightDetail,cptAmt));
        return (sucess && bytesToBool(result));
    }
    
	/**
     * 增减资(市监局操作)
     * uniScId 统一社会信用码
     * investorNo 股东编号
     * investorCetfHash 股东身份信息（用于核对）
     * stockRightDetail 增减资,肯定会引起股权详情的变化
     * amt 增资额度，可以为负 
     */
    function increCpt(string memory uniScId,uint investorNo,bytes32 investorCetfHash,string memory stockRightDetail,int amt) public returns (bool){
    	require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("increCpt(string,uint,bytes32,string,uint)",uniScId,investorNo,investorCetfHash,stockRightDetail,amt));
        return (sucess && bytesToBool(result));
    }
	
	/**
	 * 取消股权(市监局操作),删除股东
	 */
    function removeStockHolder(string memory uniScId,uint investorNo)public returns (bool){
        require(_initialized);
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("removeStockHolder(string,uint)",uniScId,investorNo));
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
