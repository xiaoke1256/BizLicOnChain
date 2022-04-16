package com.xiaoke1256.investoradmin.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.xiaoke1256.investoradmin.bo.StockRightApply;

@Repository
public interface StockRightApplyMapper {
	public StockRightApply getApply(Long applyId);
	
	public void saveApply(StockRightApply apply);
	
	public void updateApply(StockRightApply apply);
	
	List<StockRightApply> queryAll();
}