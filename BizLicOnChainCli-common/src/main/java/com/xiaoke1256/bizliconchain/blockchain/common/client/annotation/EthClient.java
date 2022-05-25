package com.xiaoke1256.bizliconchain.blockchain.common.client.annotation;

import java.lang.annotation.*;

import org.springframework.core.annotation.AliasFor;
import org.springframework.stereotype.Component;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Component
public @interface EthClient {
	@AliasFor("contractAddress")
	String value() default "${contract.ctAddr}";
	
	/** 合约地址 */
	@AliasFor("value")
	String contractAddress() default "${contract.ctAddr}";
	
	/** 发起交易的账号地址 */
	String fromAddr() default "${contract.sendAddr}";
	/** 发起交易的账号的私钥 */
	String fromPrivateKey() default "${contract.sendAddrPk}";

}
