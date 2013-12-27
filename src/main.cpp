#include <iostream>
#include <string>
#include <stdlib.h>
#include "estimators/HyperLogLog.hpp"

void usage()
{
    cout << "Usage:    words [-M <memory>]" << endl;
    cout << "Options:" << endl;
    cout << "    -M <memory>    Maximum memory to use (in bytes)." << endl;

    exit(1);
}

int main(int argc, char *argv[])
{
    int memory;

    if(argc < 2)
        memory = 1024;
    else
    {
        if(argc < 3 or ((string) argv[1]) != "-M") usage();
        else memory = atoi(argv[2]);
    }

    HyperLogLog hloglog = HyperLogLog(memory);
    hloglog.read(cin);

    #ifdef VERBOSE
        cout << "Memory used:     ~" << memory << " bytes" << endl;
    #endif

    // Perform estimation
    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
