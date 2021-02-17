package com.xiaoke1256.bizliconchain.common.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.common.dao.LogMapper;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RestController
public class H2TestController {
	@Autowired
	private LogMapper logMapper;
	
	@RequestMapping(value = "/testBd", method =RequestMethod.GET)
	public RespMsg testDb() {
		logMapper.sel(1);
		return new RespMsg("00","success");
		
	}
}
