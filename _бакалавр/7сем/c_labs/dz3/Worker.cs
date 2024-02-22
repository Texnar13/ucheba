using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;

namespace dz3
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


            int found_start = 0, found_end = incomingMessage.Length;
            found_start = incomingMessage.IndexOf("GET");
            found_end = incomingMessage.IndexOf("HTTP");
            string path = incomingMessage.Substring(found_start + 4, found_end - 5);
            string root_path = "C:\\Users\\Ivan\\Desktop\\labs\\dz3";
            path = root_path + path.Replace("/", "\\");

            string file = "index.html";
            string one_param = "";
            int found_file = path.IndexOf(".");
            if (found_file != -1)
            {
                found_file = path.LastIndexOf("\\");
                found_end = path.IndexOf("?");
                string buff = path;
                if (found_end != -1)
                {
                    while (found_file > found_end)
                    {
                        buff = buff.Substring(0, found_file);
                        found_file = buff.LastIndexOf("\\");
                    }
                }
                
                //if ()
                file = path.Substring(found_file + 1, (found_end == -1 ? path.Length : found_end) - found_file - 1);
                if (found_end != -1)
                {
                    one_param = path.Substring(found_end, path.Length - found_end);
                }
                path = path.Substring(0, found_file);
            }
            else
            {
                path = path.Substring(0, path.Length - 2);
            }
            string type_file = "html";
            string[] index_html = { root_path + "\\404.html" };
            if (Directory.Exists(path))
            {
                Console.WriteLine($"{path}");
                index_html = Directory.GetFiles(path, "*.*", SearchOption.AllDirectories);
                
                //string short_file = file.Substring(1, file.Length - 1);
                type_file = file.Substring(file.Length - 4, 4);
                if (index_html == null)
                {
                    index_html[0] = (root_path + "\\404.html");
                }
                else if (!index_html.Contains(path + "\\" + file))
                {
                    if (!index_html.Contains(path + "\\index.html"))
                        index_html[0] = root_path + "\\404.html";
                    else
                    {
                        index_html[0] = root_path + "\\index.html";
                    }
                }
                else 
                {
                    index_html[0] = path + "\\" + file;
                }
                if (one_param != "")
                {
                    Calc c = new Calc();
                    int found_equal = one_param.IndexOf("=");
                    one_param = one_param.Substring(found_equal + 1, one_param.Length - found_equal - 1);
                    double res = c.getResult(one_param.Replace("\\", "/"));
                    string createText = $"{{\"value\" : {res}}}";
                    File.WriteAllText(path + "\\res.json", createText);
                }
                //Directory.CreateDirectory(path);
            }

            //Console.WriteLine(message);

            // отправка сообщения

            string data = File.ReadAllText(index_html[0]);
            stream.Write(Encoding.UTF8.GetBytes(
                    "HTTP/1.0 200 OK" + Environment.NewLine
                    + "Content-Length: 0" + Environment.NewLine
                    + "Content-Type: " + "text/" + type_file + Environment.NewLine
                    + Environment.NewLine
                    + data
                    + Environment.NewLine + Environment.NewLine));
            Console.WriteLine("Отправлено сообщение: ");
            // закрываем поток
            stream.Close();
        }
    }
}
