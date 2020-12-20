pragma solidity ^0.6.0;

import { StringUtils } from "./StringUtils.sol";

/**
 * 数组计算工具类
 */
library ArrayUtils {
	
	/**
     * 判断数组中是否包含指定元素
     */
	function contains(address[] memory array,address target) internal view returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(array[i] == target){
                return true;
            } 
        }
        return false;
	}
	
	 /**
     * 返回指定元素在数组中的位置
     */
	function indexOf(address[] storage array,address target) internal view returns(uint64){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(array[i] == target){
                return i;
            } 
        }
        return uint64(-1);
	}
	
	/**
	 * 删除指定位置的元素
	 */
	function removeAt (address[] storage array,uint64 index) internal returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    if(index>=array.length){
	        return false;
	    }
	    for(uint64 i = index;i<array.length-1;i++){
	        array[i]=array[i+1];
	    }
	    array.pop();
	    return true;
	}
	
	/**
	 * 删除一个元素
	 */
	function remove (address[] storage array ,address target) internal returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    uint64 index = indexOf(array,target);
	    return removeAt(array,index);
	}
	
	 /**
     * 返回指定元素在数组中的位置
     */
	function indexOf(string[] memory array,string memory target) internal pure returns(uint64){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(stringEquals(array[i],target)){
                return i;
            } 
        }
        return uint64(-1);
	}
	
	/**
	 * 判断数组中是否包含某元素
	 */
	function contains(string[] storage array,string memory target) internal view returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(stringEquals(array[i],target)){
                return true;
            } 
        }
        return false;
	}
	
	/**
	 * 删除指定位置的元素
	 */
	function removeAt (string[] storage array,uint64 index) internal returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    if(index>=array.length){
	        return false;
	    }
	    for(uint64 i = index;i<array.length-1;i++){
	        array[i]=array[i+1];
	    }
	    array.pop();
	    return true;
	}
	
	/**
	 * 删除一个元素
	 */
	function remove (string[] storage array ,string memory target) internal returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    uint64 index = indexOf(array,target);
	    return removeAt(array,index);
	}
	
	/**
	 * 判断字符串是否相等
	 */
	function stringEquals(string memory str1,string memory str2) private pure returns (bool){
	    return StringUtils.equals(str1,str2);
	}
	
	 /**
     * 返回指定元素在数组中的位置
     */
	function indexOf(uint[] memory array,uint target) internal pure returns(uint64){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(array[i]==target){
                return i;
            } 
        }
        return uint64(-1);
	}
	
	/**
	 * 判断数组中是否包含某元素
	 */
	function contains(uint[] memory array,uint target) internal pure returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    for(uint64 i=0;i< array.length;i++){
            if(array[i]==target){
                return true;
            } 
        }
        return false;
	}
	
	/**
	 * 删除指定位置的元素
	 */
	function removeAt (uint[] storage array,uint64 index) internal returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    if(index>=array.length){
	        return false;
	    }
	    for(uint64 i = index;i<array.length-1;i++){
	        array[i]=array[i+1];
	    }
	    array.pop();
	    return true;
	}
	
	/**
	 * 删除一个元素
	 */
	function remove (uint[] storage array ,uint target) internal returns (bool){
	    require(array.length<2**64,"The Array is out of bound.");
	    uint64 index = indexOf(array,target);
	    return removeAt(array,index);
	}
}
