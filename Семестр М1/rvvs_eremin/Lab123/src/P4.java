import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class P4 extends java.rmi.server.UnicastRemoteObject
    implements InterfaceRMI {
public P4() throws RemoteException{ }

public double Produit (int pr) throws RemoteException {
    double prime =0;
    for (int i = 2; i <= pr; i++) {
        if (isPrime(i)) {
            prime += i;
            System.out.println(i);
        }
        
    }
return prime;}
    // Function to check if a number is prime
    private static boolean isPrime(int num) {
        if (num <= 1) {
            return false;
        }
        for (int i = 2; i <= Math.sqrt(num); i++) {
            if (num % i == 0) {
                
                return false;
            }
        }
        return true;
    }
static public void main(String args[]) throws Exception
{
P4 s = new P4();
Registry registry = LocateRegistry.createRegistry(1099);
registry.rebind("rmiServer", s);}}

