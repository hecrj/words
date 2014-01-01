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
    // Default parameters
    int memory = 1024;
    int seed = time(NULL);

    // Option parsing
    if((argc - 1) % 2 != 0)
        usage();

    for(int i = 1; i < argc; i += 2)
    {
        string option = argv[i];

        if(option == "-M") memory = atoi(argv[i+1]);
        else if(option == "-S") seed = atoi(argv[i+1]);
    }

    // Set seed
    srand(seed);

    // Read input
    HyperLogLog hloglog(memory);
    hloglog.read();

    #ifdef VERBOSE
        cout << "Memory used:     ~" << memory << " bytes" << endl;
    #endif

    // Print estimation
    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
