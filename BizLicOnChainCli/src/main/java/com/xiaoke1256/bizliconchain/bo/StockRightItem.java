package com.xiaoke1256.bizliconchain.bo;

/**
 * 股权明细，即著作权占多少，货币占多少
 * @author TangJun
 *
 */
public class StockRightItem {
	private String invtType;
	private Integer amt;
	public String getInvtType() {
		return invtType;
	}
	public void setInvtType(String invtType) {
		this.invtType = invtType;
	}
	public Integer getAmt() {
		return amt;
	}
	public void setAmt(Integer amt) {
		this.amt = amt;
	}
	
}
