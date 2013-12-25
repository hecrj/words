#ifndef UniversalHash_HPP
#define UniversalHash_HPP

#include <string>

using namespace std;

typedef unsigned int hash_type;

const int hash_bits = sizeof(hash_type) * 8;

class UniversalHash
{
    static const unsigned long P;
    
    unsigned int a;

    public:
        UniversalHash();
        hash_type hash(string s);
};

#endif
