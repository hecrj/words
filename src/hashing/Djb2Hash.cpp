#include "Djb2Hash.hpp"
#include <stdlib.h>
#include <time.h>

#ifdef VERBOSE
#include <iostream>
#endif

const int Djb2Hash::BITS = sizeof(hash_t) * 8;

//La constructora de Djb2Hash inicializa la variable a
Djb2Hash::Djb2Hash()
{
    rand(); // Throw first random value (not so random?)

    a = (((uint64_t) rand() <<  0) & 0x000000000000FFFF) |
    (((uint64_t) rand() << 16) & 0x00000000FFFF0000) |
    (((uint64_t) rand() << 32) & 0x0000FFFF00000000) |
    (((uint64_t) rand() << 48) & 0xFFFF000000000000);

    #ifdef VERBOSE
        cout << "Hash bits:       " << BITS << endl; 
        cout << "Hash random int: " << a << endl;
    #endif
}

//Esta función es la función de hash propiamente dicha, y usa el método djb2
//que ya se ha explicado en la documentacion para devolver la posición en la tabla
hash_t Djb2Hash::hash(unsigned char *str)
{
    hash_t hash = 5381;
    int c;

    while(c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return a * hash;
}

//
int Djb2Hash::leading_zeros(hash_t value)
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
