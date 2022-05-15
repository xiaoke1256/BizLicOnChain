package com.xiaoke1256.investoradmin.bo;

import java.math.BigDecimal;

/**
 * 应用
 * @author TangJun
 *
 */
public class StockRightApplyOnChain {
	private String uniScId;//统一社会信用码
	private String transferorCetfHash;//出让方身份证件的Hash值
	private String investorName;//新股东姓名
	private BigDecimal price;//价格（以太币,wei）
	private String investorAccount;//新股东账号
	private String investorCetfHash;//新股东身份证件信息
	private String stockRightDetail;//股权详情
	private String merkel;//默克尔值（新股东姓名、新股东身份证件、转让份额三者加起来的默克尔值）
	private BigDecimal cptAmt;//转让额度
	private String isSuccess;//是否交易成功'0'否'1'是
	private String status;//状态 “开始”、“待董事会确认”，“待付款”，“发证机关备案”，“结束”（成功或失败）。
	private String failReason; //失败原因
	public String getUniScId() {
		return uniScId;
	}
	public void setUniScId(String uniScId) {
		this.uniScId = uniScId;
	}
	public String getTransferorCetfHash() {
		return transferorCetfHash;
	}
	public void setTransferorCetfHash(String transferorCetfHash) {
		this.transferorCetfHash = transferorCetfHash;
	}
	public String getInvestorName() {
		return investorName;
	}
	public void setInvestorName(String investorName) {
		this.investorName = investorName;
	}
	public BigDecimal getPrice() {
		return price;
	}
	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	public String getInvestorAccount() {
		return investorAccount;
	}
	public void setInvestorAccount(String investorAccount) {
		this.investorAccount = investorAccount;
	}
	public String getInvestorCetfHash() {
		return investorCetfHash;
	}
	public void setInvestorCetfHash(String investorCetfHash) {
		this.investorCetfHash = investorCetfHash;
	}
	public String getStockRightDetail() {
		return stockRightDetail;
	}
	public void setStockRightDetail(String stockRightDetail) {
		this.stockRightDetail = stockRightDetail;
	}
	public String getMerkel() {
		return merkel;
	}
	public void setMerkel(String merkel) {
		this.merkel = merkel;
	}
	public BigDecimal getCptAmt() {
		return cptAmt;
	}
	public void setCptAmt(BigDecimal cptAmt) {
		this.cptAmt = cptAmt;
	}
	public String getIsSuccess() {
		return isSuccess;
	}
	public void setIsSuccess(String isSuccess) {
		this.isSuccess = isSuccess;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getFailReason() {
		return failReason;
	}
	public void setFailReason(String failReason) {
		this.failReason = failReason;
	}
	
}
