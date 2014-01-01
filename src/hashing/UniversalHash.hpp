#ifndef UniversalHash_HPP
#define UniversalHash_HPP

#include <stdint.h>

using namespace std;

typedef uint64_t hash_t;

class UniversalHash
{
    unsigned long long a;

    public:
        static const int BITS;

        UniversalHash();
        hash_t hash(unsigned char *str);

        static int leading_zeros(hash_t hash);
};

#endif
