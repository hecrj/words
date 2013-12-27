#include <iostream>
#include "estimators/HyperLogLog.hpp"

int main()
{
    HyperLogLog hloglog = HyperLogLog(8192);
    hloglog.read(cin);

    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
