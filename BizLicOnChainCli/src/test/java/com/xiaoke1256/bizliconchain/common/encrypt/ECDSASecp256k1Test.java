package com.xiaoke1256.bizliconchain.common.encrypt;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.PrivateKey;
import java.security.PublicKey;

import org.apache.tomcat.util.codec.binary.Base64;
import org.junit.Assert;
import org.junit.Test;

public class ECDSASecp256k1Test {
	@Test
	public void testSignAndVerify() throws Exception {
		//PrivateKey privateKey = ECDSASecp256k1.getPrivateKey("MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAElBqJpGsmH3T7+XwltNvrCP9cXzAzTGZlHp5djkXO558Aak97yliEiBjX5A0xsQPfhhfk1Bnp6ubmY0tnaRjOhg==");
		PrivateKey privateKey = ECDSASecp256k1.loadECPrivateKey(new String(readBytes(this.getClass().getResourceAsStream("/com/xiaoke1256/bizliconchain/security/keys/ecdsa/private_key.der"))));
		byte[] org = "ssaawdwfff四国相".getBytes("utf-8");
		byte[] sign = ECDSASecp256k1.signature(privateKey, org);
		//PublicKey publicKey = ECDSASecp256k1.getPublicKey("MD4CAQAwEAYHKoZIzj0CAQYFK4EEAAoEJzAlAgEBBCBUy7r69RDFK/HKdtdAbWDWbG+mthdiT6B/grsaERQi5Q==");
		PublicKey publicKey = ECDSASecp256k1.loadECPublicKey(new String(readBytes(this.getClass().getResourceAsStream("/com/xiaoke1256/bizliconchain/security/keys/ecdsa/public_key.der"))));
		System.out.println("sign:"+Base64.encodeBase64String(sign));
		boolean result = ECDSASecp256k1.verifySign( org, publicKey, sign);
		System.out.println("result:"+result);
		Assert.assertTrue(result);
	}
	
	private static byte[] readBytes(final InputStream inputStream) throws IOException {
        final int BUFFER_SIZE = 1024;
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int readCount;
        byte[] data = new byte[BUFFER_SIZE];
        while ((readCount = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, readCount);
        }
        
        buffer.flush();
        return buffer.toByteArray();
    }
}
