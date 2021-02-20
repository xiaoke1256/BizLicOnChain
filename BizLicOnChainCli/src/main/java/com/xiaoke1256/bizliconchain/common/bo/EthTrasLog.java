package com.xiaoke1256.bizliconchain.common.bo;

import java.math.BigDecimal;

public class EthTrasLog {
	private Long logId;
    private String nonce;
    private String contractAddress;
    private String method;
    private String bizKey;
    private String trasHash;
    private String trasStatus;
    private String status;
    private BigDecimal gasPrice;
    private BigDecimal gasUsed;
	public Long getLogId() {
		return logId;
	}
	public void setLogId(Long logId) {
		this.logId = logId;
	}
	public String getNonce() {
		return nonce;
	}
	public void setNonce(String nonce) {
		this.nonce = nonce;
	}
	public String getContractAddress() {
		return contractAddress;
	}
	public void setContractAddress(String contractAddress) {
		this.contractAddress = contractAddress;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public String getBizKey() {
		return bizKey;
	}
	public void setBizKey(String bizKey) {
		this.bizKey = bizKey;
	}
	public String getTrasHash() {
		return trasHash;
	}
	public void setTrasHash(String trasHash) {
		this.trasHash = trasHash;
	}
	public String getTrasStatus() {
		return trasStatus;
	}
	public void setTrasStatus(String trasStatus) {
		this.trasStatus = trasStatus;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public BigDecimal getGasPrice() {
		return gasPrice;
	}
	public void setGasPrice(BigDecimal gasPrice) {
		this.gasPrice = gasPrice;
	}
	public BigDecimal getGasUsed() {
		return gasUsed;
	}
	public void setGasUsed(BigDecimal gasUsed) {
		this.gasUsed = gasUsed;
	}
	

}
