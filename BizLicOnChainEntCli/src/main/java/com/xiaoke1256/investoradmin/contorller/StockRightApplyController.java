package com.xiaoke1256.investoradmin.contorller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.common.exception.BizException;
import com.xiaoke1256.investoradmin.bo.StockRightApply;
import com.xiaoke1256.investoradmin.service.StockRightApplyService;

@RequestMapping(value = "/stockHolder/apply")
@RestController
public class StockRightApplyController {
	@Autowired
	private StockRightApplyService stockRightApplyService;
	
	/**
	 * 发起股权转让流程
	 * @param apply
	 * @return
	 */
	@PostMapping(value = "stockTransfer/start")
	public Boolean startStockTransfer(StockRightApply apply) {
		if(apply.getStockHolderId()==null) {
			throw new BizException("未登录");
		}
		stockRightApplyService.startStockTransfer(apply);
		return true;
	}
	
	@GetMapping()
	public List<StockRightApply> queryByStockHolderId(@RequestParam("stockHolderId")String strStockHolderId){
		if("admin".equalsIgnoreCase(strStockHolderId)) {
			return stockRightApplyService.queryAll();
		}else if("temp".equalsIgnoreCase(strStockHolderId)) {
			return stockRightApplyService.queryByStatus("待付款");
		}else if(strStockHolderId!=null) {
			return stockRightApplyService.queryByStockHolderId(Long.parseLong(strStockHolderId));
		}else {
			return new ArrayList<>();
		}
		
	}
	
	/**
	 * 设置新股东账号
	 * @param applyId
	 * @param newInvestorAccount
	 * @return
	 */
	@PostMapping(value ="stockTransfer/{applyId}/setAddress")
	public Boolean setNewStockHolderAccount(@PathVariable("applyId") Long applyId,@RequestParam("newInvestorAccount") String newInvestorAccount){
		stockRightApplyService.setNewStockHolderAccount(applyId, newInvestorAccount);
		return true;
	}
	
	/**
	 * 董事会确认
	 * @param applyId
	 * @param newInvestorAccount
	 * @return
	 */
	@PostMapping(value ="stockTransfer/{applyId}/comfirmByDirectors")
	public Boolean comfirmByDirectors(@PathVariable("applyId") Long applyId){
		stockRightApplyService.comfirmByDirectors(applyId);
		return true;
	}
	
	/**
	 * 支付
	 * @param applyId
	 */
	@PostMapping(value ="stockTransfer/{applyId}/payForStock")
	public Boolean payForStock(@PathVariable("applyId") Long applyId,String account, String privateKey){
		stockRightApplyService.payForStock(applyId, account, privateKey);
		return true;
	}
}
