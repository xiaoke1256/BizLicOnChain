package com.xiaoke1256.bizliconchain.common.encrypt;

import java.security.InvalidAlgorithmParameterException;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.spec.ECGenParameterSpec;

import org.apache.commons.codec.binary.Base64;

public class ECDSASecp256k1Keys {
	public static void main(String[] args) throws NoSuchAlgorithmException, InvalidAlgorithmParameterException {
		KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("EC");
	    // curveName这里取值：secp256k1
        ECGenParameterSpec ecGenParameterSpec = new ECGenParameterSpec("secp256k1");
        keyPairGenerator.initialize(ecGenParameterSpec, new SecureRandom());
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        // 获取公钥
        PublicKey publicKey = keyPair.getPublic(); 
        System.out.println(Base64.encodeBase64String(publicKey.getEncoded()));
        // 获取私钥
        PrivateKey privateKey = keyPair.getPrivate();
        System.out.println(Base64.encodeBase64String(privateKey.getEncoded()));
        
        try {
			ECDSASecp256k1.savePublicKeyAsPEM(publicKey,"D:\\Temp\\ECDSASecp256k1\\public_key.der");
			ECDSASecp256k1.savePrivateKeyAsPEM(privateKey,"D:\\Temp\\ECDSASecp256k1\\private_key.der");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
}
