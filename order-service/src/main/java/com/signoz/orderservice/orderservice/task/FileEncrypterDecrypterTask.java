package com.signoz.orderservice.orderservice.task;

import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import java.io.*;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

public class FileEncrypterDecrypterTask {

    private final SecretKey secretKey;
    private final Cipher cipher;

    public FileEncrypterDecrypterTask(SecretKey secretKey, String cipher) throws NoSuchPaddingException, NoSuchAlgorithmException {
        this.secretKey = secretKey;
        this.cipher = Cipher.getInstance(cipher);
    }

    public void encrypt(File inputFile, String outputFilePath) throws InvalidKeyException, IOException {
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] iv = cipher.getIV();

        try (
                FileInputStream inputStream = new FileInputStream(inputFile);
                FileOutputStream fileOut = new FileOutputStream(outputFilePath);
                CipherOutputStream cipherOut = new CipherOutputStream(fileOut, cipher)
        ) {
            byte[] inputBytes = new byte[(int) inputFile.length()];
            byte[] outputBytes = cipher.doFinal(inputBytes);
            FileOutputStream outputStream = new FileOutputStream(outputFilePath);
            outputStream.write(outputBytes);

            inputStream.close();
            outputStream.close();
        } catch (IllegalBlockSizeException | BadPaddingException e) {
            throw new RuntimeException(e);
        }

    }
}
