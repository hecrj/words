#include <iostream>
#include "estimators/HyperLogLog.hpp"

int main()
{
    HyperLogLog hloglog = HyperLogLog();
    hloglog.read(cin);

    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
