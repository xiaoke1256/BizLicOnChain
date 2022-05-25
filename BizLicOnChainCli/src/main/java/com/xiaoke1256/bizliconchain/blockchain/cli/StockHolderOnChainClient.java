package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.math.BigInteger;
import java.util.List;

import org.web3j.abi.datatypes.Address;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ParamType;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ReadOnly;
import com.xiaoke1256.bizliconchain.bo.StockHolder;

@EthClient("${contract.stockCtAddr}")
public interface StockHolderOnChainClient {
	public void putStockHolder(String uniScId,String investorCetfHash,String investorName,String stockRightDetail,BigInteger cptAmt);
	
	@ReadOnly
	public List<StockHolder> getStockHolders(String uniScId);
	
	public void putStockHolderAccount(String uniScId,String investorCetfHash,@ParamType(Address.class)String investorAccount);
	
	@ReadOnly
	public StockHolder getStockHolder(String uniScId,String investorCetfHash);
	
}
