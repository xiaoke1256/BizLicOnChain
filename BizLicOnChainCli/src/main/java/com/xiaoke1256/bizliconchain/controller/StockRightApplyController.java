package com.xiaoke1256.bizliconchain.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.blockchain.cli.StockHolderOnChainCli;
import com.xiaoke1256.bizliconchain.blockchain.cli.StockRightApplyCli;
import com.xiaoke1256.bizliconchain.bo.StockHolder;
import com.xiaoke1256.bizliconchain.bo.StockRightApply;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;


@RequestMapping("/")
@RestController
public class StockRightApplyController {
	
	@Autowired
	private StockRightApplyCli stockRightApplyCli;
	
	@Autowired
	private StockHolderOnChainCli stockHolderOnChainCli;
	
	@RequestMapping(value = "/bizlic/apply/{uniScId}", method =RequestMethod.GET)
	public RespMsg queryApplies(@PathVariable("uniScId") String uniScId){
		try {
			List<String> investorCetfHashs = stockRightApplyCli.getStockRightApplyKeysByUniScId(uniScId);
			List<StockRightApply> result = new ArrayList<>();
			for (String investorCetfHash:investorCetfHashs) {
				StockRightApply apply = stockRightApplyCli.getStockRightApply(uniScId, investorCetfHash);
				List<StockHolder> stockHolders = stockHolderOnChainCli.getStockHolders(uniScId);
				for(StockHolder stockHolder:stockHolders) {
					if(apply.getTransferorCetfHash().equals(stockHolder.getInvestorCetfHash())) {
						apply.setTransferor(stockHolder);
						break;
					}
				}
				result.add(apply);
			}
			return new RespMsg("00","Success!",result);
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
	@RequestMapping(value = "/bizlic/apply/{uniScId}/{investorCetfHash}/backUp", method =RequestMethod.POST)
	public RespMsg backUp(@PathVariable("uniScId")String uniScId,@PathVariable("investorCetfHash")String investorCetfHash,boolean isPass,String reason) {
		try {
			stockRightApplyCli.backUp(uniScId, investorCetfHash, isPass, reason);
			return new RespMsg("00","Success!");
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
}