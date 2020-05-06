# Структура проекта

Проект содержит однотактовый процессор с конвеером, который:

* в случае конфликта запускает команду nop, пока конфликт не разрешится

* в случае команды ветвления запускает команду nop, пока следующее значение для счётчика команд не определится

Тестируемые программы находятся в файлах:

* assembler/prog.asm содержит ветвления

* assembler/fib.asm содержит последовательность Фибоначчи

# Запуск проекта

Чтобы перевести программу на ассемблере в программу на машинном коде, выполните команду:

  python3 dis_asm.py prog.asm

Программа на машинном коде будет находится в файле mem_content.list

Чтобы запустить симуляцию, выполните команды:

  iverilog *.v

  ./a.out

  
