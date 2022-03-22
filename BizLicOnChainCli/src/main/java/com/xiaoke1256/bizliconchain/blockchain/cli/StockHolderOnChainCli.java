package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Int;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.crypto.Hash;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
import com.xiaoke1256.bizliconchain.bo.StockHolder;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

@Service
public class StockHolderOnChainCli extends BaseCli {
	
	@Autowired
	private IBaseWeb3j baseWeb3j;
	
	/**
	 * 合约地址
	 */
	@Value("${contract.stockCtAddr}")
	private String contractAddress;
	
	public void sendStockHolder(StockHolder stockHolder) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(stockHolder.getUniScId()));
		inputParameters.add(new Utf8String(Hash.sha3String(stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo())));
		inputParameters.add(new Utf8String(stockHolder.getInvestorName()));
		inputParameters.add(new Utf8String(JSON.toJSONString(stockHolder.getStockRightItems())));
		inputParameters.add(new Int(stockHolder.getCptAmt()));
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "putStockHolder", gasPrice, gasLimit, inputParameters,stockHolder.getUniScId()+"-"+stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo() );
	}

}
