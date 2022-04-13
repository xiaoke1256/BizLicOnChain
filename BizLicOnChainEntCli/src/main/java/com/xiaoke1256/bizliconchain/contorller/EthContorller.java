package com.xiaoke1256.bizliconchain.contorller;

import java.io.IOException;
import java.math.BigInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.web3j.protocol.core.methods.response.EthGetBalance;

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
	 * 查某个账户的余额
	 * @throws IOException 
	 */
	@GetMapping("{address}/balance")
	public BigInteger getBalance(@PathVariable("address") String address) throws IOException {
		return baseWeb3j.getBalance(address);
	}
}
