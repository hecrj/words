#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"
#include "../hashing/UniversalHash.hpp"
#include <vector>

class HyperLogLog : public CardinalityEstimator
{
    UniversalHash hashing;
    vector<int> table;
    unsigned int m, b, lsb, mask;
    double alpha;
    unsigned int n;

    public:
        HyperLogLog(int memory);

        void read(istream &stream);
        unsigned long int estimation();
        int total();

    private:
        int count_zeros();
};

#endif