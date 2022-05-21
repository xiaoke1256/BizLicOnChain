package com.xiaoke1256.bizliconchain.blockchain.common.client.annotation;

import java.lang.annotation.*;

import org.springframework.stereotype.Component;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Component
public @interface EthClient {
	
}
