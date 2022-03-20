package com.xiaoke1256.bizliconchain.blockchain.cli;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
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
	
	public void sendStockHolder() {
		
	}

}
