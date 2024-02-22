try
{
    Console.Write("Введите число a: ");
    bool ba = double.TryParse(Console.ReadLine(), out double a);
    Console.Write("Введите число b: ");
    bool bb = double.TryParse(Console.ReadLine(), out double b);

    if (!ba || !bb) throw new Exception("Не введено число! / Ошибка преобразования!");
    if (a.ToString().ToArray().Count() > 3)
        throw new Exception($"Число {a} слишком длинное!");
    if (b.ToString().ToArray().Count() > 3)
        throw new Exception($"Число {b} слишком длинное!");
    if (b == 0.0)
        throw new Exception($"Деление на ноль!");

    Console.WriteLine($"a / b = {a / b}");
}
catch (Exception e)
{
    Console.WriteLine($"Ошибка: {e.Message}");
}