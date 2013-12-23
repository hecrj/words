#include "utils.hpp"

int first(int binary)
{
    int pos = 0;
    
    while(binary >>= 1)
        pos++;

    return uint_bits - pos;
}
