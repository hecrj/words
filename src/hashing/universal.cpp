#include "universal.hpp"

unsigned int universal_hash(string s)
{
    int i = 0;
    unsigned long int h = 0;

    while(s[i] != '\0')
    {
        h += a * ((unsigned long int) s[i]);
        i++;
    }

    return h % P;
}
