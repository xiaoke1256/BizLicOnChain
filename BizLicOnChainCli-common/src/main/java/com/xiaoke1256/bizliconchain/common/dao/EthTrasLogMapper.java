package com.xiaoke1256.bizliconchain.common.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.xiaoke1256.bizliconchain.common.bo.EthTrasLog;
import com.xiaoke1256.bizliconchain.common.bo.EthTrasLogSearchCondition;


@Repository
public interface EthTrasLogMapper {
	public EthTrasLog getEthTrasLog(Integer logId);
	
	public void saveLog(EthTrasLog log);
	
	public void updateLog(EthTrasLog log);
	
	public List<EthTrasLog> searchLog(@Param("condition")EthTrasLogSearchCondition searchCondition,@Param("fromIndex") int fromIndex,@Param("pageSize") int pageSize);
	
	public Integer countLog(@Param("condition")EthTrasLogSearchCondition searchCondition);
	
	public List<EthTrasLog> queryUnFeedback();
	
	public EthTrasLog getByTrasHash(String trasHash);
}
