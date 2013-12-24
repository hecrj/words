#include "UniversalHash.hpp"
#include <iostream>

const unsigned long int UniversalHash::P = 2305843009213693951; // Mersenne Prime: 2^61 - 1

UniversalHash::UniversalHash()
{
    uniform_int_distribution<unsigned long int> dist(1, P);
    default_random_engine generator;
    generator.seed(time(0));
    
    a = dist(generator);
}

unsigned int UniversalHash::hash(string s)
{
    int i = 0;
    unsigned long int h = 0;

    while(s[i] != '\0')
    {
        h += a * ((unsigned long int) s[i]);
        i++;
    }

    return h % P;
}
