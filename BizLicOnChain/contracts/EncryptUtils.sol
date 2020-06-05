pragma solidity ^0.5.0;

/**
 * 加解密函数
 */
library EncryptUtils {
    
     /**
      * 校验签名
      * orgContent: 原文
      * sign:签名
      * targetAdress: 公钥
      */
    function verificate(string memory orgContent,string memory sign,address targetAdress) public pure returns(bool) {
        //solidity 有4个取散列的方法：keccak256,sha3,sha256,ripemd160;其中ripemd160返回的是bytes20,不符合要求;sha3的算法与keccak256相同
        bytes memory signature = bytes(sign);
		bytes32 r = bytesToBytes32(slice(signature,0,32));
		bytes32 s = bytesToBytes32(slice(signature,32,32));
		uint8 v = bytesToUint(slice(signature,64,1));
        address addr = ecrecover(sha256(bytes(orgContent)),v,r,s);
        return addr==targetAdress;
    }
    
    function slice(bytes memory data,uint start,uint len) public pure returns(bytes memory){
        bytes memory b=new bytes(len);
        for(uint i=0;i<len;i++){
            b[i]=data[i+start];
        }
        return b;
    }
    
    function bytesToBytes32(bytes memory source) public pure returns(bytes32 result){
        assembly{
            result :=mload(add(source,32))
        }
    }
    
    function bytesToUint(bytes memory b) public pure returns (uint8){
	    uint8 number = 0;
	    for(uint64 i= 0; i<b.length; i++){
	        number = uint8(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
	    }
	    return number;
	}
	
	function uintToBytes(uint x) public pure returns (bytes memory b){
//	    bytes memory b;
//	    uint index = 0;
//	    while(i>0){
//	        b[index]=byte(i%256);
//	        index++;
//	    }
//	    return b;
//		assembly {
//	        b := mload(0x10)
//	        mstore(b, 0x20)
//	        mstore(add(b, 0x20), x)
//      }
        
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
        
//		b = new bytes(32);
//        for (uint i = 0; i < 32; i++) {
//            b[i] = byte(uint8(x / (2**(8*(31 - i)))));
//        }
	}
	
	/**
	 * 把16进制字符串解析成bytes数组
	 */
	function parseBytes(string memory s) public pure returns(bytes memory){
	    bytes memory numEle = bytes("0123456789abcdef");
	    bytes memory numEleUpper = bytes("0123456789ABCDEF");
	    bytes memory bys = bytes(s);
	    uint64 from = 0;
	    if(bys[0]==bytes("0")[0] && bys[1]==bytes("x")[0]){
	        from+=2;
	    }
	    //uint len = bys.length-from;
	    
	    //bytes memory b=new bytes(len/2);
	    uint256 result = 0;
	    for(uint i=bys.length-1;i>=from;i--){
	        bool hasFound = false;
	        for(uint j=0;j<numEle.length;j++){
	            if(numEle[j]==bys[i]){
	                result = result*16+j;
	                hasFound = true;
	                break;
	            }
	        }
	        if(!hasFound){
		        for(uint j=0;j<numEleUpper.length;j++){
		            if(numEleUpper[j]==bys[i]){
		                result = result*16+j;
		                hasFound = true;
		                break;
		            }
		        }
	        }
	        require(hasFound,"Invalid char");
	    }
//	    if(len%2!=0){
//	        len++;
//	    }
    	return uintToBytes(result);
	}
	
	
}
