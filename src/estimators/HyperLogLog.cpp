#include "HyperLogLog.hpp"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <iostream>

static const int MAX_LENGTH = 31;

HyperLogLog::HyperLogLog(int m)
{
    // Si m no es una potencia de 2, encontramos la primera potencia
    // a la baja
    msbits = floor(log2((double) m));
    lsbits = Djb2Hash::BITS - msbits;
    memory = (1 << msbits);
    table = vector<uint8_t>(memory, 0);
    mask = (1 << lsbits) - 1;
    total_read = 0;

    // alpha se utiliza para aplicar la media armónica
    alpha = 0.7213 / (1.0 + 1.079 / memory);
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

    // Usar C directamente resulta más rápido
    // y fácil para la función de hash
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
        table[i] = max(table[i], (uint8_t)(Djb2Hash::first_one(w) - msbits));

        total_read++;
    }

#ifdef VERBOSE
        cout << "Read finished" << endl;
        cout << "Memory used:     ~" << memory << " bytes" << endl;
#endif
}

/**
* Calcula la estimación a partir de la tabla, aplicando la corrección en
* caso de que tenga un valor demasiado bajo
*/
estimation_t HyperLogLog::estimation()
{
    double sum = 0;

    for(int i = 0; i < memory; ++i)
        sum += 1.0 / (1 << table[i]);

    double raw = alpha * memory * memory * (1.0 / sum);

    // Estimación baja -> Corrección
    if(raw < (2.5 * memory))
    {
        int zeros = count_zeros();

        if(zeros == 0)
            return raw;

        return memory * log(((double) memory) / zeros);
    }

    return raw;
}

/**
* Devuelve el total de elementos procesados
*/
estimation_t HyperLogLog::total()
{
    return total_read;
}

/**
* Devuelve el número de elementos de la tabla vacíos, para ser usados en la
* corrección de la estimación.
*/
int HyperLogLog::count_zeros()
{
    int zeros = 0;

    for(int i = 0; i < memory; ++i)
        if(table[i] == 0)
            zeros++;

    return zeros;
}
