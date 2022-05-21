package com.xiaoke1256.bizliconchain.blockchain.common.client.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.Arrays;

public class EthClientHandler implements InvocationHandler {

    public EthClientHandler() {
    }

    public Object invoke(Object proxy, Method method, Object[] args) throws Exception {
        if ("toString".equals(method.getName())) {
            return "proxy$" + method.getDeclaringClass();
        } else {
            Object body = args.length == 1 ? args[0] : (args.length > 1 ? Arrays.asList(args) : null);
            return this.apiHeadler(method, body);
        }
    }

	private Object apiHeadler(Method method, Object body) {
		System.out.print("method:"+method.toGenericString());
		System.out.print("body:"+body.toString());
		return null;
	}
}
