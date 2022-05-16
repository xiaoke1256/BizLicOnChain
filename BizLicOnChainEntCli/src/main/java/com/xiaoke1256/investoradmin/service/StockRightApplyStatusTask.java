package com.xiaoke1256.investoradmin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.xiaoke1256.investoradmin.bo.StockRightApply;

/**
 * 定时任务，用于监视申请的状态变化
 * @author TangJun
 *
 */
@Service
public class StockRightApplyStatusTask {
	
	@Autowired
	private StockRightApplyService stockRightApplyService;
	
	@Scheduled(cron = "1/20 * * * * ?")
	public void dealStatusChange() {
		List<StockRightApply> applys = stockRightApplyService.queryAwaitApply();
		for(StockRightApply apply:applys) {
			stockRightApplyService.dealStatusChange(apply);
		}
	}
	
	//看看是否被市场监督局审批通过了
	@Scheduled(cron = "5/20 * * * * ?")
	public void dealAicAudit() {
		List<StockRightApply> applys = stockRightApplyService.queryByStatus("待发证机关备案");
		for(StockRightApply apply:applys) {
			stockRightApplyService.dealStatusChange(apply);
		}
	}
	
}
