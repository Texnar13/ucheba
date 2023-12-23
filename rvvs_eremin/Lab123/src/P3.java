import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class P3 {
public P3() { }
public static void main(String[] args) throws Exception {
ServerSocket s = new ServerSocket(2004);
Socket connection= s.accept ();
ObjectInputStream in = new ObjectInputStream (connection.getInputStream());
String message = (String)in.readObject();
Registry registry = LocateRegistry.getRegistry ("127.0.0.1",1099);
InterfaceRMI rmiServer= (InterfaceRMI)(registry.lookup ("rmiServer")
);
double x= rmiServer.Produit(Integer.parseInt(message));
ObjectOutputStream out = new ObjectOutputStream (connection.getOutputStream());
out.writeObject(Double.toString(x)); in.close(); out.close();
connection.close();s.close();
}}