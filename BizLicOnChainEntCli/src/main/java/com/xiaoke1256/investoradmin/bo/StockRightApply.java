package com.xiaoke1256.investoradmin.bo;

import java.math.BigInteger;
import java.util.Date;

public class StockRightApply {
	private Long applyId;
	private Long stockHolderId;
	private String transferorCetfHash;
	private BigInteger price;
	private BigInteger cptAmt;
	private String newInvestorName;
	private String newInvestorAccount;
	private String newInvestorCetfType;
	private String newInvestorCetfNo;
	private String newInvestorCetfHash;
	private String isArchived;
	private Date insertTime;
	private Date updateTime;
	public Long getApplyId() {
		return applyId;
	}
	public void setApplyId(Long applyId) {
		this.applyId = applyId;
	}
	public Long getStockHolderId() {
		return stockHolderId;
	}
	public void setStockHolderId(Long stockHolderId) {
		this.stockHolderId = stockHolderId;
	}
	public String getTransferorCetfHash() {
		return transferorCetfHash;
	}
	public void setTransferorCetfHash(String transferorCetfHash) {
		this.transferorCetfHash = transferorCetfHash;
	}
	public BigInteger getPrice() {
		return price;
	}
	public void setPrice(BigInteger price) {
		this.price = price;
	}
	public BigInteger getCptAmt() {
		return cptAmt;
	}
	public void setCptAmt(BigInteger cptAmt) {
		this.cptAmt = cptAmt;
	}
	public String getNewInvestorName() {
		return newInvestorName;
	}
	public void setNewInvestorName(String newInvestorName) {
		this.newInvestorName = newInvestorName;
	}
	public String getNewInvestorAccount() {
		return newInvestorAccount;
	}
	public void setNewInvestorAccount(String newInvestorAccount) {
		this.newInvestorAccount = newInvestorAccount;
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
	public String getNewInvestorCetfHash() {
		return newInvestorCetfHash;
	}
	public void setNewInvestorCetfHash(String newInvestorCetfHash) {
		this.newInvestorCetfHash = newInvestorCetfHash;
	}
	public String getIsArchived() {
		return isArchived;
	}
	public void setIsArchived(String isArchived) {
		this.isArchived = isArchived;
	}
	public Date getInsertTime() {
		return insertTime;
	}
	public void setInsertTime(Date insertTime) {
		this.insertTime = insertTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	
	
}
