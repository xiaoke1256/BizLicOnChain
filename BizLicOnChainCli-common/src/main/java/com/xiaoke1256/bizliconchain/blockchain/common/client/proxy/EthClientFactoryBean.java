package com.xiaoke1256.bizliconchain.blockchain.common.client.proxy;

import java.lang.reflect.Array;
import java.lang.reflect.Proxy;

import org.springframework.beans.factory.SmartFactoryBean;
import org.springframework.util.Assert;

public class EthClientFactoryBean<T> implements SmartFactoryBean<T> {
    private Class<T> ethClientInterface;

    public EthClientFactoryBean(Class<T> ethClientInterface) {
        this.ethClientInterface = ethClientInterface;
    }

    @SuppressWarnings("unchecked")
	public T getObject() {
        this.checkBeanIsInterface();
		Class<T>[] classes = (Class<T>[]) Array.newInstance(ethClientInterface.getClass(), 1);
        classes[0] = ethClientInterface;
        return (T) Proxy.newProxyInstance(this.ethClientInterface.getClassLoader(), classes, new EthClientHandler());
    }

    private void checkBeanIsInterface() {
        Assert.isTrue(this.ethClientInterface.isInterface(), "@EthClient 只能作用在接口类型上！");
    }

    public boolean isSingleton() {
        return false;
    }

    public boolean isPrototype() {
        return true;
    }

    public Class<T> getObjectType() {
        return this.ethClientInterface;
    }


	@Override
	public boolean isEagerInit() {
		return false;
	}
}