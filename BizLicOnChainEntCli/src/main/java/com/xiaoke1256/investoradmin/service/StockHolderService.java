package com.xiaoke1256.investoradmin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xiaoke1256.investoradmin.bo.StockHolder;
import com.xiaoke1256.investoradmin.dao.StockHolderMapper;

@Service
@Transactional
public class StockHolderService {
	
	@Autowired
	private StockHolderMapper stockHolderDao;
	
	/**
	 * 查询所有
	 * @return
	 */
	@Transactional(readOnly=true)
	public List<StockHolder> queryAll() {
		return stockHolderDao.queryAll();
	}
	
	/**
	 * 按主键查询
	 * @param id
	 * @return
	 */
	@Transactional(readOnly=true)
	public StockHolder getById(Long id) {
		return stockHolderDao.getStockHolder(id);
	}
	
}
