#include <string>
#include <random>

using namespace std;

static unsigned long int P = 2305843009213693951; // Mersenne Prime: 2^61 - 1

// Distribution and engine
static uniform_int_distribution<unsigned long int> dist(1, P);
static default_random_engine generator;
static unsigned long int a = dist(generator);

/**
 * Main universal hash funcion.
 * @param  s String to hash
 * @return   Hash value
 */
unsigned int universal_hash(string s);

