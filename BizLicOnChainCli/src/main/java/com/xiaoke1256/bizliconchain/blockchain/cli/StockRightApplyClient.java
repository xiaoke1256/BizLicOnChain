package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.util.List;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ReadOnly;
import com.xiaoke1256.bizliconchain.bo.StockRightApply;

@EthClient("${contract.applyCtAddr}")
public interface StockRightApplyClient {
	
	@ReadOnly
	public List<StockRightApply> getStockRightApplysByUniScId(String uniScId);
	
	public void backUp(String uniScId,String investorCetfHash,boolean isPass,String reason);
}
