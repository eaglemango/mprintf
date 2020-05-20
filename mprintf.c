#include <stdio.h>

int mprintf(const char* format, ...);

int main(int argc, char* argv[]) {
    char test[] = "Hello, I'm %s. I have 0b%b groupmates. That is double percent: %%.\n"
                  "My ASM code for this task is about 0o%o lines long. Size of register is 0x%x bits.\n"
                  "My favourite number is %d. Cats say \"%s\".\n"
                  "Joke: %c and %c were sitting on the pipe...\n";
    
    mprintf(test, "Sergey", 17, 200, 64, 1337, "meow", 'A', 'B');

    return 0;
}
