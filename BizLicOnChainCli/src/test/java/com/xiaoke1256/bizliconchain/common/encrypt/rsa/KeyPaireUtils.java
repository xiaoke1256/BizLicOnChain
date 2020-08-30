package com.xiaoke1256.bizliconchain.common.encrypt.rsa;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;

import org.apache.commons.codec.binary.Base64;

public class KeyPaireUtils {
	public static final String CHARSET = "UTF-8";
	public static final String RSA_ALGORITHM = "RSA";
	
	private static final int KEY_SIZE = 1024;
	
	
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
		PrivateKey privateKey = keyPair.getPrivate();
		savePublicKey(publicKey);
		savePrivateKey(privateKey);
	}
	
	private static void savePublicKey(PublicKey publicKey) {
		FileWriter fw = null;
		PrintWriter pw = null;
		try {
			File file = new File(OUT_PUT_PATH+"/public_key.dat");
			if(file.exists())
				file.delete();
			file.createNewFile();
			fw= new FileWriter(OUT_PUT_PATH+"/public_key.dat", true);
			pw = new PrintWriter(fw);
			String key  = Base64.encodeBase64String(publicKey.getEncoded());
			System.out.println("public key :"+key);
			pw.print(key);
		}catch(IOException e) {
			throw new RuntimeException(e);
		}finally {
			pw.close();
			try {
				fw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	private static void savePrivateKey(PrivateKey privateKey) {
		FileWriter fw = null;
		PrintWriter pw = null;
		try {
			File file = new File(OUT_PUT_PATH+"/private_key.dat");
			if(file.exists())
				file.delete();
			file.createNewFile();
			fw= new FileWriter(OUT_PUT_PATH+"/private_key.dat", true);
			pw = new PrintWriter(fw);
			String key  = Base64.encodeBase64String(privateKey.getEncoded());
			System.out.println("public key :"+key);
			pw.print(key);
		}catch(IOException e) {
			throw new RuntimeException(e);
		}finally {
			pw.close();
			try {
				fw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
