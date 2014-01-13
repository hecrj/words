#ifndef DJB2_HPP
#define DJB2_HPP

#include <stdint.h>
#include <string>

using namespace std;

/**
 * Hash de 64 bits
 */
typedef uint64_t hash_t;

/**
 * Clase que implemente la función de hash Djb2
 */
class Djb2Hash
{
    // Número aleatorio de 64 bits
    hash_t a;

    public:
    	// Cantidad de bits de los hashes producidos
        static const int BITS;

        /**
         * Constructora
         */
        Djb2Hash();

        /**
         * Función de hash
         */
        hash_t hash(unsigned char *str);

        /**
         * Devuelve la posición en la que se ha visto el primer 1.
         */
        static int first_one(hash_t hash);
};

#endif
