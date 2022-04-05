package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionMessage.ItemsBuilder;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Uint;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.crypto.Hash;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
import com.xiaoke1256.bizliconchain.bo.StockHolder;
import com.xiaoke1256.bizliconchain.bo.StockRightItem;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

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
	 * 注册一个股东
	 * @param stockHolder
	 */
	public void sendStockHolder(StockHolder stockHolder) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		LOG.debug("stockHolder.getUniScId():"+stockHolder.getUniScId());
		LOG.debug("stockHolder.getInvestorCetfType()+\":\"+stockHolder.getInvestorCetfNo()  :"+stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo());
		LOG.debug("Hash.sha3String(stockHolder.getInvestorCetfType()+\":\"+stockHolder.getInvestorCetfNo())  :"+Hash.sha3String(stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo()));
		LOG.debug("stockHolder.getInvestorName():"+stockHolder.getInvestorName());
		LOG.debug("JSON.toJSONString(stockHolder.getStockRightItems()):"+JSON.toJSONString(stockHolder.getStockRightItems()));
		LOG.debug("stockHolder.getCptAmt():"+stockHolder.getCptAmt());
		inputParameters.add(new Utf8String(stockHolder.getUniScId()));
		inputParameters.add(new Utf8String(Hash.sha3String(stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo())));
		inputParameters.add(new Utf8String(stockHolder.getInvestorName()));
		inputParameters.add(new Utf8String(JSON.toJSONString(stockHolder.getStockRightItems())));
		inputParameters.add(new Uint(stockHolder.getCptAmt()));
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "putStockHolder", gasPrice, gasLimit, inputParameters,stockHolder.getUniScId()+"-"+stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo() );
	}
	
	/**
	 * 查一家企业下的所有股东
	 * @param uniScId
	 * @return
	 */
	public List<StockHolder> getStockHolders(String uniScId) {
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
		for(StockHolder stockHolder:stockHolders) {
			String itemJson = stockHolder.getStockRightDetail();
			List<StockRightItem> items = JSON.parseArray(itemJson, StockRightItem.class);
			stockHolder.setStockRightItems(items);
			stockHolder.setStockRightDetail(null);
		}
		return stockHolders;
	}

}
