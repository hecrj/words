#ifndef CardinalityEstimator_HPP
#define CardinalityEstimator_HPP

#include <string>

using namespace std;

typedef unsigned int estimation_t;

/**
 * Esta clase define una API que todo estimador de cardinalidad
 * debe implementar.
 */
class CardinalityEstimator
{
    public:
        /**
         * Destructora
         */
        virtual ~CardinalityEstimator(){};

        /**
         * Lee los datos del archivo cuya ruta es: filename
         */
        virtual void read(const string &filename) = 0;

        /**
         * Devuelve una estimación de la cardinalidad de los datos leídos.
         */
        virtual estimation_t estimation() = 0;

        /**
         * Devuelve el total de datos leídos.
         */
        virtual estimation_t total() = 0;
};

#endif