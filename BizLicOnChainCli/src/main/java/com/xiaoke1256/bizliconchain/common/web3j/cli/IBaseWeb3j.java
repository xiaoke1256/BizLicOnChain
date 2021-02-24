package com.xiaoke1256.bizliconchain.common.web3j.cli;

import org.web3j.abi.datatypes.Type;

import java.math.BigInteger;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * @Datetime: 2020/6/23   10:35
 * @Author: Xia rong tao
 * @title
 */

public interface IBaseWeb3j {

    /**
     * 执行合约打包
     *
     * @param fromAddr        支付地址
     * @param fromPrivateKey  支付地址私钥
     * @param contractAddress         合约地址
     * @param method           合约方法
     * @param gasPrice        旷工费用
     * @param inputParameters 方法参数
     * @return hash
     */
    public String transact(String fromAddr, String fromPrivateKey, String contractAddress, String method, BigInteger gasPrice, BigInteger gasLimit, List<Type> inputParameters,String bizKey);

    /**
     * 调用合约（进行检查）
     */
    public String transactWithCheck(String fromAddr, String fromPrivateKey, String contractAddress, String method, BigInteger gasPrice, BigInteger gasLimit, List<Type> inputParameters,String bizKey);
    
    /**
     * 用Call的方式调用合约。（目的是查询）
     * @param from
     * @param contractAddress
     * @param method
     * @param inputParameters
     * @return
     * @throws ExecutionException 
     * @throws InterruptedException 
     * @throws ClassNotFoundException 
     */
    public String queryToString(String from, String contractAddress, String method,List<Type> inputParameters) throws InterruptedException, ExecutionException, ClassNotFoundException;
}

