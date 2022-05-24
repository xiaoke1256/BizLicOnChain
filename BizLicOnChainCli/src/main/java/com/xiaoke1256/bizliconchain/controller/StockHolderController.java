package com.xiaoke1256.bizliconchain.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.web3j.crypto.Hash;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.cli.StockHolderOnChainClient;
import com.xiaoke1256.bizliconchain.bo.StockHolder;
import com.xiaoke1256.bizliconchain.bo.StockRightItem;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RequestMapping("/")
@RestController
public class StockHolderController {
	@Autowired
	private StockHolderOnChainClient stockHolderOnChainCli;
	
	/**
	 * 新增或修改一个股东
	 */
	@RequestMapping(value = "/bizlic/stockHolder", method =RequestMethod.POST)
	public RespMsg putStockHolder(@RequestBody StockHolder stockHolder) {
		//organCode 需要有 organCode 为参数
		try {
			stockHolderOnChainCli.putStockHolder(stockHolder.getUniScId(),Hash.sha3String(stockHolder.getInvestorCetfType()+":"+stockHolder.getInvestorCetfNo()),
					stockHolder.getInvestorName(),JSON.toJSONString(stockHolder.getStockRightItems()),stockHolder.getCptAmt());
			return new RespMsg("00","Success!");
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
	/**
	 * 查某个企业下的所有股东
	 * @param uniScId
	 * @return
	 */
	@RequestMapping(value = "/bizlic/{uniScId}/stockHolder", method =RequestMethod.GET)
	public RespMsg getStockHolders(@PathVariable("uniScId") String uniScId) {
		try {
			List<StockHolder> stockHolders = stockHolderOnChainCli.getStockHolders(uniScId);
			for(StockHolder stockHolder:stockHolders) {
				String itemJson = stockHolder.getStockRightDetail();
				if(itemJson!=null && !"".equals(itemJson.trim())) {
					List<StockRightItem> items = JSON.parseArray(itemJson, StockRightItem.class);
					stockHolder.setStockRightItems(items);
					stockHolder.setStockRightDetail(null);
				}
			}
			return new RespMsg("00","Success!",stockHolders);
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
	/**
	 * 设置某股东的账号
	 * @param uniScId
	 * @return
	 */
	@RequestMapping(value = "/bizlic/{uniScId}/stockHolder/{investorCetfHash}", method =RequestMethod.POST)
	public RespMsg getStockHolders(@PathVariable("uniScId") String uniScId,@PathVariable("investorCetfHash")String investorCetfHash,String investorAccount) {
		try {
			stockHolderOnChainCli.putStockHolderAccount(uniScId, investorCetfHash, investorAccount);
			return new RespMsg("00","Success!");
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
}
