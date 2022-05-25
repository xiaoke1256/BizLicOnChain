package com.xiaoke1256.investoradmin.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.web3j.crypto.Hash;

import com.xiaoke1256.investoradmin.blockchain.cli.StockHolderOnChainClient;
import com.xiaoke1256.investoradmin.blockchain.cli.StockRightApplyClient;
import com.xiaoke1256.investoradmin.bo.StockHolder;
import com.xiaoke1256.investoradmin.bo.StockRightApply;
import com.xiaoke1256.investoradmin.bo.StockRightApplyOnChain;
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
	private StockRightApplyClient stockRightApplyCli;
	@Autowired
	private StockHolderOnChainClient stockHolderOnChainCli;
	
	@Value("${biz.uniScId}")
	private String uniScId;
	
	public void startStockTransfer(StockRightApply apply,String ethPrivateKey){
		StockHolder stockHolder = stockHolderDao.getStockHolder(apply.getStockHolderId());
		stockHolder.setEthPrivateKey(ethPrivateKey);
		stockHolder.setUpdateTime(new Timestamp(System.currentTimeMillis()));
		stockHolderDao.updateStockHolder(stockHolder);
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
		String fromAddr = stockHolder.getInvestorAccount();
		String fromPrivateKey = stockHolder.getEthPrivateKey();
		stockRightApplyCli.startStockTransfer(fromAddr,fromPrivateKey,uniScId, stockHolder.getInvestorCetfHash(), apply.getNewInvestorName(), 
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
		List<StockRightApply> applyList = stockRightApplyDao.queryByStockHolderId(stockHolderId);
		for(StockRightApply apply:applyList) {
			apply.setTransferor(stockHolderDao.getStockHolder(apply.getStockHolderId()));
		}
		return applyList;
	}
	
	@Transactional(readOnly=true)
	public List<StockRightApply> queryByStatus(String status){
		List<StockRightApply> applyList = stockRightApplyDao.queryByStatus(status);
		for(StockRightApply apply:applyList) {
			apply.setTransferor(stockHolderDao.getStockHolder(apply.getStockHolderId()));
		}
		return applyList;
	}
	
	public void setNewStockHolderAccount(Long applyId,String newInvestorAccount){
		StockRightApply apply = stockRightApplyDao.getApply(applyId);
		StockHolder stockHolder = stockHolderDao.getStockHolder(apply.getStockHolderId());
		apply.setNewInvestorAccount(null); //一开始不要设置 等后续有反馈了再设置
		apply.setStatus("设置账号-处理中");
		apply.setUpdateTime(new Date());
		stockRightApplyDao.updateApply(apply);
		String fromAddr = stockHolder.getInvestorAccount();
		String fromPrivateKey = stockHolder.getEthPrivateKey();
		stockRightApplyCli.setNewStockHolderAccount(fromAddr,fromPrivateKey,uniScId, apply.getNewInvestorCetfHash(), newInvestorAccount);
	}
	
	public void comfirmByDirectors(Long applyId){
		StockRightApply apply = stockRightApplyDao.getApply(applyId);
		apply.setStatus("董事会确认-处理中");
		apply.setUpdateTime(new Date());
		stockRightApplyDao.updateApply(apply);
		stockRightApplyCli.comfirmByDirectors(uniScId, apply.getNewInvestorCetfHash());
	}
	
	
	public void payForStock(Long applyId,String account,String privateKey){
		StockRightApply apply = stockRightApplyDao.getApply(applyId);
		apply.setStatus("付款-处理中");
		apply.setUpdateTime(new Date());
		stockRightApplyDao.updateApply(apply);
		String hash = stockRightApplyCli.payForStock(uniScId, apply.getNewInvestorCetfHash(), account, privateKey, apply.getPrice());
		apply.setTrasHash(hash);
		apply.setUpdateTime(new Date());
		stockRightApplyDao.updateApply(apply);
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
		StockRightApplyOnChain applyOnChain = stockRightApplyCli.getStockRightApply(uniScId,apply.getNewInvestorCetfHash());
		if("设置账号-处理中".equals(apply.getStatus())) {
			if(StringUtils.isEmpty(apply.getNewInvestorAccount()) && applyOnChain.getInvestorAccount()!=null || !applyOnChain.getInvestorAccount().equals(apply.getNewInvestorAccount())) {
				apply.setNewInvestorAccount(applyOnChain.getInvestorAccount());
				apply.setStatus("待董事会确认");
				apply.setUpdateTime(new Date());
				stockRightApplyDao.updateApply(apply);
			}
		}else if("董事会确认-处理中".equals(apply.getStatus())) {
			if(!"待董事会确认".equals(applyOnChain.getStatus())) {
				apply.setStatus(applyOnChain.getStatus());
				apply.setUpdateTime(new Date());
				stockRightApplyDao.updateApply(apply);
			}
		}else if("付款-处理中".equals(apply.getStatus())) {
			if(!"待付款".equals(applyOnChain.getStatus())) {
				apply.setStatus(applyOnChain.getStatus());
				apply.setUpdateTime(new Date());
				stockRightApplyDao.updateApply(apply);
			}
		}else if("待发证机关备案".equals(apply.getStatus())) {
			if(!"待发证机关备案".equals(applyOnChain.getStatus())) {
				apply.setStatus(applyOnChain.getStatus());
				apply.setUpdateTime(new Date());
				stockRightApplyDao.updateApply(apply);
				if("结束".equals(apply.getStatus())) {
					//不管是成功还是失败股权都会发生变化
					//处理新股东
					StockHolder newStockHolder = stockHolderOnChainCli.getStockHolder(uniScId, apply.getNewInvestorCetfHash());
					if(newStockHolder!=null && !StringUtils.isEmpty(newStockHolder.getInvestorCetfHash())) {
						StockHolder orgNewStockHolder = stockHolderDao.getStockHolderByInvestorCetfHash(apply.getNewInvestorCetfHash());
						if(orgNewStockHolder==null) {//新股东不存在
							newStockHolder.setInsertTime(new Timestamp(System.currentTimeMillis()));
							newStockHolder.setUpdateTime(new Timestamp(System.currentTimeMillis()));
							stockHolderDao.saveStockHolder(orgNewStockHolder);
						}else {
							//应该只有额度变化
							orgNewStockHolder.setCptAmt(newStockHolder.getCptAmt());
							orgNewStockHolder.setUpdateTime(new Timestamp(System.currentTimeMillis()));
							stockHolderDao.updateStockHolder(orgNewStockHolder);
						}
					}
					//处理旧股东
					StockHolder oldStockHolder = stockHolderOnChainCli.getStockHolder(uniScId, apply.getTransferorCetfHash());
					StockHolder orgOldStockHolder = stockHolderDao.getStockHolderByInvestorCetfHash(apply.getTransferorCetfHash());
					if(oldStockHolder==null || StringUtils.isEmpty(oldStockHolder.getInvestorCetfHash())) {
						//说明股份完全转让给了新股东
						stockHolderDao.deleteById(orgOldStockHolder.getStockHolderId());
					}else {
						orgOldStockHolder.setCptAmt(oldStockHolder.getCptAmt());
						orgOldStockHolder.setUpdateTime(new Timestamp(System.currentTimeMillis()));
						stockHolderDao.updateStockHolder(orgOldStockHolder);
					}
				}
				
			}
		}
	}
}
