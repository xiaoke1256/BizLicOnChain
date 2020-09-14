pragma solidity ^0.6.0;

contract BaseStockHolderOnChain {
    /**
     * 股东
     */
    struct StockHolder{
        string uniScId;//统一社会信用码
        string investorNo;//股东编号
        string investorName;//电子签章
        string investorCetfType;//证件类型
        string investorCetfId;//证件号码
        uint cptAmt;//证件号
    }

}
