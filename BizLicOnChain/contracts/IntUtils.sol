pragma solidity ^0.6.0;

library IntUtils {
    /**
     * 求其最大者
     */
    function max(uint a,uint b)internal pure returns (uint){
        if(a>b)
           return a;
        else
           return b;
    }
    
    /**
     * 求其最大者
     */
    function max(uint[] memory a) internal pure returns (uint){
       uint maxNum =0;
       for(uint64 i= 0; i<a.length; i++){
           maxNum = max(maxNum,a[i]);
       }
       return maxNum;
    }
}
