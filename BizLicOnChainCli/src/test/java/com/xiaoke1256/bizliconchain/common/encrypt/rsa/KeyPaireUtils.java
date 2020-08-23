package com.xiaoke1256.bizliconchain.common.encrypt.rsa;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;

public class KeyPaireUtils {
	public static final String CHARSET = "UTF-8";
	public static final String RSA_ALGORITHM = "RSA";
	
	private static final int KEY_SIZE = 1024*4;
	
	
	public static final String OUT_PUT_PATH = "D:\\Temp\\";
	
	public static void main(String[] args) {
		KeyPairGenerator kpg;
		try{
			kpg = KeyPairGenerator.getInstance(RSA_ALGORITHM);
		}catch(NoSuchAlgorithmException e){
			throw new IllegalArgumentException("No such algorithm-->[" + RSA_ALGORITHM + "]");
		}

		//初始化KeyPairGenerator对象,密钥长度
		kpg.initialize(KEY_SIZE);
		//生成密匙对
		KeyPair keyPair = kpg.generateKeyPair();
		
		PublicKey publicKey = keyPair.getPublic();
		
		FileOutputStream fileOs = null;
		ObjectOutputStream os = null;
		try {
			fileOs = new FileOutputStream(OUT_PUT_PATH+"/public_key.dat");
			os = new ObjectOutputStream(fileOs);
			os.writeObject(publicKey);
		}catch(IOException e) {
			throw new RuntimeException(e);
		}finally {
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				fileOs.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
	}
}
