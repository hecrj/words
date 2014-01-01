#include "UniversalHash.hpp"
#include <stdlib.h>
#include <time.h>

#ifdef VERBOSE
#include <iostream>
#endif

const int UniversalHash::BITS = sizeof(hash_t) * 8;

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

hash_t UniversalHash::hash(unsigned char *str)
{
    hash_t hash = 5381;
    int c;

    while(c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return a * hash;
}

int UniversalHash::leading_zeros(hash_t value)
{
    // Be careful, magic code below!
    if (value == 0) return 64;
    int n = 1;
    if (not (value & 0xFFFFFFFF00000000)) { n += 32; value <<= 32;}
    if (not (value & 0xFFFF000000000000)) { n += 16; value <<= 16;}
    if (not (value & 0xFF00000000000000)) { n +=  8; value <<=  8;}
    if (not (value & 0xF000000000000000)) { n +=  4; value <<=  4;}
    if (not (value & 0xC000000000000000)) { n +=  2; value <<=  2;}
    if (not (value & 0x8000000000000000)) { n +=  1;}
    return n;
}
