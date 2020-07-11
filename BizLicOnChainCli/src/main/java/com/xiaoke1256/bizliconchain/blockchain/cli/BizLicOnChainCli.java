package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Random;

import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.protocol.HTTP;

public class BizLicOnChainCli {
	private HttpClient httpClient = HttpClients.createDefault();
	
	private String url = "http://127.0.0.1:8545";
	
	private int clientId = new Random(10000).nextInt();

	public void sendLic(String uniScId,String organCode,String licContent,String sign) {
		Map<String,Object> sendData = new LinkedHashMap<String,Object>();
		sendData.put("id",Integer.valueOf(clientId));
		sendData.put("jsonrpc","2.0");
		sendData.put("method","eth_sendTransaction");
		sendData.put("params", "[{}]");
		
		HttpPost request = new HttpPost(url);
		 
		try {
			request.setEntity(new StringEntity("",HTTP.UTF_8));
			httpClient.execute(request );
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
}
