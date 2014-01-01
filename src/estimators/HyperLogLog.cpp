#include "HyperLogLog.hpp"
#include <cmath>
#include <cstdio>

#ifdef VERBOSE
#include <iostream>
#endif

static const int MAX_LENGTH = 30;

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

void HyperLogLog::read()
{
    unsigned char str[MAX_LENGTH];
    hash_t h;
    hash_t w;
    unsigned int i;

#ifdef VERBOSE
    cout << "Read started" << endl;
#endif

    while(scanf("%s", str) != EOF)
    {
        h = hashing.hash(str);
        i = (h >> lsb);
        w = h & mask;
        table[i] = max((int)table[i], UniversalHash::leading_zeros(w) - (int)b);

        n++;
    }

#ifdef VERBOSE
    cout << "Read finished" << endl;
#endif
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
