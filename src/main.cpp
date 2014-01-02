#include <iostream>
#include <string>
#include <stdlib.h>
#include "estimators/HyperLogLog.hpp"

void usage()
{
    cout << "Usage:    words [-M <memory>] [-S <seed>] FILENAME" << endl;
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

    // Parameter/option parsing
    if(argc < 2)
        usage();

    string filename = "";

    int i = 1;
    while(filename.size() == 0)
    {
        if(i >= argc)
            usage();
        
        string param = argv[i++];
        
        if(param[0] != '-')
        {
            filename = param;
            break;
        }

        if(i >= argc)
            usage();

        if(param == "-M") memory = atoi(argv[i++]);
        else if(param == "-S") seed = atoi(argv[i++]);
    }

    // Set seed
    srand(seed);

    // Read input
    HyperLogLog hloglog(memory);
    hloglog.read(filename);

    // Print estimation
    cout << hloglog.estimation() << ' ' << hloglog.total() << endl;

    return 0;
}
