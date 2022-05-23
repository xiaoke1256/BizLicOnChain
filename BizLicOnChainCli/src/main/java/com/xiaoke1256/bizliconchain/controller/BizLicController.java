package com.xiaoke1256.bizliconchain.controller;

import java.security.PrivateKey;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.xiaoke1256.bizliconchain.blockchain.cli.BizLicOnChainClient;
import com.xiaoke1256.bizliconchain.bo.Bizlic;
import com.xiaoke1256.bizliconchain.common.encrypt.ECDSASecp256k1;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RequestMapping("/")
@RestController
public class BizLicController {
	
	@Autowired
	private BizLicOnChainClient bizLicOnChainCli;
	private PrivateKey privateKey;
	
	@PostConstruct
	public void init() {
		try {
			privateKey = ECDSASecp256k1.loadECPrivateKey(this.getClass().getResourceAsStream("/com/xiaoke1256/bizliconchain/security/keys/ecdsa/private_key.der"));
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 新增或修改一个营业职照
	 */
	@RequestMapping(value = "/bizlic", method =RequestMethod.POST)
	public RespMsg putBizlic(Bizlic bizlic) {
		//organCode 需要有 organCode 为参数
		try {
			String licContent = JSON.toJSONString(bizlic,SerializerFeature.WriteDateUseDateFormat);
			String sign = new String(ECDSASecp256k1.signature(privateKey, licContent.getBytes("UTF-8")));
			bizLicOnChainCli.putLic(bizlic.getUniScId(), bizlic.getOrganCode(), licContent, sign);
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
	
	@RequestMapping(value = "/removeBizlic", method =RequestMethod.POST)
	public RespMsg removeLic(String uniScId) {
		try {
			bizLicOnChainCli.removeLic(uniScId);
			return new RespMsg("00","Success!",uniScId);
		}catch(Exception e) {
			e.printStackTrace();
			return new RespMsg("99",e.getMessage());
		}
	}
	
}
