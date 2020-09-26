package com.xiaoke1256.bizliconchain.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.blockchain.cli.BizLicOnChainCli;
import com.xiaoke1256.bizliconchain.bo.Bizlic;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RequestMapping("/")
@RestController
public class BizLicController {
	
	@Autowired
	private BizLicOnChainCli bizLicOnChainCli;
	
	/**
	 * 新增或修改一个营业职照
	 */
	@RequestMapping(value = "/bizlic", method =RequestMethod.POST)
	public RespMsg putBizlic(Bizlic bizlic) {
		//organCode 需要有 organCode 为参数
		try {
			bizLicOnChainCli.sendLic(bizlic);
			return new RespMsg("00","Success!");
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
	/**
	 * 查询一个营业职照
	 */
	@RequestMapping(value = "/bizlic", method =RequestMethod.GET)
	public RespMsg getBizlic(String uniScId) {
		try {
			Bizlic bizlic = bizLicOnChainCli.getLicContent(uniScId);
			return new RespMsg("00","Success!",bizlic);
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
	/**
	 * 查询所有营业执照的uniScId
	 * @return
	 */
	@RequestMapping(value = "/uniScIds", method =RequestMethod.GET)
	public RespMsg getAllUniScIds() {
		try {
			List<String> uniScIds = bizLicOnChainCli.getAllUniScIds();
			return new RespMsg("00","Success!",uniScIds);
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
}
