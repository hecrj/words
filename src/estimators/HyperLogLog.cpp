#include "HyperLogLog.hpp"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <iostream>

static const int MAX_LENGTH = 30;

HyperLogLog::HyperLogLog(int m)
{
    msbits = floor(log2((double) m));
    lsbits = UniversalHash::BITS - msbits;
    memory = (1 << msbits);
    table = vector<uint8_t>(memory, 0);
    mask = (1 << lsbits) - 1;
    alpha = 0.7213 / (1.0 + 1.079 / memory);
    total_read = 0;
}

void HyperLogLog::read(const string &filename)
{
    unsigned char str[MAX_LENGTH];
    hash_t h;
    hash_t w;
    unsigned int i;

    #ifdef VERBOSE
        cout << "Read started" << endl;
    #endif

    FILE* fp = fopen(filename.c_str(), "r");

    if(fp == NULL)
    {
        cout << "Unable to open file: " << filename << endl;
        exit(1);
    }

    while(fscanf(fp, "%s", str) != EOF)
    {
        h = hashing.hash(str);
        i = (h >> lsbits);
        w = h & mask;
        table[i] = max(table[i], (uint8_t)(UniversalHash::leading_zeros(w) - msbits));

        total_read++;
    }

    #ifdef VERBOSE
        cout << "Read finished" << endl;
        cout << "Memory used:     ~" << memory << " bytes" << endl;
    #endif
}

estimation_t HyperLogLog::estimation()
{
    double sum = 0;

    for(int i = 0; i < memory; ++i)
        sum += 1.0 / (1 << table[i]);

    double raw = alpha * memory * memory * (1.0 / sum);

    if(raw < (2.5 * memory))
    {
        int zeros = count_zeros();

        if(zeros == 0)
            return raw;

        return memory * log(((double) memory) / zeros);
    }

    return raw;
}

estimation_t HyperLogLog::total()
{
    return total_read;
}

int HyperLogLog::count_zeros()
{
    int zeros = 0;

    for(int i = 0; i < memory; ++i)
        if(table[i] == 0)
            zeros++;

    return zeros;
}
