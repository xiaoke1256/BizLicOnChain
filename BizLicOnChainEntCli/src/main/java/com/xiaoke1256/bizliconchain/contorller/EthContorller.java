package com.xiaoke1256.bizliconchain.contorller;

import java.io.IOException;
import java.math.BigInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.xiaoke1256.bizliconchain.common.web3j.cli.IBaseWeb3j;

/**
 * 与以太坊相关的Contorller
 * @author TangJun
 *
 */
@RequestMapping("/eth")
@RestController
public class EthContorller {
	@Autowired
	private IBaseWeb3j baseWeb3j;
	
	/**
	 * from地址
	 */
	@Value("${contract.sendAddr}")
	protected String fromAddr;
	
	/**
	 * 管理员账户的余额
	 * @throws IOException 
	 */
	@GetMapping("balance")
	public BigInteger getAdminBalance() throws IOException {
		return baseWeb3j.getBalance(fromAddr);
	}
	
	/**
	 * 查某个账户的余额
	 * @throws IOException 
	 */
	@GetMapping("{address}/balance")
	public BigInteger getBalance(@PathVariable("address") String address) throws IOException {
		return baseWeb3j.getBalance(address);
	}
}
