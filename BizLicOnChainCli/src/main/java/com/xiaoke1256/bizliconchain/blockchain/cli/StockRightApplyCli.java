package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Bool;
import org.web3j.abi.datatypes.Type;

import org.web3j.abi.datatypes.Utf8String;


import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
import com.xiaoke1256.bizliconchain.bo.StockRightApply;


@Service
public class StockRightApplyCli extends BaseCli {

	private static final Logger LOG = LoggerFactory.getLogger(StockRightApplyCli.class);
	/**
	 * 合约地址
	 */
	@Value("${contract.applyCtAddr}")
	private String contractAddress;
	
	/**
	 * 获取某企业下有哪些申请
	 * @param uniScId
	 * @param investorCetfHash
	 * @return
	 */
	public List<String> getStockRightApplyKeysByUniScId(String uniScId) {
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		String json;
		try {
			json = baseWeb3j.queryToString(fromAddr, contractAddress, "getStockRightApplyKeysByUniScId", inputParameters);
			if(json==null) {
				return null;
			}
		    return JSON.parseArray(json, String.class);
		} catch (ClassNotFoundException | InterruptedException | ExecutionException e) {
			throw new RuntimeException(e);
		}
	}
	
	public StockRightApply getStockRightApply(String uniScId,String investorCetfHash) {
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(investorCetfHash));
		String json;
		try {
			json = baseWeb3j.queryToString(fromAddr, contractAddress, "getStockRightApply", inputParameters);
		} catch (ClassNotFoundException | InterruptedException | ExecutionException e) {
			throw new RuntimeException(e);
		}
		if(json==null) {
			throw new NullPointerException();
		}
		return JSON.parseObject(json, StockRightApply.class);
	}
	
	public void backUp(String uniScId,String investorCetfHash,boolean isPass,String reason) {
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(investorCetfHash));
		inputParameters.add(new Bool(isPass));
		inputParameters.add(new Utf8String(reason));
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "backUp", gasPrice, gasLimit, inputParameters, uniScId+"_"+investorCetfHash);
	}
}
