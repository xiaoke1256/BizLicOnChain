package com.xiaoke1256.bizliconchain.common.util;

import java.math.BigInteger;

/**
 * 十六进制工具类
 */
public class HexUtil {
	 /**
     * 解析16进制的字符串
     * @param s
     * @return
     */
    public static BigInteger parse(String s) {
    	String nus = "0123456789abcdef";
    	if(s==null) {
    		throw new NullPointerException();
    	}
    	BigInteger result = BigInteger.ZERO;
    	s = s.toLowerCase();
    	if(s.startsWith("0x")) {
    		s = s.substring(2);
    	}
    	for(int i = 0; i<s.length();i++) {
    		char nu = s.charAt(s.length()-i-1);
    		for(int j = 0;j<nus.length();j++) {
    			if(nus.charAt(j)==nu) {
    				
    				result = result.add(BigInteger.valueOf((long)(j*Math.pow(16,i))));
    				break;
    			}
    		}
    	}
    	return result;
    }
}
