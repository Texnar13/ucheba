using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace dz2
{
    internal class Worker
    {
        private TcpClient _client;
        public Worker(TcpClient client)
        {
            _client = client;
            Start();
        }
        private void Start()
        {
            NetworkStream stream = _client.GetStream();
            var buffer = new byte[10240];
            var length = stream.Read(buffer, 0, buffer.Length);

            var incomingMessage = Encoding.UTF8.GetString(buffer, 0, length);

            //Console.WriteLine($"Приянто сообщение: {incomingMessage}");


            int found_start = 0, fount_end = incomingMessage.Length;
            found_start = incomingMessage.IndexOf("GET");
            fount_end = incomingMessage.IndexOf("HTTP");
            string path = incomingMessage.Substring(found_start + 4, fount_end - 5);
            string root_path = "C:\\Users\\s\\Desktop\\c#\\dz2";
            path = root_path + path.Replace("/", "\\");
            
            string file = "index.html";
            int found_file = path.IndexOf(".");
            if (found_file != -1)
            {
                found_file = path.LastIndexOf("\\");
                file = path.Substring(found_file, path.Length - found_file);
                path = path.Substring(0, found_file);
            }
            else 
            { 
                path = path.Substring(0, path.Length - 2);
            }

            string[] index_html = { root_path + "\\404.html" };
            if (Directory.Exists(path))
            {
                Console.WriteLine($"{path}");
                index_html = Directory.GetFiles(path, "*.*", SearchOption.AllDirectories);
                Console.WriteLine($"{index_html}");
                if (index_html == null)
                {
                    index_html[0] = root_path + "\\404.html";
                }
                else if (!index_html.Contains(file))
                {
                    if (!index_html.Contains(path + "\\index.html"))
                        index_html[0] = root_path + "\\404.html";
                }
                //Directory.CreateDirectory(path);
            }

            //Console.WriteLine(message);

            // отправка сообщения
            
            string data = File.ReadAllText(index_html[0]);
            stream.Write(Encoding.UTF8.GetBytes(
                    "HTTP/1.0 200 OK" + Environment.NewLine
                    + "Content-Length: 0" + Environment.NewLine
                    + "Content-Type: " + "text/html" + Environment.NewLine
                    + Environment.NewLine
                    + data
                    + Environment.NewLine + Environment.NewLine));
            Console.WriteLine("Отправлено сообщение: ");
            // закрываем поток
            stream.Close();
        }
    }
}
