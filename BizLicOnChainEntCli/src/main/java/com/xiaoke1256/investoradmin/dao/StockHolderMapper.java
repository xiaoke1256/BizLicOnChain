package com.xiaoke1256.investoradmin.dao;

import org.springframework.stereotype.Repository;

import com.xiaoke1256.investoradmin.bo.StockHolder;

@Repository
public interface StockHolderMapper {
	StockHolder getStockHolder(Long stockHolderId);
	void saveStockHolder(StockHolder stockHolder);
	void updateStockHolder(StockHolder stockHolder);
}
