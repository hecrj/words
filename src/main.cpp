#include <iostream>
#include "estimators/HyperLogLog.hpp"

int main()
{
    HyperLogLog hloglog = HyperLogLog(512);
    hloglog.read(cin);

    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
