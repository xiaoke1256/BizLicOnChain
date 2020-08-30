package com.xiaoke1256.bizliconchain.common.encrypt.rsa;

import java.io.InputStream;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;

import org.junit.Assert;
import org.junit.Test;


import com.xiaoke1256.bizliconchain.common.encrypt.RSAUtils;

public class RSAUtilsTest {
	@Test
	public void testSignAndVerify() throws Exception {
		InputStream is = this.getClass().getResourceAsStream("/com/xiaoke1256/bizliconchain/security/keys/rsa_private_key.dat");
		RSAPrivateKey privateKey = RSAUtils.getPrivateKey(is);
		String data = "ssaawdwfff四国相";
		String sign = RSAUtils.privateEncrypt(data, privateKey);
		is = this.getClass().getResourceAsStream("/com/xiaoke1256/bizliconchain/security/keys/rsa_public_key.dat");
		RSAPublicKey publicKey = RSAUtils.getPublicKey(is);
		String decoded = RSAUtils.publicDecrypt(sign, publicKey);
		System.out.println("result:"+decoded);
		Assert.assertEquals(data, decoded);
	}
}
