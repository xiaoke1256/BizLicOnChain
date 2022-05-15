package com.xiaoke1256.investoradmin.service;

import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;

import com.xiaoke1256.investoradmin.bo.StockRightApply;

/**
 * 定时任务，用于监视申请的状态变化
 * @author TangJun
 *
 */
@Service
public class StockRightApplyStatusTask {
	
	static Web3j web3j;
	
    @Value("${contract.url}")
    private String URL;
	
    @PostConstruct
    public void init() {
    	web3j = Web3j.build(new HttpService(URL));
    }
	
	@Autowired
	private StockRightApplyService stockRightApplyService;
	
	@Scheduled(cron = "0/20 * * * * ?")
	public void dealStatusChange() {
		List<StockRightApply> applys = stockRightApplyService.queryAwaitApply();
		for(StockRightApply apply:applys) {
			stockRightApplyService.dealStatusChange(apply);
		}
	}
	
	//看看是否被市场监督局审批通过了
	public void dealAicAudit() {
		List<StockRightApply> applys = stockRightApplyService.queryByStatus("待发证机关备案");
		for(StockRightApply apply:applys) {
			stockRightApplyService.dealStatusChange(apply);
		}
	}
	
}
