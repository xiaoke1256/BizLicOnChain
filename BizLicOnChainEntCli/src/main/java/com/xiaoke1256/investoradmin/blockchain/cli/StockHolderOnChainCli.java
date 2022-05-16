package com.xiaoke1256.investoradmin.blockchain.cli;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;
import com.xiaoke1256.investoradmin.bo.StockHolder;

@Service
public class StockHolderOnChainCli extends BaseCli {
	
	private static final Logger LOG = LoggerFactory.getLogger(StockHolderOnChainCli.class);
	
	@Autowired
	private IBaseWeb3j baseWeb3j;
	
	/**
	 * 合约地址
	 */
	@Value("${contract.stockCtAddr}")
	private String contractAddress;
	
	/**
	 * 查一家企业下的所有股东
	 * @param uniScId
	 * @return
	 */
	public List<StockHolder> getStockHolders(String uniScId) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		String resultJson = null;
		try {
			resultJson = baseWeb3j.queryToString(fromAddr, contractAddress, "getStockHolders", inputParameters);
			LOG.info("resultJson:"+resultJson);
		} catch (ClassNotFoundException | InterruptedException | ExecutionException e) {
			throw new RuntimeException(e);
		}
		List<StockHolder> stockHolders = JSON.parseArray(resultJson, StockHolder.class);
		return stockHolders;
	}
	
	public StockHolder getStockHolder(String uniScId,String investorCetfHash){
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(investorCetfHash));
		String resultJson = null;
		try {
			resultJson = baseWeb3j.queryToString(fromAddr, contractAddress, "getStockHolder", inputParameters);
			LOG.info("resultJson:"+resultJson);
		} catch (ClassNotFoundException | InterruptedException | ExecutionException e) {
			throw new RuntimeException(e);
		}
		StockHolder stockHolder = JSON.parseObject(resultJson, StockHolder.class);
		return stockHolder;
	}
}
