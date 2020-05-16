pragma solidity ^0.4.25;

//pragma experimental ABIEncoderV2;


library StringUtils {

    /**
     * 拼接字符串
     */
    function concat(string memory s1, string memory s2) internal pure returns (string) {
		bytes memory _ba = bytes(s1);
        bytes memory _bb = bytes(s2);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);
    }
    
     /**
     * 拼接字符串
     */
    function concatArr(string[] memory s1) internal pure returns (string) {
        string memory s = s1[0];
        for(uint i = 1; i < s1.length; i++){
            s = concat(s,s1[i]);
        }
        return s;
    }
}
