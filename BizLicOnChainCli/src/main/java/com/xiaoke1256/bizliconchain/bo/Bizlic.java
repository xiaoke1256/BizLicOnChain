package com.xiaoke1256.bizliconchain.bo;

import java.math.BigDecimal;
import java.util.Date;

public class Bizlic {
	private String uniScId;
	private String corpName;
	private String leadName;
	private String indsyCode;
	private String bizScope;
	private BigDecimal regCpt;
	private Date provDate;
	private Date limitTo;
	private String organCode;
	private String issueOrgan;
	private String otherInfo;
	public String getUniScId() {
		return uniScId;
	}
	public void setUniScId(String uniScId) {
		this.uniScId = uniScId;
	}
	public String getCorpName() {
		return corpName;
	}
	public void setCorpName(String corpName) {
		this.corpName = corpName;
	}
	public String getLeadName() {
		return leadName;
	}
	public void setLeadName(String leadName) {
		this.leadName = leadName;
	}
	public String getIndsyCode() {
		return indsyCode;
	}
	public void setIndsyCode(String indsyCode) {
		this.indsyCode = indsyCode;
	}
	public String getBizScope() {
		return bizScope;
	}
	public void setBizScope(String bizScope) {
		this.bizScope = bizScope;
	}
	public BigDecimal getRegCpt() {
		return regCpt;
	}
	public void setRegCpt(BigDecimal regCpt) {
		this.regCpt = regCpt;
	}
	public Date getProvDate() {
		return provDate;
	}
	public void setProvDate(Date provDate) {
		this.provDate = provDate;
	}
	public Date getLimitTo() {
		return limitTo;
	}
	public void setLimitTo(Date limitTo) {
		this.limitTo = limitTo;
	}
	public String getOrganCode() {
		return organCode;
	}
	public void setOrganCode(String organCode) {
		this.organCode = organCode;
	}
	public String getIssueOrgan() {
		return issueOrgan;
	}
	public void setIssueOrgan(String issueOrgan) {
		this.issueOrgan = issueOrgan;
	}
	public String getOtherInfo() {
		return otherInfo;
	}
	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}
	
}
