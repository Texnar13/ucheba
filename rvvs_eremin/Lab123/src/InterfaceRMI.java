import java.rmi.Remote;
import java.rmi.RemoteException;


public interface InterfaceRMI extends Remote{
    double Produit (int pr) throws RemoteException;
}
