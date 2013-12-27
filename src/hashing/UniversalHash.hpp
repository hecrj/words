#ifndef UniversalHash_HPP
#define UniversalHash_HPP

#include <string>
#include <stdint.h>

using namespace std;

typedef uint64_t hash_type;

class UniversalHash
{
    static const unsigned long long P;
    
    unsigned long long a;

    public:
        static const int BITS;

        UniversalHash();
        hash_type hash(string s);

        static int leading_zeros(hash_type hash);
};

#endif
