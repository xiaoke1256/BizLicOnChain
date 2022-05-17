package com.xiaoke1256.investoradmin.bo;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 股东
 * @author TangJun
 *
 */
public class StockHolder {
	private Long stockHolderId;
	/**
	 * 股东名称
	 */
	private String investorName;
	/**
	 * 股东以太坊账号（公钥）
	 */
	private String investorAccount;
	/**
	 * 股东以太坊账号（私钥）（正式做系统时不建议在数据库中保存私钥）
	 */
	private String ethPrivateKey;
	/**
	 * 股东身份证件类型,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）
	 */
	private String investorCetfType;
	/**
	 * 股东身份证件号
	 */
	private String investorCetfNo;
	/**
	 * 股东身份证件,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）;和证件号码组成，由冒号(:)分隔。本字段需要加密
	 */
	private String investorCetfHash;
	/**
	 * 出资额度
	 */
	private BigDecimal cptAmt;
	
	private Timestamp insertTime;
	private Timestamp updateTime;
	public Long getStockHolderId() {
		return stockHolderId;
	}
	public void setStockHolderId(Long stockHolderId) {
		this.stockHolderId = stockHolderId;
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
	public String getEthPrivateKey() {
		return ethPrivateKey;
	}
	public void setEthPrivateKey(String ethPrivateKey) {
		this.ethPrivateKey = ethPrivateKey;
	}
	public String getInvestorCetfType() {
		return investorCetfType;
	}
	public void setInvestorCetfType(String investorCetfType) {
		this.investorCetfType = investorCetfType;
	}
	public String getInvestorCetfNo() {
		return investorCetfNo;
	}
	public void setInvestorCetfNo(String investorCetfNo) {
		this.investorCetfNo = investorCetfNo;
	}
	public String getInvestorCetfHash() {
		return investorCetfHash;
	}
	public void setInvestorCetfHash(String investorCetfHash) {
		this.investorCetfHash = investorCetfHash;
	}
	public BigDecimal getCptAmt() {
		return cptAmt;
	}
	public void setCptAmt(BigDecimal cptAmt) {
		this.cptAmt = cptAmt;
	}
	public Timestamp getInsertTime() {
		return insertTime;
	}
	public void setInsertTime(Timestamp insertTime) {
		this.insertTime = insertTime;
	}
	public Timestamp getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Timestamp updateTime) {
		this.updateTime = updateTime;
	}

}
