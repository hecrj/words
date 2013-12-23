#include "HyperLogLog.hpp"
#include "../hash.hpp"
#include <cmath>

HyperLogLog::HyperLogLog(int memory)
{
    m = memory;
    table = vector<int>(m, 0);
    b = floor(log2((double) m));
    mask = (1 << b) - 1;
    n = 0;
}

void HyperLogLog::read(istream &stream)
{
    string s;
    int h, j, w;

    while(stream >> s)
    {
        h = hash(s);
        j = 1 + (h & mask);
        w = h ^ mask;
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
