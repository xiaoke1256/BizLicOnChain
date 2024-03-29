package com.xiaoke1256.bizliconchain.common.bo;

import java.math.BigInteger;
import java.sql.Timestamp;

public class EthTrasLog {
	private Long logId;
    private String nonce;
    private String contractAddress;
    private String method;
    private String bizKey;
    private String trasHash;
    private String trasStatus;
    /**
     * 本系统自定义的STATUS(S:成功;C:已提交;E:错误)
     */
    private String status;
    private BigInteger gasPrice;
    private BigInteger gasUsed;
    private BigInteger gasLimit;
    private String errMsg;
    private Timestamp insertTime;
    private Timestamp updateTime;
    private Timestamp finishTime;
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
	public BigInteger getGasPrice() {
		return gasPrice;
	}
	public void setGasPrice(BigInteger gasPrice) {
		this.gasPrice = gasPrice;
	}
	
	public BigInteger getGasLimit() {
		return gasLimit;
	}
	public void setGasLimit(BigInteger gasLimit) {
		this.gasLimit = gasLimit;
	}
	public BigInteger getGasUsed() {
		return gasUsed;
	}
	public void setGasUsed(BigInteger gasUsed) {
		this.gasUsed = gasUsed;
	}
	public String getErrMsg() {
		return errMsg;
	}
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
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
	public Timestamp getFinishTime() {
		return finishTime;
	}
	public void setFinishTime(Timestamp finishTime) {
		this.finishTime = finishTime;
	}
	

}
