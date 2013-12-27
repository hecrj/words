#ifndef CardinalityEstimator_HPP
#define CardinalityEstimator_HPP

#include <istream>

using namespace std;

typedef unsigned int estimation_t;

class CardinalityEstimator
{
    public:
        virtual ~CardinalityEstimator(){};
        virtual void read(istream &stream) = 0;
        virtual estimation_t estimation() = 0;
        virtual estimation_t total() = 0;
};

#endif