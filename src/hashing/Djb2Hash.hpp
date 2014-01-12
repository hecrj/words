#ifndef DJB2_HPP
#define DJB2_HPP

#include <stdint.h>
#include <string>

using namespace std;

typedef uint64_t hash_t;

class Djb2Hash
{
    hash_t a;

    public:
        static const int BITS;

        Djb2Hash();
        hash_t hash(unsigned char *str);

        static int leading_zeros(hash_t hash);
};

#endif
