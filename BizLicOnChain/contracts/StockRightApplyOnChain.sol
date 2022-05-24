pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";
import { ArrayUtils } from "./ArrayUtils.sol";
import { StringUtils } from "./StringUtils.sol";

contract StockRightApplyOnChain /*is BaseStockRightApplyOnChain*/ {
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
    
    /**
    股东地址发生改变的事件
    */
    event InvestorAccountChange(string indexed uniScId,string indexed investorCetfHash,address investorAccount);
    
    /**
     * 申请状态发生改变的事件
    */
    event StatusChange(string indexed uniScId,string indexed investorCetfHash,string newStatus);


    constructor() public{
        creator = msg.sender;
    }
    
    /**
     * 仅（市监局）管理员才可以执行
     */
    modifier onlyAdmin() {
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		require(AicOrgansHolderProxy(aicOrganHolder).isAdmin(tx.origin),"Unauthorized operation!");
		_;
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
		require(bytes(uniScId).length>0);
		require(bytes(investorCetfHash).length>0);
        require(bytes(transferorCetfHash).length>0);
		//出在让方存这个股东，且账号就是操作人。
		bool sucess;
        bytes memory result;
		(sucess,result)= stockHolderContract.call(abi.encodeWithSignature("checkStockHoldersAccount(string,string,address)",uniScId,transferorCetfHash,tx.origin));
		if(!sucess)
			require(sucess,parseErrMsg(result));
		require(abi.decode(result,(bool)),'You are not the stock Holder!');
		//把所有的申请案号拿出来取其最大者。
		require(!contains(getStockRightApplyKeys(uniScId),investorCetfHash),'This investor are in apply flow,please finish the flow then start this flow.');
		(sucess,result) = storageContract.call(abi.encodeWithSignature("putStockRightApply(string,string,string,uint256,address,string,string,bytes32,uint256)",
			uniScId,transferorCetfHash,investorName,price,address(0),investorCetfHash,'',merkel,cptAmt));
		if(!sucess)
			require(sucess,parseErrMsg(result));
		require(abi.decode(result,(bool)),'Some thing wrong when invoke putStockRightApply method!');
		emit StatusChange(uniScId,investorCetfHash,'待董事会确认');
		return true;
	}
	
	/**
	 * 获取所有申请案的key
	 */
	function getStockRightApplyKeys(string memory uniScId)private returns (string[] memory){
		bool sucess;
        bytes memory result;
		(sucess,result) = storageContract.call(abi.encodeWithSignature("getStockRightApplyKeys(string)",uniScId));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
    	return abi.decode(result,(string[]));
    }

	/**
      设置新股东账号
	  uniScId 统一社会信用码
      investorCetfHash 新股东身份证件信息
      investorAccount 新股东账号
    */
	function setNewStockHolderAccount(string memory uniScId,string memory investorCetfHash,address payable investorAccount) public returns (bool){
        require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
		//出在让方存这个股东，且账号就是操作人。
		//string memory transferorCetfHash = stockRightApplys[uniScId][investorCetfHash].transferorCetfHash;
		//require(stockHolders[uniScId][transferorCetfHash].investorAccount==tx.origin);
		bool sucess;
        bytes memory result;
		//状态是否正确
		(sucess,result) =storageContract.call(abi.encodeWithSignature("getStatus(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		string memory applyStatus = abi.decode(result,(string));
        require(StringUtils.equals(applyStatus,'待董事会确认'),'This apply at the wrong state.');
        (sucess,result) = storageContract.call(abi.encodeWithSignature("setInvestorAccount(string,string,address)",uniScId,investorCetfHash,investorAccount));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		emit InvestorAccountChange(uniScId,investorCetfHash,investorAccount);
		return true;
	}
    
    /**
     * 出让方公司的董事会确认转让（TODO 董事会可以驳回）
     */
	function comfirmByDirectors(string memory uniScId,string memory investorCetfHash) public returns (bool){
		require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
        bool sucess;
        bytes memory result;
        (sucess,result) = storageContract.call(abi.encodeWithSignature("getInvestorAccount(string,string)",uniScId,investorCetfHash));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		address investorAccount = abi.decode(result,(address));
        require(investorAccount!=address(0),'必须设置新股东账号。');
		//TODO 检查当前账号就是公司的董事会账号
		//状态是否正确
		string memory applyStatus = getApplyStatus(uniScId,investorCetfHash);
		require(StringUtils.equals(applyStatus,'待董事会确认'),'This apply at the wrong state.');
		(sucess,result) = storageContract.call(abi.encodeWithSignature("setStatus(string,string,string)",uniScId,investorCetfHash,'待付款'));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		emit StatusChange(uniScId,investorCetfHash,'待付款');
		return true;
	}
    
    /*
     * 受让方出资
     */
	function payForStock(string memory uniScId,string memory investorCetfHash)public payable returns (bool){
		require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
        //TODO 检查合约状态
        //TODO 记录付款人账号（以便万一失败以太币原路退还）
		require(msg.value>0);
		bool sucess;
        bytes memory result;
		//检查出资额
		uint price = getApplyPrice(uniScId,investorCetfHash);
		require(msg.value>=price);
		if(msg.value>price){
			//把实际支付金额放到price中
			(sucess,result) = storageContract.call(abi.encodeWithSignature("setPrice(string,string,uint254)",uniScId,investorCetfHash,price));
			 if(!sucess){
				require(sucess,parseErrMsg(result));
			}
		}
		(sucess,result) = storageContract.call(abi.encodeWithSignature("setStatus(string,string,string)",uniScId,investorCetfHash,'待发证机关备案'));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		emit StatusChange(uniScId,investorCetfHash,'待发证机关备案');
		return true;
	}
	
    
    /**
     * 工商局备案(市监局操作)
     * uniScId 统一社会信用码
     * investorCetfHash 受让方股东身份证件信息
     * isPass 是否审核通过
     * reason 审核不通过原因
     */
    function backUp(string memory uniScId,string memory investorCetfHash,bool isPass,string memory reason)public onlyAdmin returns (bool){
    	require(bytes(uniScId).length>0);
        require(bytes(investorCetfHash).length>0);
        require( isPass || bytes(reason).length>0 ,'审核不通过则需要提供审核不通过的理由.');
        string memory applyStatus = getApplyStatus(uniScId,investorCetfHash);
        require(StringUtils.equals(applyStatus,'待发证机关备案'));
        uint applyPrice = getApplyPrice(uniScId,investorCetfHash);
        //检查一下以太币够不够
        require(address(this).balance>=applyPrice,'The balace of the contract is not enough.');
        if(isPass){
        	//调用stockHolderContract创建新的股权人
        	//先检查新股东是否已存在。
			uint newCptAmt = getStockHolderCptAmt(uniScId,investorCetfHash);
			uint cptAmt = getCptAmt(uniScId,investorCetfHash);
			if(newCptAmt>0){//大于0表示新股东已存在
				//调用增资函数
				bool result = increCpt(uniScId,investorCetfHash,'',cptAmt);
				require(result,'something wrong when invork the  increCpt.');
			}else{
				string memory investorName = getInvestorName(uniScId,investorCetfHash);
				address payable investorAccount = getInvestorAccount(uniScId,investorCetfHash);
				//调用创建新股东。
				bool result = putStockHolder(uniScId
					,investorCetfHash
					,investorName
					,investorAccount
					,''
					,cptAmt);
				require(result,'something wrong when invork the  putStockHolder.');					
			}
			//先把旧的股权人的账号记下来。
			string memory transferorCetfHash = getTransferorCetfHash(uniScId,investorCetfHash);
			address payable oldInverstCount = getStockHolderAccount(uniScId,transferorCetfHash);
			//检查一下账号是否为空
        	//旧的股权人扣除一定的股权。如果扣完则删除旧的股权人。
        	bool result = increCpt(uniScId,transferorCetfHash,'',-cptAmt);
        	require(result,'something wrong when invork the  increCpt.');
        	//申请案设置成完成。
        	setSuccessAndResult(uniScId,investorCetfHash,'1','结束','');
        	//把以太币支付给股权出让方
        	//uint applyPrice = getApplyPrice(uniScId,investorCetfHash);
        	oldInverstCount.transfer(applyPrice);
        }else{
        	//申请案设置成完成（失败）
        	setSuccessAndResult(uniScId,investorCetfHash,'0','结束',reason);
        	//把以太币支退给股权受让方
        	address payable investorAccount = getInvestorAccount(uniScId,investorCetfHash);
        	//uint applyPrice = getApplyPrice(uniScId,investorCetfHash);
        	investorAccount.transfer(applyPrice);
        }
        emit StatusChange(uniScId,investorCetfHash,'结束');
    	return true;
    }
    
    /**
     * 一个申请案流程结束了,设置其状态和是否成功。
     */
    function setSuccessAndResult(string memory uniScId,string memory investorCetfHash,string memory isSuccess,string memory status,string memory reason)private {
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("setIsSuccess(string,string,string)",uniScId,investorCetfHash,isSuccess));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		(sucess,result) = storageContract.call(abi.encodeWithSignature("setStatus(string,string,string)",uniScId,investorCetfHash,status));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		(sucess,result) = storageContract.call(abi.encodeWithSignature("setFailReason(string,string,string)",uniScId,investorCetfHash,reason));
        if(!sucess){
			require(sucess,parseErrMsg(result));
		}
    }
    
    //以下是个字段的get和set
    function getTransferorCetfHash(string memory uniScId,string memory investorCetfHash)private returns (string memory){
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("getTransferorCetfHash(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		string memory transferorCetfHash = abi.decode(result,(string));
		return transferorCetfHash;
    }
    
    function getInvestorAccount(string memory uniScId,string memory investorCetfHash)private returns (address payable){
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("getInvestorAccount(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		address payable investorAccount = abi.decode(result,(address));
		return investorAccount;
    }
    
    function getInvestorName(string memory uniScId,string memory investorCetfHash)private returns (string memory){
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("getInvestorName(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		string memory investorName = abi.decode(result,(string));
		return investorName;
    }
    
    function getCptAmt(string memory uniScId,string memory investorCetfHash)private returns (uint){
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("getCptAmt(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		uint cptAmt = abi.decode(result,(uint));
		return cptAmt;
    }
    
    function getApplyStatus(string memory uniScId,string memory investorCetfHash) private returns (string memory){
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("getStatus(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		string memory status = abi.decode(result,(string));
		return status;
    }
    
    function getApplyPrice(string memory uniScId,string memory investorCetfHash) private returns (uint){
    	bool sucess;
        bytes memory result;
    	(sucess,result) = storageContract.call(abi.encodeWithSignature("getPrice(string,string)",uniScId,investorCetfHash));
		if(!sucess){
			require(sucess,parseErrMsg(result));
		}
		uint price = abi.decode(result,(uint));
		return price;
    }
    

	/**
	 * 获取股东持有的股权（以人民币计）
	 */
	function getStockHolderCptAmt(string memory uniScId,string memory investorCetfHash) private returns (uint){
		bool sucess;
    	bytes memory result;
    	(sucess,result) = stockHolderContract.call(abi.encodeWithSignature("getStockHolderCptAmt(string,string)",uniScId,investorCetfHash));
    	if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
		return abi.decode(result,(uint));
	}
	
	/**
	 * 增减资
	 */
	function increCpt(string memory uniScId,string memory investorCetfHash,string memory stockRightDetail,uint256 amt) private returns (bool){
		bool sucess;
    	bytes memory result;
		(sucess,result) = stockHolderContract.call(abi.encodeWithSignature("increCpt(string,string,string,uint256)",uniScId,investorCetfHash,stockRightDetail,amt));
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
		return abi.decode(result,(bool));
	}
	
	/**
	 * 创建新股东
	 */
	function putStockHolder(string memory uniScId,string memory investorCetfHash,string memory investorName,address investorAccount,string memory stockRightDetail,uint256 amt)private returns (bool){
		bool sucess;
    	bytes memory result;
		(sucess,result) = stockHolderContract.call(abi.encodeWithSignature("putStockHolder(string,string,string,address,string,uint256)"
					,uniScId
					,investorCetfHash
					,investorName
					,investorAccount
					,stockRightDetail
					,amt));
		if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
		return abi.decode(result,(bool));
	}
	
	/**
	 * 获取旧股东的账号
	 */
	function getStockHolderAccount(string memory uniScId,string memory transferorCetfHash) private returns (address payable){
		bool sucess;
    	bytes memory result;
    	(sucess,result) = stockHolderContract.call(abi.encodeWithSignature("getStockHolderAccount(string,string)",uniScId,transferorCetfHash));
    	if(!sucess){
        	require(sucess,parseErrMsg(result));
        }
		return abi.decode(result,(address));
	}
	
	/**
	 * 判断数组中是否包含某元素
	 */
	function contains(string[] memory array,string memory target) private view returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(StringUtils.equals(array[i],target)){
                return true;
            } 
        }
        return false;
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

}
