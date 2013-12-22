#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"

class HyperLogLog : public CardinalityEstimator
{
    public:
        void read(istream &stream);
        int estimation();
        int total();
};

#endif