package com.xiaoke1256.bizliconchain.common.dao;

import org.springframework.stereotype.Repository;

import com.xiaoke1256.bizliconchain.common.bo.Log;


@Repository
public interface LogMapper {
	public Log sel(Integer id);
}
