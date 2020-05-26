pragma solidity ^0.5.0;

contract BaseBizLicOnChain {
    /**
     * 工商局
     */
    struct AicOrgan{
        string organCode;//机关代码
        string organName;//机关名称
        bytes publicKey;//公钥
        bool isUserd;
    }
    
    struct BizLic{
        string organCode;//发证机关代码
        string licContent;//证照内容
        string sign;//电子签章
    }
}
