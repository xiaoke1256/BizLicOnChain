package com.xiaoke1256.investoradmin.blockchain.cli;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Uint;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.abi.datatypes.generated.Bytes32;
import org.web3j.protocol.websocket.events.LogNotification;

import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
import com.xiaoke1256.investoradmin.bo.StockHolder;

import io.reactivex.functions.Consumer;

@Service
public class StockRightApplyCli extends BaseCli {

	private static final Logger LOG = LoggerFactory.getLogger(StockRightApplyCli.class);
	/**
	 * 合约地址
	 */
	@Value("${contract.ctAddr}")
	private String contractAddress;
	
	@Value("${biz.uniScId}")
	private String uniScId;
	
    /**
     * 注册事件监听
     * @deprecated http 应用不支持注册。
     * @param contractAddress
     * @param topic 类似 "ApplyStatusChange(string,string,string)"
     * @param onSuccess
     * @param onError
     */
    public void subscript(String topic ,Consumer<LogNotification> onSuccess,Consumer<Throwable> onError) {
    	baseWeb3j.subscript(contractAddress, topic, onSuccess, onError);
    }

	public void startStockTransfer(String uniScId,StockHolder transferor,String investorName,String investorCetfHash,byte[] merkel,BigInteger cptAmt,BigInteger price) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(transferor.getInvestorCetfHash()));
		inputParameters.add(new Utf8String(investorName));
		inputParameters.add(new Utf8String(investorCetfHash));
		inputParameters.add(new Bytes32(merkel)); 
		inputParameters.add(new Uint(cptAmt)); 
		inputParameters.add(new Uint(price));
		String fromAddr = transferor.getEthAccount();
		String fromPrivateKey = transferor.getEthPrivateKey();
		LOG.info("uniScId:"+uniScId);
		LOG.info("transferor.getInvestorCetfHash():"+transferor.getInvestorCetfHash());
		LOG.info("investorName:"+investorName);
		LOG.info("investorCetfHash:"+investorCetfHash);
		LOG.info("merkel:"+merkel);
		LOG.info("price:"+price);
		LOG.info("fromAddr:"+fromAddr);
		LOG.info("fromPrivateKey:"+fromPrivateKey);
		if(StringUtils.isEmpty(fromAddr) || StringUtils.isEmpty(fromPrivateKey) ) {
			throw new RuntimeException("请先设置以太坊账号和密钥。");
		}
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "startStockTransfer", gasPrice, gasLimit, inputParameters,uniScId+"_"+transferor.getInvestorCetfHash()+"_"+investorCetfHash );
	}
	
	/**
	 * 设置股东账号
	 */
	public void setNewStockHolderAccount(String uniScId,StockHolder transferor,String investorCetfHash,String investorAccount) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(investorCetfHash));
		inputParameters.add(new Address(investorAccount));
		String fromAddr = transferor.getEthAccount();
		String fromPrivateKey = transferor.getEthPrivateKey();
		if(StringUtils.isEmpty(fromAddr) || StringUtils.isEmpty(fromPrivateKey) ) {
			throw new RuntimeException("请先设置出让方以太坊账号和密钥。");
		}
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "setNewStockHolderAccount", gasPrice, gasLimit, inputParameters,uniScId+"_"+transferor.getInvestorCetfHash()+"_"+investorCetfHash );
	}
	
}
