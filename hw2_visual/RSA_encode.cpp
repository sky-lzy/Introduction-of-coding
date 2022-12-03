#include "mex.h"
#include <cstdint>

uint64_t Repeat_Mod(uint64_t a, uint64_t r, uint64_t mod); 

// RSA Encode
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
	if (nrhs != 4)
		mexErrMsgTxt("Please input 4 parameters. \n"); 
	uint64_t key_d = uint64_t(*mxGetPr(prhs[0])); 
	uint64_t n = uint64_t(*mxGetPr(prhs[1])); 
	uint8_t len = uint8_t(*mxGetPr(prhs[2])); 
	double* message = mxGetPr(prhs[3]); 

	plhs[0] = mxCreateDoubleMatrix(1, len, mxREAL); 
	double* out = mxGetPr(plhs[0]); 
    for (uint8_t i = 0; i < len; i++)
        out[i] = double(Repeat_Mod(message[i], key_d, n));
}

// Fast Pow Calculation
uint64_t Repeat_Mod(uint64_t a, uint64_t r, uint64_t mod)
{
    uint64_t prod = 1;
    while (r)
    {
        if (r & 0x1)
            prod = (prod * a) % mod;
        a = (a * a) % mod;
        r >>= 1;
    }
    return prod;
}