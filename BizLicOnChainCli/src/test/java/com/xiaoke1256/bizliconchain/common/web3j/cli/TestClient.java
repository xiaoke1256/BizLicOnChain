package com.xiaoke1256.bizliconchain.common.web3j.cli;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;

@EthClient
public interface TestClient {
	public String doSomething(String a);
}
