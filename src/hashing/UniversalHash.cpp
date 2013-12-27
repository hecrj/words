#include "UniversalHash.hpp"
#include <stdlib.h>
#include <time.h>

#ifdef VERBOSE
#include <iostream>
#endif

const unsigned long long UniversalHash::P = 2305843009213693951; // Mersenne Prime: 2^61 - 1
const int UniversalHash::BITS = sizeof(hash_type) * 8;

UniversalHash::UniversalHash()
{
    rand(); // Throw first random value (not so random?)

    uint64_t r30 = RAND_MAX*rand() + rand();
    uint64_t s30 = RAND_MAX*rand() + rand();
    int t4  = rand() & 0xf;

    a = (r30 << 34) + (s30 << 4) + t4;

    #ifdef VERBOSE
    cout << "Hash bits:       " << BITS << endl; 
    cout << "Hash random int: " << a << endl;
    #endif
}

hash_type UniversalHash::hash(string s)
{
    hash_type hash = 5381;
    
    int i = 0;
    while(i < s.size())
    {
        hash = ((hash << 5) + hash) + ((int) s[i]); /* hash * 33 + c */
        ++i;
    }

    return a * hash;
}

int UniversalHash::leading_zeros(hash_type hash)
{
    int pos = 0;
    
    while(hash >>= 1)
        pos++;

    return BITS - pos;
}
