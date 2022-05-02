package com.xiaoke1256.bizliconchain.common.web3j.cli;

import com.alibaba.fastjson.JSONObject;
import com.xiaoke1256.bizliconchain.common.bo.EthTrasLog;
import com.xiaoke1256.bizliconchain.common.service.EthTrasLogService;
import com.xiaoke1256.bizliconchain.common.util.HexUtil;

import io.reactivex.functions.Consumer;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.web3j.abi.DefaultFunctionReturnDecoder;
import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.RawTransaction;
import org.web3j.crypto.TransactionEncoder;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.request.Transaction;
import org.web3j.protocol.core.methods.response.EthCall;
import org.web3j.protocol.core.methods.response.EthGetTransactionCount;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.http.HttpService;
import org.web3j.protocol.websocket.events.LogNotification;
import org.web3j.utils.Numeric;

import java.io.IOException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ExecutionException;

import javax.annotation.PostConstruct;

/**
 * @Datetime: 2020/6/23   10:36
 * @Author: Xia rong tao
 * @title
 */

@Component
public class BaseWeb3jImpl implements IBaseWeb3j {

    private static final Logger LOG = LoggerFactory.getLogger(BaseWeb3jImpl.class);

    @Autowired
    private EthTrasLogService ethTrasLogService;

    static Web3j web3j;

    @Value("${contract.url}")
    private   String URL;


    @Value("${contract.addGas}")
    private BigInteger addGas;



    @Value("${contract.isAddGas}")
    private boolean isAddGas;
    
    @PostConstruct
    public void init() {
    	web3j = Web3j.build(new HttpService(URL));
    }
    
    /**
     * 调用合约（进行检查）
     */
    public String transactWithCheck(String fromAddr, String fromPrivateKey, String contractAddress, String method, BigInteger gasPrice, BigInteger gasLimit, List<Type> inputParameters,String bizKey) {
    	if(StringUtils.isEmpty(fromAddr)) {
    		throw new RuntimeException("From address cannot be empty.");
    	}
    	if(StringUtils.isEmpty(fromPrivateKey)) {
    		throw new RuntimeException("From PrivateKey cannot be empty.");
    	}
    	if(StringUtils.isEmpty(fromPrivateKey)) {
    		throw new RuntimeException("Contract address cannot be empty.");
    	}
    	try {
    		if(!queryTransfer(fromAddr,contractAddress,method,inputParameters)) {
    			throw new RuntimeException("Something wrong happen when excute the contract , please check the input paramters.");
    		}
    		return transact(fromAddr,fromPrivateKey,contractAddress,method,gasPrice,gasLimit,inputParameters,bizKey);
    	}catch(Exception e) {
    		throw new RuntimeException(e);
    	}
    }

    /**
     * 调用合约（不进行检查）
     */
    public String transact(String fromAddr, String fromPrivateKey, String contractAddress, String method, BigInteger gasPrice, BigInteger gasLimit, List<Type> inputParameters,String bizKey) {
        EthSendTransaction ethSendTransaction = null;
        BigInteger nonce = BigInteger.ZERO;
        String hash = null;
        EthTrasLog log = null;
        try {
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
            LOG.info("contractAddress:{}",contractAddress);
            LOG.info("bizKey:{}",bizKey);
            LOG.info("trasHash:{}",hash);
            LOG.info(JSONObject.toJSONString(ethSendTransaction));
            log = ethTrasLogService.saveLog(nonce.toString(), contractAddress, method, bizKey, hash,gasPrice,gasLimit);
            if(ethSendTransaction.getError()!=null) {
            	ethTrasLogService.modifyError(log,ethSendTransaction.getError().getMessage());
            	throw new RuntimeException(ethSendTransaction.getError().getMessage());
            }
            //看看到底成功了没有
            /* 以下用其他方法来解决，比如现将hexValue保存到数据库，然后定时轮询来更新后续状态。
            Thread.sleep(20000);//以太坊平均出块时间是17.16s
            EthGetTransactionReceipt ethGetTransactionReceipt = web3j.ethGetTransactionReceipt(hash).sendAsync().get();
            if(ethGetTransactionReceipt.getTransactionReceipt().isPresent()) {
            	String status = ethGetTransactionReceipt.getTransactionReceipt().get().getStatus();
            	BigInteger gasUsed = ethGetTransactionReceipt.getTransactionReceipt().get().getGasUsed();
            	LOG.info("status:"+status);
            	LOG.info("gasUsed:"+gasUsed);
            }*/
        } catch (Exception e) {
            if (null != ethSendTransaction) {
            	if(ethSendTransaction.getError()!=null)
            		LOG.info("失败的原因：" + ethSendTransaction.getError().getMessage());
                LOG.info("参数：fromAddr = " + fromAddr);
                LOG.info("参数：month = " + method);
                LOG.info("参数：gasPrice = " + gasPrice);
                LOG.info("参数：gasLimit = " + gasLimit);
                LOG.info("参数：inputParameters = " + JSONObject.toJSONString(inputParameters));
                if(log!=null) {
                	String errMsg = null;
                	if(ethSendTransaction.getError()!=null)
                		errMsg = ethSendTransaction.getError().getMessage();
                	ethTrasLogService.modifyError(log,errMsg);
                }
            }
            throw new RuntimeException(e);
        }

        return hash;
    }
    
    /**
     * 用Call的方式调用合约。（目的是为了测试合约是否能成功调用）
     * @param from 调用方
     * @param contractAddress 
     * @return
     * @throws ExecutionException 
     * @throws InterruptedException 
     * @throws Exception
     */
    public boolean queryTransfer(String from, String contractAddress, String method,List<Type> inputParameters) throws InterruptedException, ExecutionException {
        Function function = new Function(method,
                inputParameters,
                Collections.<TypeReference<?>>emptyList());//output 难道就是 empty了？
        String encodedFunction = FunctionEncoder.encode(function);
        EthCall response = web3j.ethCall(
                Transaction.createEthCallTransaction(from, contractAddress, encodedFunction),
                DefaultBlockParameterName.LATEST)
                .sendAsync().get();
        LOG.info("response.getError():"+response.getError());
        if(response.getError()!=null) {
        	LOG.info("response.getError().getMessage():"+response.getError().getMessage());
        	LOG.info("response.getError().getCode():"+response.getError().getCode());
        	LOG.info("response.getError().getData():"+response.getError().getData());
        	return false;
        }
        if(response.getRevertReason()!=null && response.getRevertReason().length()>0) {
        	LOG.info("response.getRevertReason():"+response.getRevertReason());
        	return false;
        }
        if(HexUtil.parse(response.getValue()).intValue() == 0) {
        	LOG.error("response.getValue():"+response.getValue());
        	LOG.error("response.getResult():"+response.getResult());
        	LOG.error("Jsonrpc:"+response.getJsonrpc());
        	LOG.error("RawResponse:"+response.getRawResponse());
        	LOG.error("RevertReason:"+response.getRevertReason());
        	return false;
        }  
        return true;
    }
    
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
    public String queryToString(String from, String contractAddress, String method,List<Type> inputParameters) throws InterruptedException, ExecutionException, ClassNotFoundException {
    	Function function = new Function(method,
                inputParameters,
                Arrays.asList(TypeReference.create(Utf8String.class)));
        String encodedFunction = FunctionEncoder.encode(function);
        EthCall response = web3j.ethCall(
                Transaction.createEthCallTransaction(from, contractAddress, encodedFunction),
                DefaultBlockParameterName.LATEST)
                .sendAsync().get();
        DefaultFunctionReturnDecoder rd = new DefaultFunctionReturnDecoder();
        @SuppressWarnings("unchecked")
		List<Type> results = rd.decodeFunctionResult(response.getResult(), Arrays.asList(TypeReference.makeTypeReference("string")));
        if(results.isEmpty())
        	return null;
        return results.get(0).toString();
    }
    
    @Override
    public BigInteger getBalance(String address) throws IOException {
    	return web3j.ethGetBalance(address, DefaultBlockParameterName.LATEST).send().getBalance();
		
	}
    
    /**
     * 注册事件监听
     * @param contractAddress
     * @param topic 类似 "ApplyStatusChange(string,string,string)"
     * @param onSuccess
     * @param onError
     */
    @Override
    public void subscript(String contractAddress,String topic ,Consumer<LogNotification> onSuccess,Consumer<Throwable> onError) {
    	web3j.logsNotifications(Arrays.asList(contractAddress), Arrays.asList(topic)).blockingSubscribe(onSuccess, onError);
    }
    
    
}