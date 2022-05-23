package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.util.List;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;
import com.xiaoke1256.bizliconchain.bo.StockRightApply;

@EthClient(contractAddress="${contract.applyCtAddr}")
public interface StockRightApplyClient {
	/**
	 * 获取某企业下有哪些申请
	 * @param uniScId
	 * @param investorCetfHash
	 * @return
	 */
	public List<String> getStockRightApplyKeysByUniScId(String uniScId);
	
	public StockRightApply getStockRightApply(String uniScId,String investorCetfHash);
	
	public void backUp(String uniScId,String investorCetfHash,boolean isPass,String reason);
}
