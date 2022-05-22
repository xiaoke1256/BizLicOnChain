package com.xiaoke1256.bizliconchain.blockchain.common.client.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.web3j.abi.datatypes.Type;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.PARAMETER})
public @interface ParamType {
	Class<? extends Type<?>> value();
}
