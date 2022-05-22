package com.xiaoke1256.bizliconchain.blockchain.common.client.proxy;

import java.lang.reflect.Array;
import java.lang.reflect.Proxy;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.SmartFactoryBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.util.Assert;

import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

public class EthClientFactoryBean<T> implements SmartFactoryBean<T>,ApplicationContextAware {
    private Class<T> ethClientInterface;
    private ApplicationContext ac;

    public EthClientFactoryBean(Class<T> ethClientInterface) {
        this.ethClientInterface = ethClientInterface;
    }

    @SuppressWarnings("unchecked")
	public T getObject() {
        this.checkBeanIsInterface();
		Class<T>[] classes = (Class<T>[]) Array.newInstance(ethClientInterface.getClass(), 1);
        classes[0] = ethClientInterface;
        IBaseWeb3j baseWeb3j = ac.getBean(IBaseWeb3j.class);
        String fromAddr = ac.getEnvironment().resolvePlaceholders("${contract.sendAddr}");
        String contractAddress = ac.getEnvironment().resolvePlaceholders("${contract.ctAddr}");
        return (T) Proxy.newProxyInstance(this.ethClientInterface.getClassLoader(), classes, new EthClientHandler(baseWeb3j,fromAddr,contractAddress));
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
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.ac = applicationContext;
		
	}

	@Override
	public boolean isEagerInit() {
		return false;
	}
}