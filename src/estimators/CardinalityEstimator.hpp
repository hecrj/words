#ifndef CardinalityEstimator_HPP
#define CardinalityEstimator_HPP

#include <string>

using namespace std;

typedef unsigned int estimation_t;

class CardinalityEstimator
{
    public:
        virtual ~CardinalityEstimator(){};
        virtual void read(const string &filename) = 0;
        virtual estimation_t estimation() = 0;
        virtual estimation_t total() = 0;
};

#endif