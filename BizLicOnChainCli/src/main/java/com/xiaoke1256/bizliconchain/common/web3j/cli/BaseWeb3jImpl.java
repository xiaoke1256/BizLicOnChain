package com.xiaoke1256.bizliconchain.common.web3j.cli;

import com.alibaba.fastjson.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Bool;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.RawTransaction;
import org.web3j.crypto.TransactionEncoder;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.request.Transaction;
import org.web3j.protocol.core.methods.response.EthCall;
import org.web3j.protocol.core.methods.response.EthGetTransactionCount;
import org.web3j.protocol.core.methods.response.EthGetTransactionReceipt;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.http.HttpService;
import org.web3j.utils.Numeric;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @Datetime: 2020/6/23   10:36
 * @Author: Xia rong tao
 * @title
 */

@Component
public class BaseWeb3jImpl implements IBaseWeb3j {

    private static final Logger LOG = LoggerFactory.getLogger(BaseWeb3jImpl.class);


    static Web3j web3j;

    @Value("${contract.url}")
    private   String URL;


    @Value("${contract.addGas}")
    private BigInteger addGas;



    @Value("${contract.isAddGas}")
    private boolean isAddGas;




    public String transact(String fromAddr, String fromPrivateKey, String contractAddress, String method, BigInteger gasPrice, BigInteger gasLimit, List<Type> inputParameters) {
        EthSendTransaction ethSendTransaction = null;
        BigInteger nonce = BigInteger.ZERO;
        String hash = null;
        try {
            if(web3j == null){
                web3j = Web3j.build(new HttpService(URL));
            }
            EthGetTransactionCount ethGetTransactionCount = web3j.ethGetTransactionCount(
                    fromAddr,
                    DefaultBlockParameterName.PENDING
            ).send();
            //根据配置是否开启根据实时市场gas费用，增加指定gas费用，加快打包速率
            if(isAddGas){
                 BigInteger gas  = web3j.ethGasPrice().send().getGasPrice();
                 LOG.info("获取到的gasPrice{}",gas);
                 gasPrice = addGas.add(gas);
            }
            //返回指定地址发生的交易数量。
            nonce =  ethGetTransactionCount.getTransactionCount();
            LOG.info("nonce:"+nonce);
            List<TypeReference<?>> outputParameters = new ArrayList<TypeReference<?>>();
           // TypeReference<Bool> typeReference = new TypeReference<Bool>() {
            //};
            //outputParameters.add(typeReference);
            LOG.info("付给矿工的gasPrice为：{}",gasPrice);
            Function function = new Function(
                    method,
                    inputParameters,
                    outputParameters);
            String encodedFunction = FunctionEncoder.encode(function);
            Credentials credentials = Credentials.create(fromPrivateKey);
            RawTransaction rawTransaction = RawTransaction.createTransaction(nonce, gasPrice, gasLimit, contractAddress,BigInteger.ZERO,
                    encodedFunction);
            byte[] signedMessage = TransactionEncoder.signMessage(rawTransaction, credentials);
            String hexValue = Numeric.toHexString(signedMessage);
            //ethSendTransaction = web3j.ethSendRawTransaction(hexValue).send();
            ethSendTransaction = web3j.ethSendRawTransaction(hexValue).sendAsync().get();
            hash = ethSendTransaction.getTransactionHash();
            LOG.info(JSONObject.toJSONString(ethSendTransaction));
            //看看到底成功了没有
            Thread.sleep(20000);//以太坊平均出块时间是17.16
            EthGetTransactionReceipt ethGetTransactionReceipt = web3j.ethGetTransactionReceipt(hash).sendAsync().get();
            if(ethGetTransactionReceipt.getTransactionReceipt().isPresent()) {
            	String status = ethGetTransactionReceipt.getTransactionReceipt().get().getStatus();
            	BigInteger gasUsed = ethGetTransactionReceipt.getTransactionReceipt().get().getGasUsed();
            	LOG.info("status:"+status);
            	LOG.info("gasUsed:"+gasUsed);
            }
            //看看消耗了多少gas
        } catch (Exception e) {
            if (null != ethSendTransaction) {
            	if(ethSendTransaction.getError()!=null)
            		LOG.info("失败的原因：" + ethSendTransaction.getError().getMessage());
                LOG.info("参数：fromAddr = " + fromAddr);
                LOG.info("参数：month = " + method);
                LOG.info("参数：gasPrice = " + gasPrice);
                LOG.info("参数：gasLimit = " + gasLimit);
                LOG.info("参数：inputParameters = " + JSONObject.toJSONString(inputParameters));
            }
            throw new RuntimeException(e);
        }

        return hash;
    }
    
    /**
     * 用Call的方式调用合约。
     * @param to
     * @param val
     * @param from
     * @param contractAddress
     * @return
     * @throws Exception
     */
    public boolean querryTransfer(String to, BigInteger val, String from, String contractAddress) throws Exception{
        List<Type> inputParameters = new ArrayList<>();
        inputParameters.add(new Address(to));
        inputParameters.add(new Uint256(val));
        Function function = new Function("transfer",
                inputParameters,
                Collections.<TypeReference<?>>emptyList());
        String encodedFunction = FunctionEncoder.encode(function);
        EthCall response = web3j.ethCall(
                Transaction.createEthCallTransaction(from, contractAddress, encodedFunction),
                DefaultBlockParameterName.LATEST)
                .sendAsync().get();
 
        if(response.getValue().equals("0x"))
            return false;
        return true;
    }
    
}