package com.xiaoke1256.bizliconchain.common.service;

import java.io.IOException;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.List;
import java.util.concurrent.ExecutionException;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameter;
import org.web3j.protocol.core.methods.response.EthBlock;
import org.web3j.protocol.core.methods.response.EthGetTransactionReceipt;
import org.web3j.protocol.http.HttpService;

import com.xiaoke1256.bizliconchain.common.bo.EthTrasLog;
import com.xiaoke1256.bizliconchain.common.util.HexUtil;

/**
 * 定时任务，用于反馈一个交易的执行结果，因为以太坊的事务都是异步反馈的
 * @author TangJun
 *
 */
@Service
public class EthTrasLogFeedbackService {
	
	private static final Logger LOG = LoggerFactory.getLogger(EthTrasLogFeedbackService.class);
	
	static Web3j web3j;
	
	@Autowired
	private EthTrasLogService ethTrasLogService;
	
    @Value("${contract.url}")
    private   String URL;
	
    @PostConstruct
    public void init() {
    	web3j = Web3j.build(new HttpService(URL));
    }
	
	/**
	 * 以太坊平均出块时间是17.16s所以以20秒为周期
	 * @throws ExecutionException 
	 * @throws InterruptedException 
	 */
	@Scheduled(cron = "0/20 * * * * ?")
	void feedBack() throws InterruptedException, ExecutionException {
		List<EthTrasLog> logs = ethTrasLogService.queryUnFeedback();
		for(EthTrasLog log:logs) {
			EthGetTransactionReceipt ethGetTransactionReceipt = web3j.ethGetTransactionReceipt(log.getTrasHash()).sendAsync().get();
	        if(ethGetTransactionReceipt.getTransactionReceipt().isPresent()) {
	        	String status = ethGetTransactionReceipt.getTransactionReceipt().get().getStatus();
	        	BigInteger gasUsed = ethGetTransactionReceipt.getTransactionReceipt().get().getGasUsed();
	        	BigInteger blockNumber = ethGetTransactionReceipt.getTransactionReceipt().get().getBlockNumber();
	        	if(gasUsed == null) {
	        	  LOG.error("used 怎么可能是空？");//gasUsed 是重要的核算依据不能是空。
	        	  continue;
	        	}
	        	LOG.info("status:"+status);//1为成功 0为失败
	        	LOG.info("gasUsed:"+gasUsed);
	        	LOG.info("blockNumber:"+blockNumber);
	        	try {
	                EthBlock ethBlock = web3j.ethGetBlockByNumber(DefaultBlockParameter.valueOf(blockNumber), false).send();
	                Timestamp timestamp = new Timestamp(ethBlock.getBlock().getTimestamp().longValue());
	                log.setFinishTime(timestamp);
	            } catch (IOException e) {
	                LOG.warn("Block timestamp get failure,block number is {}", blockNumber);
	                LOG.error("Block timestamp get failure,{}", e);
	            }
	        	log.setTrasStatus(status);
	        	if(HexUtil.parse(status).intValue()==1) {
	        		log.setStatus("S");
	        	}else {
	        		log.setStatus("E");
	        		LOG.info("ethGetTransactionReceipt.getRawResponse():"+ethGetTransactionReceipt.getRawResponse());
	            	//LOG.info("response.getResult().getCumulativeGasUsedRaw():"+ethGetTransactionReceipt.getResult().getCumulativeGasUsedRaw());
	            	log.setErrMsg(ethGetTransactionReceipt.getRawResponse());
	        	}
	        	log.setGasUsed(gasUsed);
	        	log.setUpdateTime(new Timestamp(System.currentTimeMillis()));
	        	ethTrasLogService.updateLog(log);
	        }else {
	        	//有时 ethGetTransactionReceipt 会莫名奇妙的消失掉要手工处理。
	        }
		}
        
	}
}
