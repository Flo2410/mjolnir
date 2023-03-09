#include <stdio.h>
#include <string.h>

int main(int argc, char const *argv[]) {
  // // %d displays the integer value of a character
  // // %c displays the actual character
  // printf("ASCII value of %c = %d", c, c);

  if (argc > 3) {
    printf("Too many arguments supplied.\n");
  } else if (argc > 1) {
    if (strcmp(argv[1], "-d") == 0) {
      int c;
      while (scanf("%d", &c) != EOF) {
        if (argc == 3 && (argv[2], "--no-newline") == 0)
          printf("%c", c);
        else
          printf("%c\n", c);
      }
    } else if (argc == 3 && strcmp(argv[1], "-e") == 0) {
      char c;
      while (scanf(" %c", &c) != EOF) {
        if (strcmp(argv[2], "--no-newline") == 0)
          printf("%d", c);
        else
          printf("%d\n", c);
      }
    } else {
      printf("-d or -e - given %s\n", argv[1]);
    }
  } else {
    printf("One argument expected.\n");
  }

  return 0;
}
