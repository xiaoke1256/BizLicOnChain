package com.xiaoke1256.bizliconchain.common.encrypt;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.interfaces.ECPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
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
	 
	 public static void savePublicKeyAsPEM(PublicKey publicKey, String name) throws Exception {
        String content = Base64.encodeBase64String(publicKey.getEncoded());
        File file = new File(name);
        if ( file.isFile() && file.exists() ) {
        	file.delete();
        }
            
        try (RandomAccessFile randomAccessFile = new RandomAccessFile(file, "rw")) {
            randomAccessFile.write("-----BEGIN PUBLIC KEY-----\n".getBytes());
            int i = 0;
            for (; i<(content.length() - (content.length() % 64)); i+=64) {
                randomAccessFile.write(content.substring(i, i + 64).getBytes());
                randomAccessFile.write('\n');
            }

            randomAccessFile.write(content.substring(i, content.length()).getBytes());
            randomAccessFile.write('\n');

            randomAccessFile.write("-----END PUBLIC KEY-----".getBytes());
        }
    }

    public static void savePrivateKeyAsPEM(PrivateKey privateKey, String name) throws Exception {
        String content = Base64.encodeBase64String(privateKey.getEncoded());
        File file = new File(name);
        if ( file.isFile() && file.exists() ){
        	file.delete();
        }
        try (RandomAccessFile randomAccessFile = new RandomAccessFile(file, "rw")) {
            randomAccessFile.write("-----BEGIN PRIVATE KEY-----\n".getBytes());
            int i = 0;
            for (; i<(content.length() - (content.length() % 64)); i+=64) {
                randomAccessFile.write(content.substring(i, i + 64).getBytes());
                randomAccessFile.write('\n');
            }

            randomAccessFile.write(content.substring(i, content.length()).getBytes());
            randomAccessFile.write('\n');

            randomAccessFile.write("-----END PRIVATE KEY-----".getBytes());
        }
    }
    
    public static PrivateKey loadECPrivateKey(String content) throws Exception {
        String privateKeyPEM = content.replace("-----BEGIN PRIVATE KEY-----\n", "")
                .replace("-----END PRIVATE KEY-----", "").replace("\n", "");
        byte[] asBytes = Base64.decodeBase64(privateKeyPEM);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(asBytes);
        String algorithm = "EC";
		KeyFactory keyFactory = KeyFactory.getInstance(algorithm );
        return keyFactory.generatePrivate(spec);
    }
    
    public static PrivateKey loadECPrivateKey(final InputStream inputStream) throws Exception {
    	return loadECPrivateKey(new String(readBytes(inputStream)));
    }

    public static PublicKey loadECPublicKey(String content) throws Exception {
        String strPublicKey = content.replace("-----BEGIN PUBLIC KEY-----\n", "")
                .replace("-----END PUBLIC KEY-----", "").replace("\n", "");
        byte[] asBytes = Base64.decodeBase64(strPublicKey);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(asBytes);
        String algorithm = "EC";
        KeyFactory keyFactory = KeyFactory.getInstance(algorithm);
        return (ECPublicKey) keyFactory.generatePublic(spec);
    }
    
    public static PublicKey loadECPublicKey(final InputStream inputStream) throws Exception {
    	return loadECPublicKey(new String(readBytes(inputStream)));
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
