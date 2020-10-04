pragma solidity ^0.6.0;

contract BaseStockHolderOnChain {
    /**
     * 股东
     */
    struct StockHolder{
        string uniScId;//统一社会信用码
        uint investorNo;//股东编号
        string investorName;//股东姓名
        address investorAccount;//股东账号
        bytes32 investorCetfHash;//身份证件信息
        string stockRightDetail;//股权详情
        bytes32 merkel;//默克尔值
        uint cptAmt;//出资额度
    }
    
    /*
     * 股权申请。（还处于流程中的股权）
     */
    struct StockRightApply{
        string uniScId;//统一社会信用码
        string investorName;//股东姓名
        uint price;//价格（以太币,微）
        address investorAccount;//股东账号
        bytes32 investorCetfHash;//身份证件信息
        string stockRightDetail;//股权详情
        bytes32 merkel;//默克尔值
        uint cptAmt;//出资额度
        string isSuccess;//是否交易成功
        string status;//状态 “待董事会确认”，“待付款”，“发证机关备案”，“结束”（成功或失败）。
    }
    
    address creator;
    
    /*
     * 所有的股东，其中key是组织机构代码，value是另外一个mapping。
     * value mapping 的结构如下：key是股东编号，value是股东信息。
     */
    mapping(string => mapping(uint => StockHolder)) stockHolders;
    
    /**
     * 股东编号的Map,其中key是组织机构代码.
     */
    mapping(string => uint[]) stockHoldersNos;
    
    /**
     * 股权申请的Map，其中key是组织机构代码.
     */
    mapping(string => StockRightApply[]) stockRightApplys;
    
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

}
