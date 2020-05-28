pragma solidity ^0.5.0;

//pragma experimental ABIEncoderV2;


library StringUtils {

    /**
     * 拼接字符串
     */
    function concat(string memory s1, string memory s2) internal pure returns (string memory) {
		bytes memory _ba = bytes(s1);
        bytes memory _bb = bytes(s2);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint64 k = 0;
        for (uint64 i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (uint64 i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);
    }
    
     /**
     * 拼接字符串
     */
    function concat(string[] memory s1) internal pure returns (string memory) {
        if(s1.length==0){
            return "";
        }
        string memory s = s1[0];
        for(uint64 i = 1; i < s1.length; i++){
            s = concat(s,s1[i]);
        }
        return s;
    }
    
    /**
     * 把地址转成字符串
     */
    function address2str(address a) internal pure returns (string memory c) {
        uint160 i = uint160(a);
        if (i == 0) return "0";
        uint160 j = i;
        uint length=0;
        while (j != 0){
            length++;
            j /= 16;
        }
        bytes memory numEle = bytes("0123456789abcdef");
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = numEle[i % 16];
            i /= 16;
        }
        c = concat("0x",string(bstr));
    }
}
