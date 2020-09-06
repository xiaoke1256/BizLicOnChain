package com.xiaoke1256.bizliconchain.common.mvc;

public class RespMsg {
	private String code;
	private String msg;
	
	public RespMsg(String code, String msg) {
		super();
		this.code = code;
		this.msg = msg;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	
}
