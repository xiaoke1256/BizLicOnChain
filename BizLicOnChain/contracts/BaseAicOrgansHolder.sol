pragma solidity ^0.6.0;

contract BaseAicOrgansHolder {
    
    /**
     * 工商局
     */
    struct AicOrgan{
        string organCode;//机关代码
        string organName;//机关名称
        address publicKey;//公钥
        bool isUsed;
    }
    
    address creator;
    
     /*
     * 管理员
     */
    address[] administrators;
    
    /**
     * 所有工商机关
     */
    mapping(string => AicOrgan) aicOrgans;
    
    /**
     * 所有工商机关的编码
     */
    string[] aicOrganCodes;

    // TODO Add functions


}
