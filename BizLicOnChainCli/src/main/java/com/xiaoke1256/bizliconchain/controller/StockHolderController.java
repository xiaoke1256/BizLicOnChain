package com.xiaoke1256.bizliconchain.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.blockchain.cli.StockHolderOnChainCli;
import com.xiaoke1256.bizliconchain.bo.StockHolder;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RequestMapping("/")
@RestController
public class StockHolderController {
	@Autowired
	private StockHolderOnChainCli stockHolderOnChainCli;
	
	/**
	 * 新增或修改一个股东
	 */
	@RequestMapping(value = "/bizlic/stockHolder", method =RequestMethod.POST)
	public RespMsg putStockHolder(@RequestBody StockHolder stockHolder) {
		//organCode 需要有 organCode 为参数
		try {
			stockHolderOnChainCli.sendStockHolder(stockHolder);
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
			return new RespMsg("00","Success!",stockHolders);
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
}
