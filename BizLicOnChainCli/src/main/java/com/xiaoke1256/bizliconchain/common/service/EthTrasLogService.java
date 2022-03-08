package com.xiaoke1256.bizliconchain.common.service;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xiaoke1256.bizliconchain.common.bo.EthTrasLog;
import com.xiaoke1256.bizliconchain.common.bo.EthTrasLogSearchCondition;
import com.xiaoke1256.bizliconchain.common.dao.EthTrasLogMapper;

@Service
@Transactional
public class EthTrasLogService {
	 /**
     * 本系统自定义的STATUS(S:成功;C:已提交;E:错误)
     */
	public static final String STATUS_SUCCESS = "S";
	public static final String STATUS_COMMITED = "C";
	public static final String STATUS_ERROR = "E";
	
	@Autowired
	private EthTrasLogMapper ethTrasLogMapper;
	
	@Transactional(readOnly=true)
	public EthTrasLog getEthTrasLog(Integer logId) {
		return ethTrasLogMapper.getEthTrasLog(logId);
	}
	
	public void saveLog(EthTrasLog log) {
		ethTrasLogMapper.saveLog(log);
	}
	
	public EthTrasLog saveLog(String nonce,String contractAddress,String method,String bizKey,String trasHash,BigInteger gasPrice,BigInteger gasLimit) {
		EthTrasLog log = new EthTrasLog();
		log.setNonce(nonce);
		log.setContractAddress(contractAddress);
		log.setMethod(method);
		log.setBizKey(bizKey);
		log.setTrasHash(trasHash);
		log.setStatus(STATUS_COMMITED);
		log.setGasPrice(gasPrice);
		log.setGasLimit(gasLimit);
		Timestamp now = new Timestamp(System.currentTimeMillis());
		log.setInsertTime(now);
		log.setUpdateTime(now);
		ethTrasLogMapper.saveLog(log);
		return log;
	}
	
	public void updateLog(EthTrasLog log) {
		log.setUpdateTime(new Timestamp(System.currentTimeMillis()));
		ethTrasLogMapper.updateLog(log);
	}
	
	@Transactional(readOnly=true)
	public List<EthTrasLog> searchLog(EthTrasLogSearchCondition condition){
		if(condition.getPageNo()<=0) {
			condition.setPageNo(1);
		}
		if(condition.getPageSize()<=0) {
			condition.setPageSize(10);
		}
		Integer total = ethTrasLogMapper.countLog(condition);
		condition.setTotal(total);
		int firstIndex = (condition.getPageNo()-1)*condition.getPageSize();
		return ethTrasLogMapper.searchLog(condition,firstIndex,condition.getPageSize());
	}
	
	public void modifyError(EthTrasLog log,String errMsg) {
		log.setStatus(STATUS_ERROR);
		log.setErrMsg(errMsg);
		log.setFinishTime(new Timestamp(System.currentTimeMillis()));
		log.setUpdateTime(new Timestamp(System.currentTimeMillis()));
		ethTrasLogMapper.updateLog(log);
	}
	
	@Transactional(readOnly=true)
	public List<EthTrasLog> queryUnFeedback(){
		return ethTrasLogMapper.queryUnFeedback();
	}
}
