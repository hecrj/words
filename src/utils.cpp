#include "utils.hpp"

int first(hash_type binary)
{
    int pos = 0;
    
    while(binary >>= 1)
        pos++;

    return hash_bits - pos;
}
