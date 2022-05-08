package com.xiaoke1256.investoradmin.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
	
	private static final Logger LOG = LoggerFactory.getLogger(StockRightApplyService.class);
	
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
		apply.setStatus("待董事会确认");
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
		
		LOG.info("已提交");
	}
	
	/**
	 * 查全部
	 * @return
	 */
	@Transactional(readOnly=true)
	public List<StockRightApply> queryAll(){
		List<StockRightApply> applyList = stockRightApplyDao.queryAll();
		for(StockRightApply apply:applyList) {
			apply.setTransferor(stockHolderDao.getStockHolder(apply.getStockHolderId()));
		}
		return applyList;
	}
	
	/**
	 * 按股东查
	 * @param stockHolderId
	 * @return
	 */
	@Transactional(readOnly=true)
	public List<StockRightApply> queryByStockHolderId(Long stockHolderId){
		List<StockRightApply> applyList =  stockRightApplyDao.queryByStockHolderId(stockHolderId);
		for(StockRightApply apply:applyList) {
			apply.setTransferor(stockHolderDao.getStockHolder(apply.getStockHolderId()));
		}
		return applyList;
	}
	
	public void setNewStockHolderAccount(Long applyId,String newInvestorAccount){
		StockRightApply apply = stockRightApplyDao.getApply(applyId);
		StockHolder stockHolder = stockHolderDao.getStockHolder(apply.getStockHolderId());
		apply.setNewInvestorAccount(newInvestorAccount);
		apply.setStatus("设置账号-处理中");
		apply.setUpdateTime(new Date());
		stockRightApplyDao.updateApply(apply);
		stockRightApplyCli.setNewStockHolderAccount(uniScId, stockHolder, apply.getNewInvestorCetfHash(), newInvestorAccount);
	}
	
	public void comfirmByDirectors(Long applyId){
		StockRightApply apply = stockRightApplyDao.getApply(applyId);
		apply.setStatus("董事会确认-处理中");
		apply.setUpdateTime(new Date());
		stockRightApplyDao.updateApply(apply);
		stockRightApplyCli.comfirmByDirectors(uniScId, apply.getNewInvestorCetfHash());
	}
	
	/**
	 * 查待处理的申请
	 * @return
	 */
	@Transactional(readOnly=true)
	public List<StockRightApply> queryAwaitApply(){
		return stockRightApplyDao.queryAwait();
	}
	
	/**
	 * 处理状态变更
	 * @param apply
	 */
	public void dealStatusChange(StockRightApply apply) {
		StockRightApply applyOnChain = stockRightApplyCli.getStockRightApply(uniScId,apply.getNewInvestorCetfHash());
		if("设置账号-处理中".equals(apply.getStatus())) {
			if(apply.getNewInvestorAccount()==null && applyOnChain.getNewInvestorAccount()!=null || !applyOnChain.getNewInvestorAccount().equals(apply.getNewInvestorAccount())) {
				apply.setNewInvestorAccount(applyOnChain.getNewInvestorAccount());
				apply.setStatus("待董事会确认");
				apply.setUpdateTime(new Date());
				stockRightApplyDao.updateApply(apply);
			}
		}
		if("董事会确认-处理中".equals(apply.getStatus())) {
			if(!"待董事会确认".equals(applyOnChain.getStatus())) {
				apply.setStatus(applyOnChain.getStatus());
				apply.setUpdateTime(new Date());
				stockRightApplyDao.updateApply(apply);
			}
		}
	}
}
