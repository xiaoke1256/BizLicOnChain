package com.xiaoke1256.bizliconchain.blockchain.common.client;

import java.math.BigInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

public class BaseCli {
	@Autowired
	protected IBaseWeb3j baseWeb3j;
	
	/**
	 * from地址
	 */
	@Value("${contract.sendAddr}")
	protected String fromAddr;
	
	/**
	 * from地址私钥
	 */
	@Value("${contract.sendAddrPk}")
	protected String fromPrivateKey;

	/**
	 * gas价格
	 */
	@Value("${contract.gasPrice}")
	protected BigInteger gasPrice;
	 
	/**
	 * gas限额
	 */
	@Value("${contract.gasLimit}")
	protected BigInteger gasLimit;
}
