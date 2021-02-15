package com.xiaoke1256.bizliconchain.common.controller;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RestController
public class H2TestController {
	
	@PersistenceContext(unitName="default")
	private EntityManager entityManager ;
	
	@RequestMapping(value = "/testBd", method =RequestMethod.GET)
	public RespMsg testDb() {
		return new RespMsg("00","success");
		
	}
}
