#include <stdio.h>
#include <string.h>

// ASM function prototypes and external variables
int addstr(char *a, char *b);
int is_palindrome(char *s);
int factstr(char *s);
void palindrome_check();
extern int factNum = 0;

// Recursive factorial function
// Called by ASM
int fact(int n)
{
    if (n == 0 || n == 1)
    {
        return 1;
    }
    else
    {
        return n * fact(n - 1);
    }
}

// Determines if a string is a palindrome
// Called by ASM
int palindrome(char *s)
{
    int len = strlen(s) - 1;
    int i, j;

    for (i = 0, j = len - 1; i < (len / 2); i++, j--)
    {
        if (s[i] != s[j])
        {
            return 0;
        }
    }
    return 1;
}

int main()
{
    int input = 0;

    // Runs until user inputs 5
    do
    {
        printf("\nEnter a number to choose an option:\n");
        printf("(1) Add two numbers together\n");
        printf("(2) Test if a string is a palindrome (C -> ASM)\n");
        printf("(3) Find the factorial of a number\n");
        printf("(4) Test if a string is a palindrome (ASM -> C)\n");
        printf("(5) Exit the program\n");

        scanf("%d", &input); // Gets user input

        // Adds two numbers together
        if (input == 1)
        {
            char a[3];
            char b[3];

            printf("Enter a number:\n");
            scanf("%s", a);
            printf("Enter another number:\n");
            scanf("%s", b);

            // Calls assembly function that adds two numbers together
            int result = addstr(a, b);

            printf("The answer is %d\n", result);
        }
        // Palindrome function
        else if (input == 2)
        {
            char s[1024];

            printf("Enter a string:\n");
            scanf("%s", s);

            // Calls assembly function that determines if a string is a palindrome
            int result = is_palindrome(s);

            // 1 = not palindrome, 0 = palindrome
            if (result == 1)
            {
                printf("This string is not a palindrome.\n");
            }
            else
            {
                printf("This string is a palindrome.\n");
            }
        }
        // Factorial function
        else if (input == 3)
        {
            char factS[3];

            printf("Enter an integer:\n");
            scanf("%s", factS);

            // Calls assembly function that converts input to an integer
            // Program then finds the factorial of the user input
            // Passes the input to the external global variable
            factNum = factstr(factS);

            printf("%s! = %d\n", factS, factNum);
        }
        // Palindrome function
        else if (input == 4)
        {
            // Calls assembly function that gets user input
            // The function then calls palindrome() function in C
            // Prints output in assembly
            palindrome_check();
        }
        // If user doesn't input a number between 1 and 5
        else if (input < 1 || input > 5)
        {
            printf("\nIncorrect Input\nInput a number between 1 and 5\n");
        }
    } while (input != 5);

    printf("\nGoodbye!\n");

    return 0;
}
