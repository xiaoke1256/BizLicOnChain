package com.xiaoke1256.bizliconchain.common.encrypt;

import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.DSAPrivateKeySpec;
import java.security.spec.X509EncodedKeySpec;

import org.apache.commons.codec.binary.Base64;

public class ECDSASecp256k1 {
	/**
	 * 签名
	 */
	public static byte[] signature(PrivateKey key, byte[] data) throws NoSuchAlgorithmException, InvalidKeyException, SignatureException {
		Signature signer = Signature.getInstance("SHA256withECDSA");
        signer.initSign(key);
        signer.update(data);
        return (signer.sign());
	}
	
	public static boolean verifySign(byte[] data, PublicKey key, byte[] sig) throws Exception {
        Signature signer = Signature.getInstance("SHA256withECDSA");
        signer.initVerify(key);
        signer.update(data);
        return (signer.verify(sig));
    }
	
	public static PublicKey getPublicKey(String publicKey) throws Exception {
		//通过X509编码的Key指令获得公钥对象
		KeyFactory keyFactory = KeyFactory.getInstance("EC");
		X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(Base64.decodeBase64(publicKey));
		PublicKey key = keyFactory.generatePublic(x509KeySpec);
		return key;
	}
	
	 public static PrivateKey getPrivateKey(String privateKey) throws NoSuchAlgorithmException, InvalidKeySpecException {
		 //通过PKCS#8编码的Key指令获得私钥对象
		 KeyFactory keyFactory = KeyFactory.getInstance("EC");
		 PKCS8EncodedKeySpec pkcs = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKey));
		 PrivateKey key = keyFactory.generatePrivate(pkcs);
		 return key;
	 }
}
