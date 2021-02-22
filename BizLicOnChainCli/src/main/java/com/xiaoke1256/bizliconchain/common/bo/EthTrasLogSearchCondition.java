package com.xiaoke1256.bizliconchain.common.bo;

public class EthTrasLogSearchCondition {
    private String nonce;
    private String contractAddress;
    private String method;
    private String bizKey;
    private String trasHash;
    private String trasStatus;
    private String status;
    private String errMsg;
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
	public String getErrMsg() {
		return errMsg;
	}
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}
    
    
}
