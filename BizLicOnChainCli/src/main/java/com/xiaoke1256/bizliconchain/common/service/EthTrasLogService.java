package com.xiaoke1256.bizliconchain.common.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xiaoke1256.bizliconchain.common.dao.EthTrasLogMapper;

@Service
@Transactional
public class EthTrasLogService {
	private EthTrasLogMapper ethTrasLogMapper;
}
