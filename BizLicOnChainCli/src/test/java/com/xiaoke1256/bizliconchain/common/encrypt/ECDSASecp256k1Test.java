package com.xiaoke1256.bizliconchain.common.encrypt;

import java.security.PrivateKey;
import java.security.PublicKey;

import org.junit.Assert;
import org.junit.Test;

public class ECDSASecp256k1Test {
	@Test
	public void testSignAndVerify() throws Exception {
		PrivateKey privateKey = ECDSASecp256k1.getPrivateKey("159680f164539e8603c5a1d9e45dbf07b2b2a129c0e330d3b98ed529eece20a7");
		PublicKey publicKey = ECDSASecp256k1.getPublicKey("456247d681c799bf184085c2e1db8409add60c34");
		byte[] org = "ssaawdwfff四国相".getBytes("utf-8");
		byte[] sign = ECDSASecp256k1.signature(privateKey, org);
		boolean result = ECDSASecp256k1.verifySign( org, publicKey, sign);
		System.out.println("result:"+result);
		Assert.assertTrue(result);
	}
}
