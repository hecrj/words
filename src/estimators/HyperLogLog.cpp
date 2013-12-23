#include "HyperLogLog.hpp"
#include "../utils.hpp"
#include "../hashing/universal.hpp"
#include <cmath>
#include <iostream>

HyperLogLog::HyperLogLog(int memory)
{
    m = memory;
    table = vector<int>(m, 0);
    b = floor(log2((double) m));
    lsb = sizeof(unsigned int)*8 - b;
    mask = (1 << lsb) - 1;
    n = 0;
}

void HyperLogLog::read(istream &stream)
{
    string s;
    unsigned int h, j, w;

    while(stream >> s)
    {
        h = universal_hash(s);
        j = (h >> lsb);
        w = h & mask;
        table[j] = max(table[j], first(w));

        n++;
    }
}

int HyperLogLog::estimation()
{
    return 69;
}

int HyperLogLog::total()
{
    return n;
}
