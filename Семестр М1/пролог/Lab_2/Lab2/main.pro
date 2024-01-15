implement main
    open
        core,
        console,
        file

class predicates
    returning_true:().
    my_init : ().
    out_base_symptoms_and_ask : ().
    out_concret_symptoms_and_ask : ().
        out_loop : (integer).
        ask_user : (integer).
            ask_base : ().
            ask_infant : ().
            ask_child : ().
            ask_kid : ().
    ask_repeat : ().
    calculate_and_out_result : ().


class facts - symptoms
    %Симптомы пневмонии у грудничков:
    infantSymptom :(integer, integer, string).
    %Симптомы пневмонии у маленьких детей:
    childSymptom:(integer, integer, string).
    %Симптомы пневмонии у детей:
    kidSymptom:(integer, integer, string).
    %Общие симптомы пневмонии:
    baseSymptom:(integer, string).
    %Хроническая пневмониия:
    extraFact:(integer, string).

    %выбранные симптомы:
    chousenSymptoms:(integer).
    % временная переменная
    baseSumm:real:= 0 .% расчет вероятности по базовым симптомам
    concretSumm:real:= 0 .% расччет вероятности по возрастным симптомам
    isRepeat:boolean:= false.% является ли пневмония хронической


clauses
run() :- returning_true().

returning_true():-

    my_init(),
    stdio::write(":::::::::::::::::::Выявление пневмонии у пациента::::::::::::::::::::::::::\n"),
    out_base_symptoms_and_ask(),
    stdio::write(":::::::::::::::::::Конкретизированые симптомы::::::::::::::::::::::::::\n"),
    out_concret_symptoms_and_ask(),
    ask_repeat(),

    calculate_and_out_result(),
    stdio::write("Но диагноз все равно должен поставить врач!"),

    stdio::write("\n:::::ВСЁ!:::::"),
    _ = stdio::readLine(),
    _ = stdio::readLine(),
    _ = stdio::readLine(),
    fail.
returning_true():- !.


%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


my_init() :-
    console::init(),
    console::clearOutput, % чистка выходного потока (есть еще console::clearInput)
    file::consult("dbfile.txt", symptoms). % загрузка базы фактов

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

out_base_symptoms_and_ask() :-
    out_loop(4),
    ask_user(4).

out_concret_symptoms_and_ask() :-

    % выбор возраста
    stdio::write("Введите возраст пациента (\"1\" - грудничковый, \"2\" - маленький ребенок, \"0стальное\" - от  1 года): \n"),
    Inp = console::readLine(),

    stdio::write("---Список симптомов---\n"),
    if Inp = "1" then
        out_loop(1),
        ask_user(1)
        else
        if Inp = "2" then
            out_loop(2),
            ask_user(2)
        else
            out_loop(3),
            ask_user(3)
        end if
    end if.

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

out_loop(Patient) :-
    if Patient = 1 then
        stdio::write("Симптомы пациента грудничковый ребенок\n"),
        infantSymptom(Number, _, Name)
        else
        if Patient = 2 then
            stdio::write("Симптомы пациента маленький ребенок\n"),
            childSymptom(Number, _, Name)
        else
            if Patient = 4 then
                stdio::write("Общие симптомы:\n"),
                baseSymptom(Number, Name)
            else
                stdio::write("Симптомы пациента ребенок:\n"),
                kidSymptom(Number, _, Name)
            end if
        end if
    end if,
    stdio::write("Симптом: ", Number, " - ", Name, "\n"),
    fail.
out_loop(_) :- !.

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ask_user(AskType):-
    if(AskType = 1) then
        ask_infant()
    elseif (AskType = 2) then
        ask_child()
    elseif (AskType = 3) then
        ask_kid()
    elseif (AskType = 4) then
        ask_base()
    end if.


ask_base() :-
    stdio::write("\nВведите один номер обнаруженного симптома (0 - для выхода):"),
    hasDomain(integer, Inp),
    Inp = stdio::read(),

    if( baseSymptom(Inp, _) )then
        if (not(chousenSymptoms(Inp))) then
            stdio::write("Симптом найден в базе и учтен."),
            assert(chousenSymptoms(Inp)),
            % нашли симптом добавляем его
            baseSumm := baseSumm + 1
        else
            stdio::write("Симптом уже зарегистрирован.")
        end if
    else
        if (Inp = 0) then
            fail
        else
            stdio::write("Симптом не найден в базе!")
        end if
    end if,
    % продолжаем цикл ввода
    !, ask_base().

ask_base():-!,
    baseSumm:= baseSumm * 100 / 7,
    stdio::write("Вероятность по базовым симптомам ", baseSumm, "\n\n"),
    _ = stdio::readLine(),
    _ = stdio::readLine().




ask_infant() :-
    stdio::write("\nВведите один номер обнаруженного симптома (0 - для выхода):"),
    hasDomain(integer, Inp),
    Inp = stdio::read(),

    if( infantSymptom(Inp, Weight, _) )then
        if (not(chousenSymptoms(Inp))) then
            stdio::write("Симптом найден в базе и учтен."),
            assert(chousenSymptoms(Inp)),
            % нашли симптом добавляем его
            concretSumm := concretSumm + Weight
        else
            stdio::write("Симптом уже зарегистрирован.")
        end if
    else
        if (Inp = 0) then
            fail
        else
            stdio::write("Симптом не найден в базе!")
        end if
    end if,
    % продолжаем цикл ввода
    !, ask_infant().

ask_infant():-!,
    %concretSumm:= concretSumm * 100 / 7,
    stdio::write("Вероятность по грудничковым симптомам ", concretSumm, "\n\n"),
    _ = stdio::readLine(),
    _ = stdio::readLine().




ask_child() :-
    stdio::write("\nВведите один номер обнаруженного симптома (0 - для выхода):"),
    hasDomain(integer, Inp),
    Inp = stdio::read(),

    if( childSymptom(Inp, Weight, _) )then
        if (not(chousenSymptoms(Inp))) then
            stdio::write("Симптом найден в базе и учтен."),
            assert(chousenSymptoms(Inp)),
            % нашли симптом добавляем его
            concretSumm := concretSumm + Weight
        else
            stdio::write("Симптом уже зарегистрирован.")
        end if
    else
        if (Inp = 0) then
            fail
        else
            stdio::write("Симптом не найден в базе!")
        end if
    end if,
    % продолжаем цикл ввода
    !, ask_child().

ask_child():-!,
    %concretSumm:= concretSumm * 100 / 7,
    stdio::write("Вероятность по симптомам маленьких детей: ", concretSumm, "\n\n"),
    _ = stdio::readLine(),
    _ = stdio::readLine().






ask_kid() :-
    stdio::write("\nВведите один номер обнаруженного симптома (0 - для выхода):"),
    hasDomain(integer, Inp),
    Inp = stdio::read(),

    if( kidSymptom(Inp, Weight, _) )then
        if (not(chousenSymptoms(Inp))) then
            stdio::write("Симптом найден в базе и учтен."),
            assert(chousenSymptoms(Inp)),
            % нашли симптом добавляем его
            concretSumm := concretSumm + Weight
        else
            stdio::write("Симптом уже зарегистрирован.")
        end if
    else
        if (Inp = 0) then
            fail
        else
            stdio::write("Симптом не найден в базе!")
        end if
    end if,
    % продолжаем цикл ввода
    !, ask_kid().

ask_kid():-!,
    %concretSumm:= concretSumm * 100 / 7,
    stdio::write("Вероятность по симптомам у детей старше 2х лет: ", concretSumm, "\n\n"),
    _ = stdio::readLine(),
    _ = stdio::readLine().


%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ask_repeat():-
    stdio::write("Проявляются ли симптомы периодически? (y - Да, n - нет): "),
    Input = stdio::readChar(),
    if(Input = 'y' or Input = 'Y') then
        isRepeat := true
    end if.


calculate_and_out_result() :-
    baseSumm := (baseSumm + concretSumm),
    if (baseSumm > 99) then
        baseSumm := 99
    end if,
    stdio::write("Общий анализ симптомов проведен. Вероятность болезни: ", baseSumm , "%"),
    if(isRepeat = true and baseSumm > 50 ) then
        stdio::write("Возможно болезнь хроническая.\n\n")
    else
        stdio::write("\n\n")
    end if.

end implement main

goal
    %console::runUtf8(main::run).
    mainExe::run(main::run).