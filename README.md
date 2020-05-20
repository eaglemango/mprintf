# mprintf

Реализация функции `printf` из `C` с помощью `GNU Assembler`.

## Сравнение с printf

### Достоинства

1. Дополнительный модификатор `%b` для вывода чисел в двоичном виде
2. Написано с душой

### Недостатки

1. Отсутствие возможности вывода чисел с плавающей точкой

## Пример работы

В [файле](./mprintf.c) представлен пример вызова функции `mprintf`.

Если всё правильно скомпилировать:

```
$ gcc mprintf.c mprintf.s
```

То после запуска вывод будет следующим:

```
Hello, I'm Sergey. I have 0b10001 groupmates. That is double percent: %.
My ASM code for this task is about 0o310 lines long. Size of register is 0x40 bits.
My favourite number is 1337. Cats say "meow".
Joke: A and B were sitting on the pipe...
```
