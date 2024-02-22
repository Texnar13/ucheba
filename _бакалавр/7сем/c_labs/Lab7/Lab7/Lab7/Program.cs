using System;
using System.Reflection;

namespace _6._2
{
    class Program
    {
        static void Main(string[] args)
        {
            Type myType = typeof(ReflClass);//получаем тип

            #region Информация о конструкторах
            Console.WriteLine("\nИнформация о конструкторах");
            ConstructorInfo[] cInfo = myType.GetConstructors();//заносим инфу в ConstructorInfo
            foreach (ConstructorInfo o in cInfo)
                Console.WriteLine(o);//выводим
            #endregion

            #region Информация о методах
            Console.WriteLine("\nИнформация о методах");
            MethodInfo[] cMeth = myType.GetMethods(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.DeclaredOnly);//заносим инфу в MethodInfo, используя флаги, нам подходят: (Instance-Указывает, что члены экземпляров следует включить в поиск) (методы public), (NonPublic(частные)) и (только те, что находятся  нашем классе)
            foreach (MethodInfo o in cMeth)
                Console.WriteLine(o);//выводим
            #endregion

            #region Информация о свойствах
            Console.WriteLine("\nИнформация о свойствах");
            PropertyInfo[] cProp = myType.GetProperties();//заносим инфу в PropertyInfo
            foreach (PropertyInfo o in cProp)
                Console.WriteLine(o);//выводим
            #endregion

            #region Информация только о свойствах с атрибутами
            Console.WriteLine("\nИнформация только о свойствах с атрибутами");
            foreach (PropertyInfo o in cProp)
            {
                object attributes = o.GetCustomAttribute(typeof(ReflClassAttribute), false);//извлекаем настраив. атрибут(который указали)
                if (attributes != null)//если ничего не достали, значит его нет, а значит его не выводим
                    Console.WriteLine(o);//выводим
            }
            #endregion

            #region Вызов метода
            Console.WriteLine("\nВызов метода через рефлексию");
            dynamic st = Activator.CreateInstance(myType);//создаем экз класса с помощью рефлексии
            Console.WriteLine(st.Shet(true));//вызываем нужный метод
            #endregion
        }
    }

    class ReflClass
    {
        #region Конструкторы
        public ReflClass()
        {
            X = 5;
            Y = 6;
        }
        public ReflClass(int a, int b)
        {
            X = a;
            Y = b;
        }
        #endregion

        #region Свойства
        [ReflClass]
        public int X { get; set; }
        public int S { get; set; }

        [ReflClass]
        public int Y { get; set; }
        #endregion

        #region Методы
        public int Shet(bool f)
        {
            int M = f ? Sum() : Mult();
            S = M;
            return S;
        }
        private int Sum()
        {
            return X + Y;
        }
        private int Mult()
        {
            return X * Y;
        }
        #endregion
    }

    class ReflClassAttribute : System.Attribute//атрибут
    {

    }
}
