

using dz3;

public static class Program
{
    public static void Main(string[] args)
    {
        Server server = new Server(80);
        server.Start();
    }
}