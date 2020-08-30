package com.xiaoke1256.bizliconchain.common.encrypt;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
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
	}
	
	public static void savePublicKeyAsPEM(PublicKey publicKey, String name) throws Exception {
        String content = Base64.encodeBase64String(publicKey.getEncoded());
        File file = new File(name);
        if ( file.isFile() && file.exists() )
            throw new IOException("file already exists");
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
        if ( file.isFile() && file.exists() )
            throw new IOException("file already exists");
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
}
