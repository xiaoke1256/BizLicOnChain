pragma solidity ^0.6.0;

contract BaseStockHolderOnChain {
    /**
     * 股东
     */
    struct StockHolder{
        string uniScId;//统一社会信用码
        string investorNo;//股东编号
        string investorName;//电子签章
        address investorAccount;//股东账号
        string investorCetf;//身份证件信息
        string stockRightDetail;//股权详情
        uint merkel;//默克尔值
        uint cptAmt;//出资额度
    }
    
    /*
     * 股权申请。（还处于流程中的股权）
     */
    struct StockRightApply{
        string uniScId;//统一社会信用码
        string investorName;//电子签章
        uint price;//价格（以太币）
        address investorAccount;//股东账号
        string investorCetf;//身份证件信息
        string stockRightDetail;//股权详情
        uint merkel;//默克尔值
        uint cptAmt;//出资额度
        string isSuccess;//是否交易成功
        string status;//状态 “待董事会确认”，“待付款”，“发证机关备案”，“结束”（成功或失败）。
    }
    
    address creator;
    
    /*
     * 所有的股东，其中key是组织机构代码，value是另外一个mapping。
     * value mapping 的结构如下：key是股东编号，value是股东信息。
     */
    mapping(string => mapping(string => StockHolder)) stockHolders;
    
    /**
     * 股东编号的Map,其中key是组织机构代码.
     */
    mapping(string => string[]) stockHoldersNos;
    
    /**
     * 股权申请的Map，其中key是组织机构代码.
     */
    mapping(string => StockRightApply[]) stockRightApplys;
    
    /**
     * 市监局信息的管理合约地址
     */
    address aicOrganHolder;

}
