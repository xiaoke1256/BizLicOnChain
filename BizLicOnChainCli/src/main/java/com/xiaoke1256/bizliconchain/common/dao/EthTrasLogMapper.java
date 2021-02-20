package com.xiaoke1256.bizliconchain.common.dao;

import org.springframework.stereotype.Repository;

import com.xiaoke1256.bizliconchain.common.bo.EthTrasLog;


@Repository
public interface EthTrasLogMapper {
	public EthTrasLog getEthTrasLog(Integer logId);
	
	public void saveLog(EthTrasLog log);
	
	public void updateLog(EthTrasLog log);
}
