import java.util.Random;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.Scanner;

public class RSA {

    final static SecureRandom random = new SecureRandom();
    final static BigInteger one = new BigInteger("1");
    static BigInteger n, e, d;

    // Lets first generate the key pair
    public RSA(){ //N will represent the level of encryption 
        int N = 50;
        BigInteger p = BigInteger.probablePrime(N/2, random);
        BigInteger q = BigInteger.probablePrime(N/2, random);
        BigInteger n1 = (p.subtract(one)).multiply(q.subtract(one)); 
        n = p.multiply(q);
        e = new BigInteger("65537"); //By common practice it should be 2^16+1
        d = e.modInverse(n1); //Private Key
    }

    public static BigInteger encrpytMethod(BigInteger message){
        return message.modPow(e, n);
    }

    public static BigInteger decrypt(BigInteger encrpyt){
        return encrpyt.modPow(d, n);
    }

    public static BigInteger toBigInt(String message){
        byte[] bytes = message.getBytes();
        BigInteger newBigInt = new BigInteger(bytes);
        return newBigInt;
    }

    public static String toMessage(BigInteger decrypt) {
        byte[] bytes = decrypt.toByteArray();
        return new String(bytes);
    } 

    public static void main(String[] args){
        /* Scanner sc = new Scanner(System.in);
        int N = 50;
        RSA key = new RSA(N);
        System.out.println("Enter your message: ");
        String message = sc.nextLine();
        BigInteger mess = toBigInt(message);
        BigInteger enc = encrpyt(mess);
        BigInteger dec = decrypt(enc);
        String hello = toMessage(dec);
        System.out.println(hello); */
    }
}