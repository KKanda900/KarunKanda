/* CS 211 PA4
 * Created for: kk951
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

typedef struct LogicalCircuit
{
    char circuit[17];
    int *in;
    int *out;
    int *sel;
    int size;
    int selectorSize;
} Gate;

void evaluate(Gate a, int *vals)
{
    if (strcmp(a.circuit, "NOT") == 0)
    {
        vals[a.out[0]] = !vals[a.in[0]];
    }
    if (strcmp(a.circuit, "AND") == 0)
    {
        vals[a.out[0]] = vals[a.in[0]] && vals[a.in[1]];
    }
    if (strcmp(a.circuit, "OR") == 0)
    {
        vals[a.out[0]] = (vals[a.in[0]] || vals[a.in[1]]);
    }
    if (strcmp(a.circuit, "NAND") == 0)
    {
        vals[a.out[0]] = !(vals[a.in[0]] && vals[a.in[1]]);
    }
    if (strcmp(a.circuit, "NOR") == 0)
    {
        vals[a.out[0]] = !(vals[a.in[0]] || vals[a.in[1]]);
    }
    if (strcmp(a.circuit, "XOR") == 0)
    {
        vals[a.out[0]] = vals[a.in[0]] ^ vals[a.in[1]];
    }
    if (strcmp(a.circuit, "PASS") == 0)
    {
        vals[a.out[0]] = vals[a.in[0]];
    }
    if (strcmp(a.circuit, "DECODER") == 0)
    {
        int s = 0, i = 0;
        int b = pow(2, a.size);
        while (i < b)
        {
            vals[a.out[i]] = 0;
            i++;
        }
        i = 0;
        while (i < a.size)
        {
            s = s + vals[a.in[i]] * pow(2, a.size - i - 1);
            i++;
        }
        int index = a.out[s];
        vals[index] = 1;
    }
    if (strcmp(a.circuit, "MULTIPLEXER") == 0)
    {
        int s = 0, i = 0;
        while (i < a.selectorSize)
        {
            s = s + vals[a.sel[i]] * pow(2, a.selectorSize - i - 1);
            i++;
        }
        int index = a.out[0];
        int index2 = a.in[s];
        vals[index] = vals[index2];
    }
}

void freeDouble(char **M, int r)
{
    for (int i = 0; i < r; i++)
    {
        free(M[i]);
    }
    free(M);
}

int ind(char *matchCase, int amount, char **a)
{
    int i = 0;
    while (i < amount)
    {
        if (strcmp(a[i], matchCase) == 0)
        {
            return i;
        }
        i++;
    }
    return -1;
}

void printTruthTable(int incITMP, int stepSize, int incOTMP, Gate *dirTMP, int *a)
{
    int i = 0;
    while (i < incITMP)
    {
        printf("%d ", a[i + 2]);
        i++;
    }
    printf("|");

    i = 0;
    while (i < stepSize)
    {
        Gate final = dirTMP[i];
        evaluate(final, a);
        i++;
    }

    i = 0;
    while (i < incOTMP)
    {
        printf(" %d", a[incITMP + i + 2]);
        i++;
    }
    printf("\n");
}

int main(int argc, char **argv)
{
    FILE *circuit = fopen(argv[1], "r");
    if (argv[1] == NULL)
    {
        printf("Invalid File");
        return 0;
    }

    Gate *directives = NULL;
    int stepcount = 0, amount = 2, incrementInput = 0, incrementOutput = 0, t = 0;
    char names[17];
    int *vals = calloc(amount, sizeof(int));
    char **truthInput;

    fscanf(circuit, " %s", names);
    fscanf(circuit, "%d", &incrementInput);

    amount = amount + incrementInput;
    int total = amount; //Used for truthInput
    truthInput = calloc(amount, sizeof(char *));
    truthInput[1] = calloc(2, sizeof(char));
    truthInput[0] = calloc(2, sizeof(char));
    truthInput[1] = "1";
    truthInput[0] = "0";

    int i = 0; //For simplicity for the other for Loops im going to use later lol

    while (i < incrementInput)
    {
        truthInput[i + 2] = calloc(17, sizeof(char));
        fscanf(circuit, "%*[: ]%16s", truthInput[i + 2]);
        i++;
    }

    fscanf(circuit, " %s", names);
    fscanf(circuit, "%d", &incrementOutput);
    amount = amount + incrementOutput;
    total = amount;
    truthInput = realloc(truthInput, amount * sizeof(char *));
    i = 0;
    while (i < incrementOutput)
    {
        truthInput[i + incrementInput + 2] = calloc(17, sizeof(char));
        fscanf(circuit, "%*[: ]%16s", truthInput[i + incrementInput + 2]);
        i++;
    }

    char str[200]; //to traverse the file
    while (fgets(str, sizeof(str), circuit) != NULL)
    {
        Gate direct;
        int outputNums = 1, inputNums = 2;
        int counter = fscanf(circuit, " %s", names);
        if (counter != 1)
            break;
        stepcount = stepcount + 1;
        direct.size = 0;
        direct.selectorSize = 0;
        strcpy(direct.circuit, names);

        switch (strcmp(direct.circuit, "PASS"))
        {
        case 0:
            inputNums = 1;
            break;
        default:
            switch (strcmp(direct.circuit, "NOT"))
            {
            case 0:
                inputNums = 1;
                break;
            default:
                switch (strcmp(direct.circuit, "DECODER"))
                {
                case 0:
                    fscanf(circuit, "%d", &inputNums);
                    direct.size = inputNums;
                    outputNums = pow(2, inputNums);
                    break;
                default:
                    switch (strcmp(direct.circuit, "MULTIPLEXER"))
                    {
                    case 0:
                        fscanf(circuit, "%d", &inputNums);
                        direct.selectorSize = inputNums;
                        inputNums = pow(2, inputNums);
                        break;
                    default:
                        break;
                    }
                    break;
                }
                break;
            }
            break;
        }

        direct.in = calloc(inputNums, sizeof(int));
        direct.sel = calloc(direct.selectorSize, sizeof(int));
        direct.out = calloc(outputNums, sizeof(int));

        char tmp[17];
        i = 0;
        while (i < inputNums)
        {
            fscanf(circuit, "%*[: ]%16s", tmp);
            direct.in[i] = ind(tmp, amount, truthInput);
            i++;
        }

        i = 0;
        while (i < direct.selectorSize)
        {
            fscanf(circuit, "%*[: ]%16s", tmp);
            direct.sel[i] = ind(tmp, amount, truthInput);
            i++;
        }

        i = 0;

        for (i = 0; i < outputNums; i++)
        {
            fscanf(circuit, "%*[: ]%16s", tmp);
            int index = ind(tmp, amount, truthInput);
            switch (index)
            {
            case -1:
                amount++;
                t++;
                truthInput = realloc(truthInput, amount * sizeof(char *));
                truthInput[amount - 1] = calloc(17, sizeof(char));
                strcpy(truthInput[amount - 1], tmp);
                direct.out[i] = amount - 1;
                break;
            default:
                direct.out[i] = index;
                break;
            }
        }

        if (directives)
        {
            directives = realloc(directives, stepcount * sizeof(Gate));
        }
        else
        {
            directives = malloc(sizeof(Gate));
        }
        directives[stepcount - 1] = direct;
        //free(direct);
    }

    //printf("%d\n", amount);

    total = amount;
    vals = calloc(amount, sizeof(int));
    int j = 0;
    while (j < amount)
    {
        vals[j] = 0;
        j++;
    }
    vals[1] = 1;

    while (1)
    {
        printTruthTable(incrementInput, stepcount, incrementOutput, directives, vals);
        int counter = incrementInput + 1;
        int *tempo = vals;
        int temp = 0;
        while (counter >= 2)
        {
            tempo[counter] = !tempo[counter];
            int tracker = tempo[counter];
            if (tracker == 1)
            {
                temp = 1;
                break;
            }
            counter--;
        }

        if (temp == 0)
        {
            break;
        }
    }

    //printf("%d\n", total);
    free(vals);
    free(directives);
    close(circuit);


    return EXIT_SUCCESS;
}
