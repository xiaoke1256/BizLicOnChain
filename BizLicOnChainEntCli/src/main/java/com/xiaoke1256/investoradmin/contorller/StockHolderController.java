package com.xiaoke1256.investoradmin.contorller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.investoradmin.bo.StockHolder;
import com.xiaoke1256.investoradmin.service.StockHolderService;

@RequestMapping(value = "/stockHolder")
@RestController
public class StockHolderController {
	@Autowired
	private StockHolderService stockHolderService;
	
	@GetMapping(value = "all")
	public List<StockHolder> queryAll(){
		return stockHolderService.queryAll();
	}
}
