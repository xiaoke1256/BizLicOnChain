package com.xiaoke1256.investoradmin.blockchain.cli;

import java.math.BigInteger;

import org.web3j.abi.datatypes.Address;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.FromAddr;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.FromPrivateKey;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ParamType;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.Price;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ReadOnly;
import com.xiaoke1256.investoradmin.bo.StockHolder;
import com.xiaoke1256.investoradmin.bo.StockRightApplyOnChain;

@EthClient("${contract.ctAddr}")
public interface StockRightApplyClient {
	public void startStockTransfer(@FromAddr String fromAddr,@FromPrivateKey String fromPrivateKey,
			String uniScId,String transferorCetfHash,String investorName,String investorCetfHash,byte[] merkel,BigInteger cptAmt,BigInteger price);
	
	public void setNewStockHolderAccount(@FromAddr String fromAddr,@FromPrivateKey String fromPrivateKey, 
			String uniScId,String investorCetfHash,@ParamType(Address.class)String investorAccount);
	
	public void comfirmByDirectors(String uniScId,String investorCetfHash);
	
	public String payForStock(String uniScId,String investorCetfHash,@FromAddr String account,@FromPrivateKey String privateKey,@Price BigInteger price);
	
	@ReadOnly
	public StockRightApplyOnChain getStockRightApply(String uniScId,String investorCetfHash);
}
