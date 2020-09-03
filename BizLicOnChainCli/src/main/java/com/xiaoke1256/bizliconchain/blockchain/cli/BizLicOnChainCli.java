package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.SignatureException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.bo.Bizlic;
import com.xiaoke1256.bizliconchain.common.encrypt.ECDSASecp256k1;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

@Service
public class BizLicOnChainCli {
	
	private static final Logger LOG = LoggerFactory.getLogger(BizLicOnChainCli.class);
	 
	private PrivateKey privateKey;
	
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
	
	@PostConstruct
	public void init() {
		try {
			privateKey = ECDSASecp256k1.loadECPrivateKey(this.getClass().getResourceAsStream("/com/xiaoke1256/bizliconchain/security/keys/ecdsa/private_key.der"));
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 提交一个营业执照
	 * @param uniScId
	 * @param organCode
	 * @param licContent 
	 * @param sign 电子签名
	 */
	public void sendLic(Bizlic bizlic) {
		
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(bizlic.getUniScId()));
		inputParameters.add(new Utf8String(bizlic.getIssueOrgan()));
		String licContent = JSON.toJSONString(bizlic);
		inputParameters.add(new Utf8String(licContent)); 
		LOG.info("bizlic:"+licContent);
		try {
			//sign 工商局做的电子签名
			inputParameters.add(new Utf8String(new String(ECDSASecp256k1.signature(privateKey, licContent.getBytes("UTF-8")))));
		} catch (InvalidKeyException | NoSuchAlgorithmException | SignatureException | UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "putLic", gasPrice, gasLimit, inputParameters );
	}
	
}
