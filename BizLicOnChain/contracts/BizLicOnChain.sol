pragma solidity ^0.6.0;

import { ArrayUtils } from "./ArrayUtils.sol";
import { EncryptUtils } from "./EncryptUtils.sol";
import { BaseBizLicOnChain } from "./BaseBizLicOnChain.sol";
import { AicOrgansHolderProxy } from "./AicOrgansHolderProxy.sol";

contract BizLicOnChain is BaseBizLicOnChain {
    /**
     * 创建者
     */
    address creator;
    
    /*
     * 所有营业执照（key是组织机构代码，value是营业执照内容的json）
     */
    mapping(string => BizLic) bizLics;
    
    /**
     * 所有企业的统一社会信用码
     */
    string[] uniScIds;
    
    /* 用来占位 */
    bool internal _initialized = false;
	
    /**
     * 发证机关合约地址
     */
    address aicOrganHolder;
    
    /**
     * 逻辑合约地址 用来占位
     */
    address currentVersion;

    constructor() public{
        creator = tx.origin;
    }

    /**
     * 初始化合约(用delegatecall来调用)
     */
    function initialize() external {
        require(creator == tx.origin);
        administrators.push(tx.origin);
    }
	
	
	/**
	 * 将老版本数据加载过来
	 */
	function reloadData(address oldVersion) public {
	    //.....
	}
    
    /**
     * 仅管理员才可以执行此
     */
    modifier onlyAdmin() {
        //tx.origin 是合约的发起方，而msg.sender是上一级调用者的地址
		require(AicOrgansHolderProxy(aicOrganHolder).isAdmin(tx.origin),"Unauthorized operation!");
		_;
    }
    
    /**
     * 往区块链上新增或修改一个证书
     * uniScId: 统一社会信用码，作为企业的唯一标识
     * organCode: 发证机关
     * licContent: 证书内容（拼成json）
     * sign: 电子签名
     * 
     */
    function putLic(string memory uniScId,string memory organCode,string memory licContent,string memory sign) public onlyAdmin returns (bool) {
        require(bytes(uniScId).length>0);
        require(bytes(organCode).length>0);
        require(bytes(licContent).length>0);
        require(bytes(sign).length>0);
        //校验数字签名
        //require(EncryptUtils.verificate(licContent,sign,aicOrgans[organCode].publicKey),'Verificate sign fail.');
        
        bizLics[uniScId].organCode = organCode;
        bizLics[uniScId].licContent = licContent;
        bizLics[uniScId].sign = sign;
        
        uniScIds.push(uniScId);
        return true;
    }
    
     /**
     * 删除一个证书
     * uniScId: 统一社会信用码，作为企业的唯一标识
     * 
     */
    function removeLic(string memory uniScId) public onlyAdmin returns (bool) {
        require(bytes(uniScId).length>0);
        delete bizLics[uniScId];
        ArrayUtils.remove(uniScIds,uniScId);
        return true;
    }
    
}
