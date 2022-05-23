package com.xiaoke1256.bizliconchain.blockchain.cli;

import java.util.List;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;
import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.ReadOnly;
import com.xiaoke1256.bizliconchain.bo.Bizlic;

@EthClient(contractAddress="${contract.ctAddr}")
public interface BizLicOnChainClient {
	/**
	 * 提交一个营业执照
	 * @param uniScId
	 * @param organCode
	 * @param licContent 
	 * @param sign 电子签名
	 */
	public void putLic(String uniScId,String organCode,String licContent,String sign);
	
	@ReadOnly
	public Bizlic getLicContent(String uniScId);
	
	@ReadOnly
	public List<String> getAllUniScIds();
	
	public void removeLic(String uniScId);
}
