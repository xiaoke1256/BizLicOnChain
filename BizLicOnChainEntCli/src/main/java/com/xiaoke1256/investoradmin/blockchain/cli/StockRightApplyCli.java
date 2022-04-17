package com.xiaoke1256.investoradmin.blockchain.cli;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Uint;
import org.web3j.abi.datatypes.Utf8String;

import com.xiaoke1256.bizliconchain.blockchain.common.BaseCli;
import com.xiaoke1256.investoradmin.bo.StockHolder;

@Service
public class StockRightApplyCli extends BaseCli {

	/**
	 * 合约地址
	 */
	@Value("${contract.ctAddr}")
	private String contractAddress;

	public void startStockTransfer(String uniScId,StockHolder transferor,String investorName,String investorCetfHash,String merkel,BigInteger cptAmt,BigInteger price) {
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		inputParameters.add(new Utf8String(uniScId));
		inputParameters.add(new Utf8String(transferor.getInvestorCetfHash()));
		inputParameters.add(new Utf8String(investorName));
		inputParameters.add(new Utf8String(investorCetfHash));
		inputParameters.add(new Utf8String(merkel)); 
		inputParameters.add(new Uint(cptAmt)); 
		inputParameters.add(new Uint(price));
		String fromAddr = transferor.getEthAccount();
		String fromPrivateKey = transferor.getEthPrivateKey();
		baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress, "startStockTransfer", gasPrice, gasLimit, inputParameters,uniScId+"_"+transferor.getInvestorCetfHash()+"_"+investorCetfHash );
	}
}
