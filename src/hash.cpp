#include "hash.hpp"

int hash(string s)
{
    return 1;
}

int first(int binary)
{
    int pos = 0;
    
    while(binary >>= 1)
        pos++;

    return pos;
}
