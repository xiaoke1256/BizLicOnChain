pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { StockHolderOnChainProxy } from "./StockHolderOnChainProxy.sol";

import { StockRightApplyOnChainStorage } from "./StockRightApplyOnChainStorage.sol";

import { StringUtils } from "./StringUtils.sol";


contract StockRightApplyOnChainProxy /*is BaseStockRightApplyOnChain*/ {

	address creator;

	/**
             存储合约版本
    */
    address storageContract;
    
    /**
     * 逻辑合约地址(占位用)
     */
    address logicVersion;

    /**
     * 市监局信息的管理合约地址
     */
    address aicOrganHolder;
    
    /**
     * 管理股东的合约地址
     */
    address stockHolderContract;
    
    /**
     * 是否初始化
     */
    bool internal _initialized = false;
    
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
    function initialize(address newLogic,address newStorage,address newStockHolderContract) public onlyCreator returns (bool){
        require(!_initialized,"The contract has inited!");
        bool sucess;
        bytes memory result;
        logicVersion = newLogic;
        storageContract = newStorage;
        (sucess,result)= storageContract.call(abi.encodeWithSignature("setProxy(address)",address(this)));
        if(!sucess){
        	require(sucess,parseErrMsg(result));//初始化合约
        }
        (sucess,result)= storageContract.call(abi.encodeWithSignature("setLogic(address)",logicVersion));
        if(!sucess){
        	require(sucess,parseErrMsg(result));//初始化合约
        }
        
        stockHolderContract = newStockHolderContract;
        aicOrganHolder = StockHolderOnChainProxy(stockHolderContract).getAicOrganHolder();
        _initialized = true;
		return true;
    }
    
     /**
     * 版本发生变化
     */
    function changeCurrentVersion(address newVersion)public onlyCreator{
        require(_initialized);
        logicVersion = newVersion;
    }
    
    function getCurrentVersion() public view returns (address){
        return logicVersion;
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
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("startStockTransfer(string,string,string,string,bytes32,uint256,uint256)",uniScId,
			transferorCetfHash,investorName,investorCetfHash,merkel,cptAmt,price));
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
	}
	
	/**
      设置新股东账号
	  uniScId 统一社会信用码
      investorCetfHash 新股东身份证件信息
      investorAccount 新股东账号
    */
	function setNewStockHolderAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("setNewStockHolderAccount(string,string,address)",uniScId,
			investorCetfHash,investorAccount));
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
	}
	
	 /**
	  *出让方公司的董事会确认转让
	  */
	function comfirmByDirectors(string memory uniScId,string memory investorCetfHash) public returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("comfirmByDirectors(string,string)",uniScId,investorCetfHash));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
	}
	
	/**
	 *受让方出资
	 */
	function payForStock(string memory uniScId,string memory investorCetfHash)public payable returns (bool){
		require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("payForStock(string,string)",uniScId,investorCetfHash));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
	}
	
	/**
     * 工商局备案(市监局操作)
     * uniScId 统一社会信用码
     * investorCetfHash 受让方股东身份证件信息
     * isPass 是否审核通过
     * reason 审核不通过原因
     */
    function backUp(string memory uniScId,string memory investorCetfHash,bool isPass,string memory reason)public returns (bool){
    	require(_initialized,"The contract has not inited!");
        bool sucess;
        bytes memory result;
        (sucess,result)= logicVersion.delegatecall(abi.encodeWithSignature("backUp(string,string,bool,string)",uniScId,investorCetfHash,isPass,reason));
        if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        return bytesToBool(result);
    }
	
	/**
     * 把字节数组转成布尔型
     */
    function bytesToBool(bytes memory b) private pure returns(bool){
        return abi.decode(b,(bool));
    }
	
	function isInited() public view returns(bool){
	    return _initialized;
	}

	/** 
        获取Keys（返回json）
     */
	function getStockRightApplyKeysByUniScId(string memory uniScId) public returns (string memory){
        string[] memory stockRightApplyKeys = getStockRightApplyKeys(uniScId);
        string memory s = '[';
        for(uint64 i = 0;i<stockRightApplyKeys.length;i++){
          if(i>0){
            s = StringUtils.concat(s,',');
          }
          s = StringUtils.concat(s,"'",stockRightApplyKeys[i],"'");
        }
        s = StringUtils.concat(s,']');
        return s;
	}
	
	/**
	  获取Keys （返回数组）
	 */
	function getStockRightApplyKeys(string memory uniScId) private returns (string[] memory){
	    bool sucess;
        bytes memory result;
		(sucess,result)= storageContract.call(abi.encodeWithSignature("getStockRightApplyKeys(string)",uniScId));
		 if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
        string[] memory stockRightApplyKeys = abi.decode(result,(string[]));
        return stockRightApplyKeys;
	}
	
	/**
	 * 获取申请案列表
	*/
	function getStockRightApplysByUniScId(string memory uniScId) public returns (string memory){
	    string[] memory stockRightApplyKeys = getStockRightApplyKeys(uniScId);
	    string memory s = '[';
        for(uint64 i = 0;i<stockRightApplyKeys.length;i++){
          if(i>0){
            s = StringUtils.concat(s,',');
          }
          s = StringUtils.concat(s,getStockRightApply(uniScId,stockRightApplyKeys[i]));
        }
        s = StringUtils.concat(s,']');
        return s;
	}

    /** 
     申请案详情
     */
	function getStockRightApply(string memory uniScId,string memory investorCetfHash) public view returns (string memory){
		string memory s = '{';
		string memory lUniScId = uniScId;
        string memory transferorCetfHash = getTransferorCetfHash(uniScId,investorCetfHash);
		string memory lInvestorCetfHash = investorCetfHash;
		string memory investorName = getInvestorName(uniScId,investorCetfHash);
		uint price = getApplyPrice(uniScId,investorCetfHash);
		address investorAccount = getInvestorAccount(uniScId,investorCetfHash);
		string memory stockRightDetail = getStockRightDetail(uniScId,investorCetfHash);
		bytes32 merkel = getMerkel(uniScId,investorCetfHash);
		uint cptAmt = getCptAmt(uniScId,investorCetfHash);
		string memory isSuccess = getIsSuccess(uniScId,investorCetfHash);
		string memory status = getApplyStatus(uniScId,investorCetfHash);
		s=StringUtils.concat(s,"uniScId:'",lUniScId,"'");
		s=StringUtils.concat(s,",investorCetfHash:'",lInvestorCetfHash,"'");
		s=StringUtils.concat(s,",transferorCetfHash:'",transferorCetfHash,"'");
		s=StringUtils.concat(s,",investorName:'",investorName,"'");
		s=StringUtils.concat(s,",price:'",StringUtils.uint2str(price),"'");
		s=StringUtils.concat(s,",investorAccount:'",StringUtils.address2str(investorAccount),"'");
		s=StringUtils.concat(s,",stockRightDetail:'",stockRightDetail,"'");
		s=StringUtils.concat(s,",merkel:'",StringUtils.bytes32ToString(merkel),"'");
		s=StringUtils.concat(s,",cptAmt:'",StringUtils.uint2str(cptAmt),"'");
		s=StringUtils.concat(s,",isSuccess:'",isSuccess,"'");
		s=StringUtils.concat(s,",status:'",status,"'");
		s=StringUtils.concat(s,"}");
        return s;
	}
	//以下是从区块链中获取各个字段。
	 function getTransferorCetfHash(string memory uniScId,string memory investorCetfHash)private view returns (string memory){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getTransferorCetfHash(string,string)",uniScId,investorCetfHash));
    	string memory transferorCetfHash = StockRightApplyOnChainStorage(storageContract).getTransferorCetfHash(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//string memory transferorCetfHash = abi.decode(result,(string));
		return transferorCetfHash;
    }
    
    function getInvestorAccount(string memory uniScId,string memory investorCetfHash)private view returns (address payable){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getInvestorAccount(string,string)",uniScId,investorCetfHash));
    	address payable investorAccount = StockRightApplyOnChainStorage(storageContract).getInvestorAccount(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//address payable investorAccount = abi.decode(result,(address));
		return investorAccount;
    }
    
    function getInvestorName(string memory uniScId,string memory investorCetfHash)private view returns (string memory){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getInvestorName(string,string)",uniScId,investorCetfHash));
    	string memory investorName = StockRightApplyOnChainStorage(storageContract).getInvestorName(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//string memory investorName = abi.decode(result,(string));
		return investorName;
    }
    
    function getCptAmt(string memory uniScId,string memory investorCetfHash)private view returns (uint){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getCptAmt(string,string)",uniScId,investorCetfHash));
    	uint cptAmt = StockRightApplyOnChainStorage(storageContract).getCptAmt(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//uint cptAmt = abi.decode(result,(uint));
		return cptAmt;
    }
    
    function getApplyStatus(string memory uniScId,string memory investorCetfHash) private view returns (string memory){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getStatus(string,string)",uniScId,investorCetfHash));
    	string memory status = StockRightApplyOnChainStorage(storageContract).getStatus(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//string memory status = abi.decode(result,(string));
		return status;
    }
    
    function getStockRightDetail(string memory uniScId,string memory investorCetfHash) private view returns (string memory){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getStockRightDetail(string,string)",uniScId,investorCetfHash));
    	string memory detail = StockRightApplyOnChainStorage(storageContract).getStockRightDetail(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//string memory detail = abi.decode(result,(string));
		return detail;
    }
    
    function getMerkel(string memory uniScId,string memory investorCetfHash) private view returns (bytes32){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getMerkel(string,string)",uniScId,investorCetfHash));
    	bytes32 merkel = StockRightApplyOnChainStorage(storageContract).getMerkel(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//bytes32 merkel = abi.decode(result,(bytes32));
		return merkel;
    }
    
    function getIsSuccess(string memory uniScId,string memory investorCetfHash) private view returns (string memory){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getIsSuccess(string,string)",uniScId,investorCetfHash));
    	string memory isSuccess = StockRightApplyOnChainStorage(storageContract).getIsSuccess(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//string memory isSuccess = abi.decode(result,(string));
		return isSuccess;
    }
    
    function getApplyPrice(string memory uniScId,string memory investorCetfHash) private view returns (uint){
    	//bool sucess;
        //bytes memory result;
    	//(sucess,result) = storageContract.call(abi.encodeWithSignature("getPrice(string,string)",uniScId,investorCetfHash));
    	uint price = StockRightApplyOnChainStorage(storageContract).getPrice(uniScId,investorCetfHash);
		//if(!sucess){
		//	require(sucess,parseErrMsg(result));
		//}
		//uint price = abi.decode(result,(uint));
		return price;
    }
	
	/**
	 * 解析异常信息。
	 */
	function parseErrMsg(bytes memory b) private pure returns(string memory){
		if(b.length==0){
			return '';
		}
		require(b.length<2**64,"The Array is out of bound.");
		for(uint64 i = 0;i<b.length-4;i++){
        	b[i]=b[i+4];
    	}
    	for(uint i = b.length-4;i<b.length;i++){
    		b[i]=0x0;
    	}
    	return abi.decode(b,(string));
	}
	
	/**
	 * 把合约中的货币支付给另外一个账户，免得货币被锁死
	 */
	function payToAnotherContract(address payable anotherContract,uint amt) public onlyCreator returns (bool){
	    anotherContract.transfer(amt);
	    return true;
	}
}
