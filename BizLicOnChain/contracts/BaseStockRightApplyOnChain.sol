pragma solidity ^0.6.0;

contract BaseStockRightApplyOnChain {
    
    /*
     * 股权申请。（还处于流程中的股权）
     */
    struct StockRightApply{
        string uniScId;//统一社会信用码
		string transferorCetfHash;//出让方身份证件的Hash值
        string investorName;//新股东姓名
        uint price;//价格（以太币,wei）
        address payable investorAccount;//新股东账号
        string investorCetfHash;//新股东身份证件信息
        string stockRightDetail;//股权详情
        bytes32 merkel;//默克尔值（新股东姓名、新股东身份证件、转让份额三者加起来的默克尔值）
        uint cptAmt;//转让额度
        string isSuccess;//是否交易成功'0'否'1'是
        string status;//状态 “开始”、“待董事会确认”，“待付款”，“发证机关备案”，“结束”（成功或失败）。
        string failReason; //失败原因
    }
    
    address creator;
    
    /**
     * 股权申请的Map，其中key是统一社会信用码.
	 * value mapping 的结构如下：key是新股东的身份证件号，value申请信息。
     */
    mapping(string => mapping(string =>StockRightApply)) stockRightApplys;
	/**
	 * 申请案号的Map，其中key是统一社会信用码.
	 */
	mapping(string => string[]) stockRightApplyKeys;
    
    /**
     * 市监局信息的管理合约地址
     */
    address aicOrganHolder;
    
    /**
     * 管理股东的合约地址
     */
    address stockHolderContract;
    
    /**
     * 合约版本
     */
    address currentVersion;
    
     /**
     * 是否初始化
     */
    bool internal _initialized = false;

}
