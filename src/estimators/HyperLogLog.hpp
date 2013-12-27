#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"
#include "../hashing/UniversalHash.hpp"
#include <vector>

class HyperLogLog : public CardinalityEstimator
{
    UniversalHash hashing;
    vector<unsigned char> table;
    unsigned int m, b, lsb;
    hash_type mask;
    double alpha;
    unsigned int n;

    public:
        HyperLogLog(int memory);

        void read(istream &stream);
        estimation_t estimation();
        estimation_t total();

    private:
        int count_zeros();
};

#endif