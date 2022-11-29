#include "mex.h"
#include <cmath>
#include <random>
#include <ctime>

// Declaration of Functions 
uint64_t Generate_Prime(uint8_t N); 
bool Miller_Rabin(uint64_t Number); 
uint64_t Repeat_Mod(uint64_t a, uint64_t r, uint64_t mod); 
uint64_t gcd(uint64_t m0, uint64_t n0);

// RSA Generate
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs != 1)
        mexErrMsgTxt("Please input 1 parameters. \n"); 
    uint8_t N_size = uint8_t(*mxGetPr(prhs[0])); 
    if (N_size > 31 || N_size < 4)
        mexErrMsgTxt("Please input number large than 3 and less than 32. \n"); 

    srand(unsigned(time(0))); 
    std::mt19937_64 rng(rand()); 
    std::uniform_int_distribution<uint64_t> distribution(0x1ull << (N_size - 1u), 0xFFFFFFFFFFFFFFFF >> (64u - N_size)); 

    uint64_t prime1; 
    uint64_t prime2; 
    do
    {
        prime1 = Generate_Prime(N_size); 
        prime2 = Generate_Prime(N_size); 
    } while (prime1 == prime2);

    uint64_t n = prime1 * prime2; 
    uint64_t phi_n = (prime1 - 1u) * (prime2 - 1u); 

    // Generate Key
    uint64_t key_d, key_e; 
    do
    {
        key_d = distribution(rng);
        key_e = gcd(phi_n, key_d); 
    } while (!key_e); 
    
    plhs[0] = mxCreateDoubleMatrix(1, 3, mxREAL); 
    double* out = mxGetPr(plhs[0]); 
    out[0] = double(key_d); 
    out[1] = double(key_e); 
    out[2] = double(n); 
}


// Generate Prime
uint64_t Generate_Prime(uint8_t N)
{
    std::mt19937_64 rng(rand());  
    std::uniform_int_distribution<uint64_t> distribution(0x1ull << (N - 1u), 0xFFFFFFFFFFFFFFFF >> (64u - N)); 
    uint64_t prime; 
    do
    {
        prime = distribution(rng); 
    } while (!Miller_Rabin(prime));
    return prime; 
}

// Miller Rabin's Prime Test
bool Miller_Rabin(uint64_t Number)
{
    std::mt19937_64 rng(rand());  
    std::uniform_int_distribution<uint64_t> distribution(0x2, Number - 2u); 

    if ((Number & 0x1) == 0)
        return false; 

    uint64_t M = Number - 1;
    uint8_t t = 0; 
    while ((M & 0x1) == 0 && M)
    {
        t++; 
        M >>= 1; 
    }

    for (uint8_t i = 0; i < 10; i++)
    {
        uint64_t a = distribution(rng); 
        uint64_t y = Repeat_Mod(a, M, Number); 

        if (y == 1 || y == Number - 1)
            return true; 
        for (uint8_t j = 0; j < t; j++)
        {
            y = Repeat_Mod(y, 2, Number); 
            if (y == 1)
                return false; 
        }
        if (y != Number - 1)
            return false; 
    }
    return true; 
}

// Fast Pow Calculation
uint64_t Repeat_Mod(uint64_t a, uint64_t r, uint64_t mod)
{
    uint64_t prod = 1; 
    while (r)
    {
        if (r & 0x1)
            prod = (prod * a) % mod; 
        a = (a*a) % mod; 
        r >>= 1; 
    }
    return prod; 
}

// Euclid Algorithm
uint64_t gcd(uint64_t m0, uint64_t n0)
{
    int64_t m = m0, n = n0; 
    int64_t x0 = 1, x1 = 0, y0 = 0, y1 = 1, x = 0, y = 1; 
    int64_t r = m % n; 
    int64_t q = m / n; 
    while (r)
    {
        x = x0 - q * x1;
        y = y0 - q * y1;
        x0 = x1;
        y0 = y1;
        x1 = x;
        y1 = y;
        m = n;
        n = r;
        r = m % n;
        q = m / n;
    }
    if (n != 1)
        y = 0; 
    return (y + m0) % m0; 
}
