package com.xiaoke1256.investoradmin.blockchain.cli;

import java.util.List;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ReadOnly;
import com.xiaoke1256.investoradmin.bo.StockHolder;

@EthClient("${contract.stockCtAddr}")
public interface StockHolderOnChainClient {
	@ReadOnly
	public List<StockHolder> getStockHolders(String uniScId);
	@ReadOnly
	public StockHolder getStockHolder(String uniScId,String investorCetfHash);
}
