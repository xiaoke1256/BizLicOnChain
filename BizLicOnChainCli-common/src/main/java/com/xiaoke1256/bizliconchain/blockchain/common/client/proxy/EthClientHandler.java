package com.xiaoke1256.bizliconchain.blockchain.common.client.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.lang.reflect.ParameterizedType;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Uint;
import org.web3j.abi.datatypes.Utf8String;

import com.alibaba.fastjson.JSON;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.FromAddr;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.FromPrivateKey;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ParamType;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ReadOnly;
import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

public class EthClientHandler implements InvocationHandler {
	
	private static final Logger LOG = LoggerFactory.getLogger(EthClientHandler.class);
	
	private IBaseWeb3j baseWeb3j;
	private String fromAddr;
	private String fromPrivateKey;
	private String contractAddress;

    public EthClientHandler(IBaseWeb3j baseWeb3j, String fromAddr, String fromPrivateKey, String contractAddress) {
		super();
		this.baseWeb3j = baseWeb3j;
		this.fromAddr = fromAddr;
		this.fromPrivateKey = fromPrivateKey;
		this.contractAddress = contractAddress;
	}

	public Object invoke(Object proxy, Method method, Object[] args) throws Exception {
        if ("toString".equals(method.getName())) {
            return "proxy$" + method.getDeclaringClass();
        } else {
            return this.apiHeadler(method, args);
        }
    }

	private Object apiHeadler(Method method, Object[] args) {
		System.out.print("method:"+method.toGenericString());
		System.out.print("args:"+args.toString());
		String fromAddr = this.fromAddr;
		String fromPrivateKey = this.fromPrivateKey;
		
		@SuppressWarnings("rawtypes")
		List<Type> inputParameters = new ArrayList<Type>();
		StringBuilder bizKeySb = new StringBuilder();
		for(int i = 0;i< method.getParameters().length;i++) {
			Parameter parameter = method.getParameters()[i];
			//先看它是不是地址
			FromAddr fromAddrAnnotation = parameter.getAnnotation(FromAddr.class);
			if(fromAddrAnnotation!=null) {
				fromAddr = (String)args[i];
				continue;
			}
			FromPrivateKey fromPrivateKeyAnnotation = parameter.getAnnotation(FromPrivateKey.class);
			if(fromPrivateKeyAnnotation!=null) {
				fromPrivateKey = (String)args[i];
				continue;
			}
			if(bizKeySb.length()>0) {
				bizKeySb.append("_");
			}
			bizKeySb.append(args[i]==null?"null":args[i].toString());
			ParamType a = parameter.getAnnotation(ParamType.class);
			Class<? extends Type<?>> type = (a==null?null:a.value());
			if(type == null ) {
				if( CharSequence.class.isAssignableFrom(parameter.getType()) || Character.class.equals(parameter.getType()) ) {
					inputParameters.add(new Utf8String((String)args[i]));
				}else if(BigInteger.class.equals(parameter.getType()) || Long.class.equals(parameter.getType()) 
						|| Integer.class.equals(parameter.getType()) || Short.class.equals(parameter.getType()) ) {
					inputParameters.add(new Uint(BigInteger.valueOf(((Number)args[i]).longValue())));
				}else {
					throw new RuntimeException("其他类型未考虑");
				}
			}else {
				if(Utf8String.class.equals(type)) {
					inputParameters.add(new Utf8String((String)args[i]));
				}else if(Address.class.equals(type)) {
					inputParameters.add(new Address((String)args[i]));
				}else if(Uint.class.equals(type)) {
					if(args[i] instanceof BigInteger) {
						inputParameters.add(new Uint((BigInteger)args[i]));
					}else {
						inputParameters.add(new Uint(BigInteger.valueOf(((Number)args[i]).longValue())));
					}
				}else {
					throw new RuntimeException("其他类型未考虑");
				}
			}
		}
		
		ReadOnly readOnly = method.getAnnotation(ReadOnly.class);
		if(readOnly!=null) {
			String resultJson = null;
			try {
				resultJson = baseWeb3j.queryToString(fromAddr, contractAddress, method.getName(), inputParameters);
				LOG.info("resultJson:"+resultJson);
			} catch (ClassNotFoundException | InterruptedException | ExecutionException e) {
				throw new RuntimeException(e);
			}
			if(method.getReturnType().isAssignableFrom(Collection.class)) {
			    java.lang.reflect.Type genericSuperclass = method.getReturnType().getGenericSuperclass();
		        if (genericSuperclass instanceof ParameterizedType){
					ParameterizedType parameterizedType = (ParameterizedType)genericSuperclass;
		            //获得Demo1<String>，<>中的实际类型参数
					java.lang.reflect.Type[] actualTypeArguments = parameterizedType.getActualTypeArguments();
		            //获得参数类型
		            Class<?> clazz = (Class<?>)actualTypeArguments[0];
		            return JSON.parseArray(resultJson, clazz);
			    } else {
			    	throw new RuntimeException("请指明具体的泛型类型。");
			    }
			}else {
				return JSON.parseObject(resultJson, method.getReturnType());
			}
		}else {
			String hash = baseWeb3j.transactWithCheck(fromAddr, fromPrivateKey, contractAddress,  method.getName(), null, null, inputParameters, bizKeySb.toString());
			if(String.class.equals(method.getReturnType()) ) {
				return hash;
			}
			return null; 
		}
	}
}
