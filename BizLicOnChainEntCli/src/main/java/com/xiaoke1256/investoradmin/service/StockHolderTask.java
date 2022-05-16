package com.xiaoke1256.investoradmin.service;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.xiaoke1256.investoradmin.blockchain.cli.StockHolderOnChainCli;
import com.xiaoke1256.investoradmin.bo.StockHolder;
import com.xiaoke1256.investoradmin.dao.StockHolderMapper;

@Service
public class StockHolderTask {
	
	@Autowired
	private StockHolderOnChainCli stockHolderOnChainCli;
	
	@Autowired
	private StockHolderMapper stockHolderDao;
	
	@Value("${biz.uniScId}")
	private String uniScId;
	
	/**
	 * 从区块链上检测是否有新股东
	 */
	@Scheduled(cron = "10/20 * * * * ?")
	public void detectNewStockHoder() {
		List<StockHolder> stockHoders = stockHolderOnChainCli.getStockHolders(uniScId);
		for(StockHolder stockHoder:stockHoders) {
			StockHolder stockHoderInDb = stockHolderDao.getStockHolderByInvestorCetfHash(stockHoder.getInvestorCetfHash());
			if (stockHoderInDb == null) {
				//新增
				stockHoderInDb = new StockHolder();
				stockHoderInDb.setInvestorCetfHash(stockHoder.getInvestorCetfHash());
				stockHoderInDb.setEthAccount(stockHoder.getEthAccount());
				stockHoderInDb.setEthPrivateKey(stockHoder.getEthPrivateKey());
				stockHoderInDb.setCptAmt(stockHoder.getCptAmt());
				stockHoderInDb.setInsertTime(new Timestamp(System.currentTimeMillis()));
				stockHoderInDb.setUpdateTime(new Timestamp(System.currentTimeMillis()));
				stockHolderDao.saveStockHolder(stockHoderInDb);
			}else {
				//修改 (增减资造成的变化，以及设置账号造成的变化)
				boolean needModify = false;
				if(!stockHoderInDb.getCptAmt().equals(stockHoder.getCptAmt())) {
					needModify = true;
					stockHoderInDb.setCptAmt(stockHoder.getCptAmt());
				}
				if(stockHoder.getEthAccount()!=null && !stockHoder.getEthAccount().equals(stockHoderInDb.getEthAccount())) {
					needModify = true;
					stockHoderInDb.setEthAccount(stockHoder.getEthAccount());
				}
				if(needModify) {
					stockHoderInDb.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					stockHolderDao.updateStockHolder(stockHoderInDb);
				}
			}
		}
	}
}
