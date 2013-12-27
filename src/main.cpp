#include <iostream>
#include <string>
#include <stdlib.h>
#include "estimators/HyperLogLog.hpp"

void usage()
{
    cout << "Usage:    words [-M <memory>] [-S <seed>]" << endl;
    cout << "Options:" << endl;
    cout << "    -M <memory>    Maximum memory to use (in bytes)." << endl;
    cout << "    -S <seed>      Seed to use in the random generator." << endl;

    exit(1);
}

int main(int argc, char *argv[])
{
    int memory = 1024;
    int seed = time(NULL);

    if((argc - 1) % 2 != 0)
        usage();

    for(int i = 1; i < argc; i += 2)
    {
        string option = argv[i];
        int value = atoi(argv[i+1]);

        if(option == "-M") memory = value;
        else if(option == "-S") seed = value;
    }

    srand(seed);
    HyperLogLog hloglog(memory);
    hloglog.read(cin);

    #ifdef VERBOSE
        cout << "Memory used:     ~" << memory << " bytes" << endl;
    #endif

    // Perform estimation
    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
