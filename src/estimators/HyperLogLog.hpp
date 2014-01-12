#ifndef HyperLogLog_HPP
#define HyperLogLog_HPP

#include "CardinalityEstimator.hpp"
#include "../hashing/Djb2Hash.hpp"
#include <vector>

using namespace std;

class HyperLogLog : public CardinalityEstimator
{
    Djb2Hash hashing;
    vector<uint8_t> table;
    int memory;
    int msbits;
    int lsbits;
    hash_t mask;
    double alpha;
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