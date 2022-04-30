package com.xiaoke1256.investoradmin.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.web3j.crypto.Hash;

import com.xiaoke1256.investoradmin.blockchain.cli.StockRightApplyCli;
import com.xiaoke1256.investoradmin.bo.StockHolder;
import com.xiaoke1256.investoradmin.bo.StockRightApply;
import com.xiaoke1256.investoradmin.dao.StockHolderMapper;
import com.xiaoke1256.investoradmin.dao.StockRightApplyMapper;

@Service
@Transactional
public class StockRightApplyService {
	@Autowired
	private StockRightApplyMapper stockRightApplyDao;
	@Autowired
	private StockHolderMapper stockHolderDao;
	@Autowired
	private StockRightApplyCli stockRightApplyCli;
	@Value("${biz.uniScId}")
	private String uniScId;
	
	public void startStockTransfer(StockRightApply apply){
		StockHolder stockHolder = stockHolderDao.getStockHolder(apply.getStockHolderId());
		apply.setTransferorCetfHash(stockHolder.getInvestorCetfHash());
		apply.setInsertTime(new Date());
		apply.setUpdateTime(new Date());
		apply.setNewInvestorCetfHash(Hash.sha3String(apply.getNewInvestorCetfType()+":"+apply.getNewInvestorCetfNo()));
		stockRightApplyDao.saveApply(apply);
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		try {
			os.write(apply.getNewInvestorName().getBytes(StandardCharsets.UTF_8));
			os.write(apply.getNewInvestorCetfHash().getBytes(StandardCharsets.UTF_8));
			os.write(apply.getCptAmt().toByteArray());
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		byte[] merkel = Hash.sha3(os.toByteArray());
		stockRightApplyCli.startStockTransfer(uniScId, stockHolder, apply.getNewInvestorName(), 
				apply.getNewInvestorCetfHash(), merkel, apply.getCptAmt(), apply.getPrice());
	}
	
	/**
	 * 查全部
	 * @return
	 */
	@Transactional(readOnly=true)
	public List<StockRightApply> queryAll(){
		return stockRightApplyDao.queryAll();
	}
	
	/**
	 * 按股东查
	 * @param stockHolderId
	 * @return
	 */
	@Transactional(readOnly=true)
	public List<StockRightApply> queryByStockHolderId(Long stockHolderId){
		return stockRightApplyDao.queryByStockHolderId(stockHolderId);
	}
}
