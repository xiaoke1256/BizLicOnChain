package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.SignatureException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.xiaoke1256.bizliconchain.blockchain.common.client.BaseCli;
import com.xiaoke1256.bizliconchain.bo.Bizlic;
import com.xiaoke1256.bizliconchain.common.encrypt.ECDSASecp256k1;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

@Service
public class BizLicOnChainCli extends BaseCli {
	
	private static final Logger LOG = LoggerFactory.getLogger(BizLicOnChainCli.class);
	 
	private PrivateKey privateKey;
	
	@Autowired
	private IBaseWeb3j baseWeb3j;
	
	/**
	 * 合约地址
	 */
	@Value("${contract.ctAddr}")
	private String contractAddress;
	
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
		inputParameters.add(new Utf8String(bizlic.getOrganCode()));
		String licContent = JSON.toJSONString(bizlic,SerializerFeature.WriteDateUseDateFormat);
		inputParameters.add(new Utf8String(licContent)); 
		LOG.info("bizlic:"+licContent);
		try {
			//sign 工商局做的电子签名
			inputParameters.add(new Utf8String(new String(ECDSASecp256k1.signature(privateKey, licContent.getBytes("UTF-8")))));
		} catch (InvalidKeyException | NoSuchAlgorithmException | SignatureException | UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "putLic", gasPrice, gasLimit, inputParameters,bizlic.getUniScId() );
	}
	
	/**
	 * 获取营业执照的内容
	 * @return
	 */
	public Bizlic getLicContent(String uniScId) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		String json;
		try {
			json = baseWeb3j.queryToString(fromAddr, contractAddress, "getLicContent", inputParameters);
		} catch (InterruptedException | ExecutionException | ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
		return JSON.parseObject(json, Bizlic.class);
	}
	
	/**
	 * 获取所有的企业的统一社会信用码。（此方法不要轻易调用，因为有数据量有百万规模）
	 * @return
	 */
	public List<String> getAllUniScIds(){
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		String json;
		try {
			json = baseWeb3j.queryToString(fromAddr, contractAddress, "getAllUniScIds", inputParameters);
		} catch (InterruptedException | ExecutionException | ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
		return JSON.parseArray(json, String.class);
	}
	
	/**
	 * 删除一个营业执照
	 * @param uniScId
	 */
	public void removeLic(String uniScId) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "removeLic", gasPrice, gasLimit, inputParameters,uniScId);
	}
}
