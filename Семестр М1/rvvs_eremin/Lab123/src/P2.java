import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.Socket;

public class P2 {
    public P2() {
    }

    public static void main(String[] args) throws Exception {
        DatagramSocket serverSocket = new DatagramSocket(9876);
        byte[] receiveData = new byte[10];
        byte[] sendData = new byte[10];
        DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
        serverSocket.receive(receivePacket);
        String sentence = new String(receivePacket.getData()).trim();
        Socket c = new Socket("127.0.0.1", 2004);
        ObjectOutputStream out = new ObjectOutputStream(c.getOutputStream());
        out.writeObject(sentence);
        ObjectInputStream in = new ObjectInputStream(c.getInputStream());
        String message = (String) in.readObject();
        sendData = message.getBytes();
        DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.
                length, receivePacket.getAddress(), receivePacket.getPort());
        serverSocket.send(sendPacket);
        in.close();
        out.close();
        c.close();
    }
}