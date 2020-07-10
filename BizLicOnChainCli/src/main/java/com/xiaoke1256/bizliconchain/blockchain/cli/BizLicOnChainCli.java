package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.io.IOException;

import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.protocol.HTTP;

public class BizLicOnChainCli {
	private HttpClient httpClient = HttpClients.createDefault();
	
	private String url = "http://127.0.0.1:8545";
	
	public void sendLic(String dataJson) {
		HttpPost request = new HttpPost(url);
		 
		try {
			request.setEntity(new StringEntity("",HTTP.UTF_8));
			httpClient.execute(request );
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
}
