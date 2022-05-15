package com.xiaoke1256.investoradmin.form;

import java.math.BigInteger;

public class StockRightApplyForm {
	private Long stockHolderId;
	private BigInteger cptAmt;
	private BigInteger price;
	private String newInvestorName;
	private String newInvestorCetfType;
	private String newInvestorCetfNo;
	private String ethPrivateKey;
	public Long getStockHolderId() {
		return stockHolderId;
	}
	public void setStockHolderId(Long stockHolderId) {
		this.stockHolderId = stockHolderId;
	}
	public BigInteger getCptAmt() {
		return cptAmt;
	}
	public void setCptAmt(BigInteger cptAmt) {
		this.cptAmt = cptAmt;
	}
	public BigInteger getPrice() {
		return price;
	}
	public void setPrice(BigInteger price) {
		this.price = price;
	}
	public String getNewInvestorName() {
		return newInvestorName;
	}
	public void setNewInvestorName(String newInvestorName) {
		this.newInvestorName = newInvestorName;
	}
	public String getNewInvestorCetfType() {
		return newInvestorCetfType;
	}
	public void setNewInvestorCetfType(String newInvestorCetfType) {
		this.newInvestorCetfType = newInvestorCetfType;
	}
	public String getNewInvestorCetfNo() {
		return newInvestorCetfNo;
	}
	public void setNewInvestorCetfNo(String newInvestorCetfNo) {
		this.newInvestorCetfNo = newInvestorCetfNo;
	}
	public String getEthPrivateKey() {
		return ethPrivateKey;
	}
	public void setEthPrivateKey(String ethPrivateKey) {
		this.ethPrivateKey = ethPrivateKey;
	}
	
}
