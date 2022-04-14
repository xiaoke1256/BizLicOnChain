package com.xiaoke1256.investoradmin.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.xiaoke1256.investoradmin.bo.StockHolder;

@Repository
public interface StockHolderMapper {
	StockHolder getStockHolder(Long stockHolderId);
	void saveStockHolder(StockHolder stockHolder);
	void updateStockHolder(StockHolder stockHolder);
	List<StockHolder> queryAll();
}
