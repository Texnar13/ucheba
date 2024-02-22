using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace dz3
{
    class Server
    {
        private int _port { get; }
        TcpListener _listener;
        public Server(int port)
        {
            _port = port;
            _listener = new TcpListener(IPAddress.Parse("127.0.0.1"), _port);
        }
        public void Start()
        {
            try
            {
                _listener.Start();
            }
            catch (Exception e)
            {
                Console.WriteLine($"{e.Message}");
                throw;
            }
            while (true)
            {
                TcpClient client = _listener.AcceptTcpClient();
                Thread Thread = new Thread(new ParameterizedThreadStart(WorkerThread));
                Thread.Start(client);
            }
        }
        private static void WorkerThread(Object client)
        {
            new Worker((TcpClient)client);
        }
        ~Server()
        {
            if (_listener != null)
            {
                _listener.Stop();
            }
        }
    }
}
