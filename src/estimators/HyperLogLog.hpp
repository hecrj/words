#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"
#include "../hashing/Djb2Hash.hpp"
#include <vector>

using namespace std;

class HyperLogLog : public CardinalityEstimator
{
    // La instancia de djb2 que se usa como función de hash
    Djb2Hash hashing;

    // Tabla donde se almacenan los k_max
    vector<uint8_t> table;

    // Memoria utilizada, en bytes
    int memory;

    // Cantidad de bits que determinan la posición en la tabla
    int msbits;
    
    // Bits menos significativos del hash (k_candidato)
    int lsbits;

    // Máscara para obtener los últimos lsbits de un hash
    hash_t mask;

    // Utilizada para aplicar la media armónica
    double alpha;

    //Esta variable almacena el número total de elementos procesados
    unsigned int total_read;

    public:
        /**
         * Constructora
         */
        HyperLogLog(int memory);

        void read(const string &filename);
        estimation_t estimation();
        estimation_t total();

    private:
        int count_zeros();
};

#endif
