pragma solidity ^0.6.0;

contract BaseStockHolderOnChain {
    /**
     * 股东
     */
    struct StockHolder{
        string uniScId;//统一社会信用码
        string investorName;//股东姓名
        address payable investorAccount;//股东账号
        string investorCetfHash;//身份证件信息
        string stockRightDetail;//股权详情
        bytes32 merkel;//默克尔值
        uint cptAmt;//出资额度
    }
    
    address creator;
    
    /*
     * 所有的股东，其中key是组织机构代码，value是另外一个mapping。
     * value mapping 的结构如下：key是股东身份证件的Hash值，value是股东信息。
     */
    mapping(string => mapping(string => StockHolder)) stockHolders;
    
    /**
     * 股东编号的Map,其中key是组织机构代码.value是股东身份证件的Hash值
     */
    mapping(string => string[]) stockHoldersKeys;
    
    /**
     * 市监局信息的管理合约地址
     */
    address aicOrganHolder;
    
    /**
     * 管理营业执照的合约地址
     */
    address bizLicContract;
    
    /**
     * 合约版本
     */
    address currentVersion;
    
     /**
     * 是否初始化
     */
    bool internal _initialized = false;
    
    function getAicOrganHolder() public view returns(address){
    	return aicOrganHolder;
    }

}
