#include "HyperLogLog.hpp"
#include "../utils.hpp"
#include <cmath>
#include <iostream>

HyperLogLog::HyperLogLog(int memory)
{
    m = memory;
    table = vector<unsigned char>(m, 0);
    b = floor(log2((double) m));
    lsb = UniversalHash::BITS - b;
    mask = (1 << lsb) - 1;
    alpha = 0.7213 / (1.0 + 1.079 / m);
    n = 0;
}

void HyperLogLog::read(istream &stream)
{
    string s;
    hash_type h;
    hash_type w;
    unsigned int i;

    while(stream >> s)
    {
        h = hashing.hash(s);
        i = (h >> lsb);
        w = h & mask;
        table[i] = max((int)table[i], first(w) - (int)b);

        n++;
    }
}

estimation_t HyperLogLog::estimation()
{
    double sum = 0;

    for(int i = 0; i < m; ++i)
        sum += 1.0 / (1 << table[i]);

    estimation_t raw = alpha * m * m * (1.0 / sum);

    if(raw < (2.5 * m))
    {
        int zeros = count_zeros();

        if(zeros == 0)
            return raw;

        return m * log(((double) m) / zeros);
    }

    if(raw > 143165577)
        return -4294967296 * log(1.0 - ((double)raw / 4294967296));

    return raw;
}

estimation_t HyperLogLog::total()
{
    return n;
}

int HyperLogLog::count_zeros()
{
    int zeros = 0;

    for(int i = 0; i < m; ++i)
        if(table[i] == 0)
            zeros++;

    return zeros;
}
