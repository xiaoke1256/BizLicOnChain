package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.bo.Bizlic;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

@Service
public class BizLicOnChainCli {
	
	@Autowired
	private IBaseWeb3j baseWeb3j;
	
	/**
	 * from地址
	 */
	@Value("${contract.sendAddr}")
	private String fromAddr;
	
	/**
	 * from地址私钥
	 */
	@Value("${contract.sendAddrPk}")
	private String fromPrivateKey;
	
	/**
	 * 合约地址
	 */
	@Value("${contract.ctAddr}")
	private String contractAddress;

	/**
	 * gas价格
	 */
	@Value("${contract.gasPrice}")
	private BigInteger gasPrice;
	 
	/**
	 * gas限额
	 */
	@Value("${contract.gasLimit}")
	private BigInteger gasLimit;
	
	/**
	 * 提交一个营业执照
	 * @param uniScId
	 * @param organCode
	 * @param licContent 
	 * @param sign 电子签名
	 */
	public void sendLic(Bizlic bizlic) {
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(bizlic.getUniScId()));
		inputParameters.add(new Utf8String(bizlic.getIssueOrgan()));
		inputParameters.add(new Utf8String(JSON.toJSONString(bizlic))); 
		inputParameters.add(new Utf8String(""));//sign 工商局做的电子签名
		baseWeb3j.transact(fromAddr, fromPrivateKey, contractAddress, "putLic", gasPrice, gasLimit, inputParameters );
	}
	
}
