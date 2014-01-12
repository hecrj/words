#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"
#include "../hashing/Djb2Hash.hpp"
#include <vector>

using namespace std;

class HyperLogLog : public CardinalityEstimator
{
    //La instancia de djb2 que usamos como función de hash
    Djb2Hash hashing;
    //La tabla donde almacenamos los 'm' valores
    vector<uint8_t> table;
    //La memoria que usamos, en bytes
    int memory;
    //
    int msbits;
    //Estos son los bits que se usaran para determinar la posición del elemento en la tabla
    int lsbits;
    //Esta máscara obtiene el valor en la tabla del elemento
    hash_t mask;
    //Esta alpha se fija en la constructora, y se usa en el cálculo de la estimación
    double alpha;
    //Esta variable almacena el número de elementos procesados
    unsigned int total_read;

    public:
        HyperLogLog(int memory);

        void read(const string &filename);
        estimation_t estimation();
        estimation_t total();

    private:
        int count_zeros();
};

#endif
