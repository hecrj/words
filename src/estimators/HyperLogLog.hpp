#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"
#include <vector>

class HyperLogLog : public CardinalityEstimator
{
    vector<int> table;
    int m, b, mask;
    int n;

    public:
        HyperLogLog(int memory);

        void read(istream &stream);
        int estimation();
        int total();
};

#endif