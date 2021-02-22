package com.xiaoke1256.bizliconchain.common.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.common.bo.EthTrasLog;
import com.xiaoke1256.bizliconchain.common.bo.EthTrasLogSearchCondition;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;
import com.xiaoke1256.bizliconchain.common.service.EthTrasLogService;

@RequestMapping("/ethLogs")
@RestController
public class EthTrasLogController {
	@Autowired
	private EthTrasLogService ethTrasLogService;
	
	@RequestMapping(value="/search", method = {RequestMethod.POST,RequestMethod.GET})
	public RespMsg searchLogs(EthTrasLogSearchCondition condition) {
		List<EthTrasLog> result = ethTrasLogService.searchLog(condition);
		return new RespMsg("00","Success!",result);
	}
}
