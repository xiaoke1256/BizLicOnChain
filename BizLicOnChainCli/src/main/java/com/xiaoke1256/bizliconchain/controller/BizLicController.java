package com.xiaoke1256.bizliconchain.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.blockchain.cli.BizLicOnChainCli;
import com.xiaoke1256.bizliconchain.bo.Bizlic;

@RequestMapping("/")
@RestController
public class BizLicController {
	
	@Autowired
	private BizLicOnChainCli bizLicOnChainCli;
	
	/**
	 * 新增或修改一个营业职照
	 */
	@RequestMapping(value = "/bizlic", method =RequestMethod.PUT)
	public void putBizlic(Bizlic bizlic) {
		//organCode 需要有 organCode 为参数
		bizLicOnChainCli.sendLic(bizlic);
	}
	
}
