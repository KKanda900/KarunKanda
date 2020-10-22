/* CS 211 PA4
 * Created for: kk951
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int prehit = 0;
int premiss = 0;
int preread = 0;
int prewrite = 0;
int hits = 0;
int misses = 0;
int reads = 0;
int writes = 0;
int cacheSize = 0, cacheSet = 0, amount = 0, associativity, pNum, blockSize = 0, offset = 0, setSize, sets;

typedef struct CacheNode
{
    struct CacheNode *next;
    int block;
    struct CacheNode *tail;
    long int tag;
} Cache;

int Power2(int z)
{
    if (z == 0)
    {
        return -1;
    }
    int a = ceil(log2(z));
    int b = floor(log2(z));
    int c = (a == b);
    return c;
}

Cache *newNode(Cache *root, Cache *prev, int newNum, long int newTag)
{

    Cache *ptr = malloc(sizeof(Cache));
    (*ptr).next = root;
    (*ptr).block = newNum;
    (*ptr).tail = prev;
    (*ptr).tag = newTag;
    return ptr;
}

int validCache(int pNum, long int addr, int blockSize, int s, int z, int sets, Cache **c)
{

    int checker = 0, random = 0;
    long int index = (((addr - (addr % blockSize)) % (s * blockSize)) / blockSize);
    long int tag = addr - (addr % blockSize) - (index * s * blockSize);

    Cache *ptr, *root = c[index], *iterative, *prev = NULL;
    int true = 0;
    int policyCondition = (pNum == 1);
    int zCond = (z != 1);
    for(ptr = c[index]; ptr != NULL; ptr = (*ptr).next)
    {
        int y = ((*ptr).tag == tag);
        switch (y)
        {
        case 1:
            switch (policyCondition)
            {
            case 1:
                return true;
                break;
            default:
                switch (zCond)
                {
                case 1:
                    (*prev).next = (*ptr).next;
                    if ((*ptr).next != NULL)
                    {
                        Cache *t = (*ptr).next;
                        (*t).tail = prev;
                    }
                    random = 1;
                    iterative = ptr;
                    (*iterative).next = NULL;
                    break;
                default:
                    return true;
                    break;
                }
                break;
            }
            break;
        default:
            break;
        }
        int other = ((*ptr).block > checker);
        switch (other)
        {
        case 1:
            checker = (*ptr).block;
            break;
        default:
            break;
        }
        prev = ptr;
    }

    int too = (random == 1 && z != 1);
    switch (too)
    {
    case 1:
        (*prev).next = iterative;
        (*iterative).next = NULL;
        (*iterative).block = checker;
        (*iterative).tail = prev;
        return 0;
        break;
    default:
        break;
    }

    checker++;

    Cache *temp = newNode(NULL, prev, checker, tag);
    (*prev).next = temp;

    int newcase = (checker > sets);
    switch (newcase)
    {
    case 1:
        iterative = (*root).next;
        ptr = (*iterative).next;
        (*root).next = ptr;
        (*ptr).tail = root;
        break;
    default:
        break;
    }

    return -1;
}

int main(int argc, char **argv)
{
    int i, j;
    long int addr = 0;

    if (argc - 1 != 5)
    {
        printf("%s\n", "Not enough arguments");
        return 0;
    }

    while (argv[5][amount] != '\0')
    {
        amount++;
    }
    amount++;

    FILE *cacheFile = fopen(argv[5], "r");
    if (cacheFile == NULL)
    {
        printf("%s\n", "No file was given");
        return 1;
    }

    cacheSize = atoi(argv[1]);
    if (Power2(cacheSize) != 1)
    {
        printf("%s\n", "Not Power of Two");
        return 1;
    }
    else
    {
        cacheSet = log2(cacheSize);
    }

    char *pol = argv[3];
    if (strcmp("fifo", pol) == 0)
    {
        pNum = 1;
    }
    else
    {
        printf("%s\n", "Incorrect Policy Type");
        return 1;
    }

    blockSize = atoi(argv[4]);
    if (Power2(cacheSize) != 1)
    {
        printf("%s\n", "Not Power of Two");
        return 1;
    }
    else
    {
        offset = log2(blockSize);
    }

    i = 0;
    while (argv[2][i] != '\0')
    {
        i++;
    }

    char *temp;
    switch (i)
    {
    case 6:
        setSize = cacheSize / blockSize;
        sets = 1;
        associativity = 0;
        break;
    case 5:
        setSize = 1;
        associativity = 1;
        sets = cacheSize / blockSize;
        break;
    default:
        temp = calloc((i - 6) + 1, sizeof(char));
        j = 6;
        while (argv[2][j] != '\0')
        {
            temp[j - 6] = argv[2][j];
            j++;
        }
        associativity = atoi(temp);
        if (log2(associativity) == -1)
        {
            return -1;
        }
        setSize = cacheSize / (blockSize * associativity);
        sets = associativity;
        break;
    }

    Cache **prefetch = calloc(setSize, sizeof(Cache *));
    Cache **cache = calloc(setSize, sizeof(Cache *));
    i = 0;
    while (i < setSize)
    {
        Cache *tmp2 = newNode(NULL, NULL, 0, -1);
        Cache *tmp1 = newNode(NULL, NULL, 0, -1);
        prefetch[i] = tmp2;
        cache[i] = tmp1;
        i++;
    }

    char iterative[200];
    char operation;
    while (fscanf(cacheFile, "%s ", iterative))
    {
        if (strcmp("#eof", iterative) == 0)
        {
            break;
        }
        fscanf(cacheFile, "%c %lx", &operation, &addr);
        int cacheCheck = validCache(pNum, addr, blockSize, setSize, 0, sets, cache);
        switch (cacheCheck)
        {
        case 0:
            hits++;
            int o = (operation == 'W');
            switch (o)
            {
            case 1:
                writes++;
                break;
            default:
                break;
            }
            break;
        default:
            misses++;
            int r = (operation == 'R');
            switch (r)
            {
            case 1:
                reads++;
                break;
            default:
                reads++;
                writes++;
                break;
            }
            break;
        }

        int prefetchCheck = validCache(pNum, addr, blockSize, setSize, 0, sets, prefetch);
        switch (prefetchCheck)
        {
        case 0:
            prehit++;
            int o = (operation == 'W');
            switch (o)
            {
            case 1:
                prewrite++;
                break;
            default:
                break;
            }
            break;
        default:
            premiss++;
            int r = (operation == 'R');
            switch (r)
            {
            case 1:
                preread++;
                break;
            default:
                preread++;
                prewrite++;
                break;
            }
            int prepre = validCache(pNum, addr + blockSize, blockSize, setSize, 1, sets, prefetch);
            switch (prepre)
            {
            case 0:
                break;
            default:
                preread++;
                break;
            }
            break;
        }
    }

    printf("Prefetch %d\n", 0);
    printf("Memory reads: %d\n", reads);
    printf("Memory writes: %d\n", writes);
    printf("Cache hits: %d\n", hits);
    printf("Cache misses: %d\n", misses);
    printf("Prefetch %d\n", 1);
    printf("Memory reads: %d\n", preread);
    printf("Memory writes: %d\n", prewrite);
    printf("Cache hits: %d\n", prehit);
    printf("Cache misses: %d\n", premiss);

    fclose(cacheFile);

    return 0;
}
