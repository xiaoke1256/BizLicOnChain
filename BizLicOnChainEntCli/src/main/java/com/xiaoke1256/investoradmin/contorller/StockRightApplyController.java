package com.xiaoke1256.investoradmin.contorller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.common.exception.BizException;
import com.xiaoke1256.investoradmin.bo.StockRightApply;
import com.xiaoke1256.investoradmin.service.StockRightApplyService;

@RequestMapping(value = "/stockHolder/apply")
@RestController
public class StockRightApplyController {
	@Autowired
	private StockRightApplyService stockRightApplyService;
	
	
	@PostMapping(value = "stockTransfer/start")
	public Boolean startStockTransfer(StockRightApply apply) {
		if(apply.getStockHolderId()==null) {
			throw new BizException("未登录");
		}
		stockRightApplyService.startStockTransfer(apply);
		return true;
	}
	
	@GetMapping()
	public List<StockRightApply> queryByStockHolderId(Long stockHolderId){
		return stockRightApplyService.queryByStockHolderId(stockHolderId);
	}
}
