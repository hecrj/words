#include "UniversalHash.hpp"
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */

#ifdef VERBOSE
#include <iostream>
#endif

const unsigned long UniversalHash::P = 2305843009213693951; // Mersenne Prime: 2^61 - 1

UniversalHash::UniversalHash()
{
    srand(time(NULL));
    rand(); // Throw first random value (not so random?)
    a = rand() % P;

    #ifdef VERBOSE
    cout << "Mersenne prime: " << P << endl;
    cout << "Hash constant:  " << a << endl;
    #endif
}

hash_type UniversalHash::hash(string s)
{
    int i = 0;
    unsigned long h = 0;

    while(s[i] != '\0')
    {
        h += s[i];
        i++;
    }

    return (a * h) % P;
}
