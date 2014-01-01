#ifndef CardinalityEstimator_HPP
#define CardinalityEstimator_HPP

typedef unsigned int estimation_t;

class CardinalityEstimator
{
    public:
        virtual ~CardinalityEstimator(){};
        virtual void read() = 0;
        virtual estimation_t estimation() = 0;
        virtual estimation_t total() = 0;
};

#endif