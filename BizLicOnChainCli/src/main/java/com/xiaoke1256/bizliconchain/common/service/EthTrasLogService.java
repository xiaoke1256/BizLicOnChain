package com.xiaoke1256.bizliconchain.common.service;

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
	@Autowired
	private EthTrasLogMapper ethTrasLogMapper;
	
	@Transactional(readOnly=true)
	public EthTrasLog getEthTrasLog(Integer logId) {
		return ethTrasLogMapper.getEthTrasLog(logId);
	}
	
	public void saveLog(EthTrasLog log) {
		ethTrasLogMapper.saveLog(log);
	}
	
	public void updateLog(EthTrasLog log) {
		ethTrasLogMapper.updateLog(log);
	}
	
	@Transactional(readOnly=true)
	public List<EthTrasLog> searchLog(EthTrasLogSearchCondition condition){
		return ethTrasLogMapper.searchLog(condition);
	}
}
