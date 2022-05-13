package com.xiaoke1256.bizliconchain.bo;

import java.math.BigInteger;
import java.util.Date;

public class StockRightApply {
	private Long applyId;
	private Long stockHolderId;
	private String transferorCetfHash;
	private BigInteger price;
	private BigInteger cptAmt;
	private String investorName;
	private String investorAccount;
	private String merkel;
	private String investorCetfHash;
	private String trasHash;
	private String isArchived;
	private String status;
	private Date insertTime;
	private Date updateTime;
	/**出让方*/
	private StockHolder transferor;
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
	public String getInvestorName() {
		return investorName;
	}
	public void setInvestorName(String investorName) {
		this.investorName = investorName;
	}
	public String getInvestorAccount() {
		return investorAccount;
	}
	public void setInvestorAccount(String investorAccount) {
		this.investorAccount = investorAccount;
	}
	public String getMerkel() {
		return merkel;
	}
	public void setMerkel(String merkel) {
		this.merkel = merkel;
	}
	public String getInvestorCetfHash() {
		return investorCetfHash;
	}
	public void setInvestorCetfHash(String investorCetfHash) {
		this.investorCetfHash = investorCetfHash;
	}
	public String getTrasHash() {
		return trasHash;
	}
	public void setTrasHash(String trasHash) {
		this.trasHash = trasHash;
	}
	public String getIsArchived() {
		return isArchived;
	}
	public void setIsArchived(String isArchived) {
		this.isArchived = isArchived;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public StockHolder getTransferor() {
		return transferor;
	}
	public void setTransferor(StockHolder transferor) {
		this.transferor = transferor;
	}
	
}
