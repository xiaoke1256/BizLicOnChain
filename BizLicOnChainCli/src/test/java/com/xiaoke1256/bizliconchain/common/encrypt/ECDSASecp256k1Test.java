package com.xiaoke1256.bizliconchain.common.encrypt;

import java.security.PrivateKey;
import java.security.PublicKey;

import org.junit.Assert;
import org.junit.Test;

public class ECDSASecp256k1Test {
	@Test
	public void testSignAndVerify() throws Exception {
		PrivateKey privateKey = ECDSASecp256k1.getPrivateKey("MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAElBqJpGsmH3T7+XwltNvrCP9cXzAzTGZlHp5djkXO558Aak97yliEiBjX5A0xsQPfhhfk1Bnp6ubmY0tnaRjOhg==");
		byte[] org = "ssaawdwfff四国相".getBytes("utf-8");
		byte[] sign = ECDSASecp256k1.signature(privateKey, org);
		PublicKey publicKey = ECDSASecp256k1.getPublicKey("MD4CAQAwEAYHKoZIzj0CAQYFK4EEAAoEJzAlAgEBBCBUy7r69RDFK/HKdtdAbWDWbG+mthdiT6B/grsaERQi5Q==");
		boolean result = ECDSASecp256k1.verifySign( org, publicKey, sign);
		System.out.println("result:"+result);
		Assert.assertTrue(result);
	}
}
