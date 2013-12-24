#ifndef UniversalHash_HPP
#define UniversalHash_HPP

#include <string>
#include <random>

using namespace std;

class UniversalHash
{
    static const unsigned long int P;
    
    unsigned long int a;

    public:
        UniversalHash();
        unsigned int hash(string s);
};

#endif
