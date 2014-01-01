#ifndef UniversalHash_HPP
#define UniversalHash_HPP

#include <stdint.h>
#include <string>

using namespace std;

typedef uint64_t hash_t;

class UniversalHash
{
    hash_t a;

    public:
        static const int BITS;

        UniversalHash();
        hash_t hash(unsigned char *str);

        static int leading_zeros(hash_t hash);
};

#endif
