#ifndef CardinalityEstimator_HPP
#define CardinalityEstimator_HPP

#include <istream>

using namespace std;

class CardinalityEstimator
{
    public:
        virtual ~CardinalityEstimator(){};
        virtual void read(istream &stream) = 0;
        virtual unsigned long int estimation() = 0;
        virtual int total() = 0;
};

#endif