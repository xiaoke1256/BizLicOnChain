package com.xiaoke1256.bizliconchain.bo;

import java.math.BigInteger;
import java.util.List;

/**
 * 股东表
 * @author TangJun
 *
 */
public class StockHolder {
	/** 所在企业的统一社会信用码*/
	private String uniScId;
//	/** 股东编号（股东编号和统一社会信用码两个字段可以唯一定位一个股东。） */
//	private String investorNo;	
	/** 股东姓名 */
	private String investorName;	
	/** 股东账号 */
	private String investorAccount;	
	/**  */
	private String investorCetfType;
	
	private String investorCetfNo;
	
	/**
	 * 股东身份证件,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）
	 * 和证件号码组成，由冒号(:)分隔。
	 * 本字段需要加密，区块链中仅保存其Hash值。
	 */
	private String investorCetfHash;
	
	/**
	 * 股权详情。json方式给出，描述出资方式和份额。举例如下：“[{invtType:'货币',amt:200000},{invtType:'知识产权',amt:100000}]”。
	 */
	private String stockRightDetail;
	
	/**
	 * 股权详情。举例如下：“[{invtType:'货币',amt:200000},{invtType:'知识产权',amt:100000}]”。
	 */
	private List<StockRightItem> stockRightItems;
	
	/**
	 * 股东姓名、股东账号、股东身份证件三者加起来的默克尔值;
	 */
	private String merkel;	
	/**
	 * 出资额度（人民币元）
	 */
	private BigInteger cptAmt;
	public String getUniScId() {
		return uniScId;
	}
	public void setUniScId(String uniScId) {
		this.uniScId = uniScId;
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
	public String getInvestorCetfHash() {
		return investorCetfHash;
	}
	public void setInvestorCetfHash(String investorCetfHash) {
		this.investorCetfHash = investorCetfHash;
	}
	public List<StockRightItem> getStockRightItems() {
		return stockRightItems;
	}
	public void setStockRightItems(List<StockRightItem> stockRightItems) {
		this.stockRightItems = stockRightItems;
	}
	public String getMerkel() {
		return merkel;
	}
	public void setMerkel(String merkel) {
		this.merkel = merkel;
	}
	public BigInteger getCptAmt() {
		return cptAmt;
	}
	public void setCptAmt(BigInteger cptAmt) {
		this.cptAmt = cptAmt;
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
	public String getStockRightDetail() {
		return stockRightDetail;
	}
	public void setStockRightDetail(String stockRightDetail) {
		this.stockRightDetail = stockRightDetail;
	}	
	
	
}
