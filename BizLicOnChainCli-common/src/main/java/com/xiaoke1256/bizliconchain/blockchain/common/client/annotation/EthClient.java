package com.xiaoke1256.bizliconchain.blockchain.common.client.annotation;

import java.lang.annotation.*;

import org.springframework.stereotype.Component;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Component
public @interface EthClient {
	/** 发起交易的账号地址 */
	String fromAddr() default "${contract.sendAddr}";
	/** 发起交易的账号的私钥 */
	String fromPrivateKey() default "${contract.sendAddrPk}";
	/** 合约地址 */
	String contractAddress() default "${contract.ctAddr}";
}
