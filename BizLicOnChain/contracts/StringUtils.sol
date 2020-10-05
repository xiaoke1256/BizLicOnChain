pragma solidity ^0.6.0;

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
    function concat(string memory s1, string memory s2,string memory s3) internal pure returns (string memory) {
        return concat(concat(s1,s2),s3);
    }
    
     /**
     * 拼接字符串
     */
    function concat(string memory s1, string memory s2,string memory s3,string memory s4) internal pure returns (string memory) {
        return concat(concat(s1,s2,s3),s4);
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
	
	/**
	 * 把数字转成字符串
	 */
	function uint2str(uint i) internal pure returns (string memory c) {
        if (i == 0) return "0";
        uint j = i;
        uint length=0;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory numEle = bytes("0123456789");
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = numEle[i % 10];
            i /= 10;
        }
        c = concat("0x",string(bstr));
    }
	
	 function bytes32ToString(bytes32 x) internal pure returns (string memory) { 
        bytes memory bytesString = new bytes(32); 
        uint charCount = 0; 
        for (uint j = 0; j < 32; j++) { 
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j))); 
            if (char != 0) { 
                bytesString[charCount] = char; 
                charCount++; 
            } 
        } 
        bytes memory bytesStringTrimmed = new bytes(charCount); 
        for (uint j = 0; j < charCount; j++) { 
            bytesStringTrimmed[j] = bytesString[j]; 
        } 
        return string(bytesStringTrimmed); 
    }
	
    function bytes32ArrayToString(bytes32[] memory data) internal pure returns (string memory) { 
        bytes memory bytesString = new bytes(data.length * 32); 
        uint urlLength; 
        for (uint i = 0; i< data.length; i++) { 
            for (uint j = 0; j < 32; j++) { 
                byte char = byte(bytes32(uint(data[i]) * 2 ** (8 * j))); 
                if (char != 0) { 
                    bytesString[urlLength] = char; 
                    urlLength += 1; 
                } 
            } 
        } 
        bytes memory bytesStringTrimmed = new bytes(urlLength); 
        for (uint i = 0; i < urlLength; i++) { 
            bytesStringTrimmed[i] = bytesString[i]; 
        } 
        return string(bytesStringTrimmed); 
    }    
}
