import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Scanner;

public class P1 {
public P1() {}
public static void main(String[] args) throws Exception {
DatagramSocket clientSocket = new DatagramSocket();
byte[] sendData = new byte [10]; byte [] receiveData = new byte[10];
System.out.println("Entier:");
Scanner sc = new Scanner (System.in);
int N = sc.nextInt(); String Ch= Integer.toString (N);
sendData= Ch.getBytes();
DatagramPacket sendPacket = new DatagramPacket (sendData, sendData.length, InetAddress.getByName("localhost"), 9876);
clientSocket.send(sendPacket);
DatagramPacket receivePacket = new DatagramPacket (receiveData,
receiveData. length);
clientSocket.receive (receivePacket);
String str2 = new String (receivePacket.getData()).trim();
System.out.println ("Resultat:" + str2);
clientSocket.close();
}}