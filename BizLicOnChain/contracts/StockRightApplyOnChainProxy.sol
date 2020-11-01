pragma solidity ^0.6.0;

import { StockHolderOnChainProxy } from "./StockHolderOnChainProxy.sol";
import { BaseStockRightApplyOnChain } from "./BaseStockRightApplyOnChain.sol";

import { StringUtils } from "./StringUtils.sol";


contract StockRightApplyOnChainProxy is BaseStockRightApplyOnChain {
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
    function initialize(address newVersion,address newStockHolderContract) public onlyCreator returns (bool){
        require(!_initialized,"The contract has inited!");
        currentVersion = newVersion;
        stockHolderContract = newStockHolderContract;
        aicOrganHolder = StockHolderOnChainProxy(stockHolderContract).getAicOrganHolder();
        _initialized = true;
		return true;
    }
    
	/**
	 *发起股权转让
	 * uniScId 统一社会信用码
	 * transferorCetfHash 出让方股东身份证件信息
	 * investorName 受让方股东姓名
	 * investorCetfHash 受让方股东身份证件信息
	 * merkel 默克尔值
	 * cptAmt 转让份额（元）
	 * price 转让价格（以太币，wei）
	 * 返回是否成功
	 */
	function startStockTransfer(string memory uniScId,string memory transferorCetfHash,string memory investorName,
			string memory investorCetfHash,bytes32 merkel,uint cptAmt,uint price)public returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= currentVersion.delegatecall(abi.encodeWithSignature("startStockTransfer(string,string,string,string,bytes32,uint256,uint256)",uniScId,
			transferorCetfHash,investorName,investorCetfHash,merkel,cptAmt,price));
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
	
	function isInited() public view returns(bool){
	    return _initialized;
	}

	/** 
     获取Keys
     */
	function getStockRightApplyKeysBy(string memory uniScId) public returns (string memory){
		string memory s = '[';
        for(uint64 i = 0;i<stockRightApplyKeys[uniScId].length;i++){
            if(i>0){
                s=StringUtils.concat(s,",");
            }
            s=StringUtils.concat(s,"'",stockRightApplyKeys[uniScId][i],"'");
        }
        s=StringUtils.concat(s,"]");
        return s;
	}
}
