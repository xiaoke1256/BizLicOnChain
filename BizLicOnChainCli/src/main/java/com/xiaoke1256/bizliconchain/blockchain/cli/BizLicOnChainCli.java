package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;

import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

public class BizLicOnChainCli {
	
	@Autowired
	private IBaseWeb3j baseWeb3j;
	
	private String fromAddr;
	private String fromPrivateKey;
	private String contractAddress;

	private BigInteger gasPrice;

	private BigInteger gasLimit;
	
	/**
	 * 提交一个营业执照
	 * @param uniScId
	 * @param organCode
	 * @param licContent 
	 * @param sign 电子签名
	 */
	public void sendLic(String uniScId,String organCode,String licContent,String sign) {
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(organCode));
		inputParameters.add(new Utf8String(licContent));
		inputParameters.add(new Utf8String(sign));
		baseWeb3j.transact(fromAddr, fromPrivateKey, contractAddress, "putLic", gasPrice, gasLimit, inputParameters );
	}
	
}
