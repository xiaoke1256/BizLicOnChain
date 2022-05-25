package com.xiaoke1256.bizliconchain.controller;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.cli.StockHolderOnChainClient;
import com.xiaoke1256.bizliconchain.blockchain.cli.StockRightApplyClient;
import com.xiaoke1256.bizliconchain.bo.StockHolder;
import com.xiaoke1256.bizliconchain.bo.StockRightApply;
import com.xiaoke1256.bizliconchain.bo.StockRightItem;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;


@RequestMapping("/")
@RestController
public class StockRightApplyController {
	
	@Autowired
	private StockRightApplyClient stockRightApplyCli;
	
	@Autowired
	private StockHolderOnChainClient stockHolderOnChainCli;
	
	@RequestMapping(value = "/bizlic/apply/{uniScId}", method =RequestMethod.GET)
	public RespMsg queryApplies(@PathVariable("uniScId") String uniScId){
		try {
			List<StockRightApply> applys = stockRightApplyCli.getStockRightApplysByUniScId(uniScId);
			for (StockRightApply apply:applys) {
				StockHolder stockHolder = stockHolderOnChainCli.getStockHolder(uniScId, apply.getTransferorCetfHash());
				if(stockHolder!=null && StringUtils.isNotEmpty(stockHolder.getInvestorCetfHash())) {
					apply.setTransferor(stockHolder);
				}
				String itemJson = stockHolder.getStockRightDetail();
				if(itemJson!=null && "".equals(itemJson.trim())) {
					List<StockRightItem> items = JSON.parseArray(itemJson, StockRightItem.class);
					stockHolder.setStockRightItems(items);
					stockHolder.setStockRightDetail(null);
				}
			}
			return new RespMsg("00","Success!",applys);
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
