pragma solidity ^0.6.0;

/**
 * 营业执照电子合约的基类，用来定义要用到的结构体
 */
contract BaseBizLicOnChain {
    /**
     * 工商局
     */
    struct AicOrgan{
        string organCode;//机关代码
        string organName;//机关名称
        address publicKey;//公钥
        bool isUserd;
    }
    
    /**
     * 营业执照
     */
    struct BizLic{
        string organCode;//发证机关代码
        string licContent;//证照内容
        string sign;//电子签章
    }
}
