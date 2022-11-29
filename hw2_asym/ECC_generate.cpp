#include "mex.h"
#include <random>
#include <ctime>
// #include <iostream>

int inverse_23[23] = {0, 1, 12, 8, 6, 14, 4, 10, 3, 18, 7, 21, 2, 16, 5, 20, 13, 19, 9, 17, 15, 11, 22}; 

int mod(int n, int p); 
void Point_Add(int x1, int y1, int x2, int y2, int &outx, int &outy, int p, int a, int b);
void Point_times_k(int x, int y, int k, int &outx, int &outy, int p, int a, int b);

// Generate ECC 
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs != 0)
        mexErrMsgTxt("Please do not input parameters. \n"); 
    srand(unsigned(time(0))); 

    // y^2 = x^3 + x + 1; p = 23, a = 1, b = 1
    const int p = 23; 
    const int a = 1; 
    const int b = 1; 
    // Base Point G = (3, 10)
    const int base_x = 3; 
    const int base_y = 10; 

    // Generate the private key k
    const int n = 28; 
    int pri_key = rand() % 26 + 2; 

    // Calculate public key K = k*G 
    int pub_x, pub_y; 
    int temp_x = base_x, temp_y = base_y; 
    Point_times_k(base_x, base_y, pri_key, pub_x, pub_y, p, a, b); 

    plhs[0] = mxCreateDoubleMatrix(1, 9, mxREAL); 
    double* out = mxGetPr(plhs[0]); 
    out[0] = p; 
    out[1] = n; 
    out[2] = a; 
    out[3] = b; 
    out[4] = pri_key; 
    out[5] = base_x; 
    out[6] = base_y; 
    out[7] = pub_x; 
    out[8] = pub_y; 
}

void Point_Add(int x1, int y1, int x2, int y2, int &outx, int &outy, int p, int a, int b)
{
    if (x1 == 0 && y1 == 0)
    {
        outx = x2; 
        outy = y2; 
        return; 
    }
    if (x2 == 0 && y2 == 0)
    {
        outx = x1; 
        outy = y1; 
        return; 
    }

    int k; 
    if (x1 == x2)
    {
        if (y1 == y2)
            k = mod(mod(3*x1*x1 + a, p) * inverse_23[mod(2*y1, p)], p);
        else 
        {
            outx = 0; 
            outy = 0; 
            return; 
        }
    }
    else 
        k = mod(mod(y2 - y1, p) * inverse_23[mod(x2 - x1, p)], p); 

    // std::cout << "k = " << k << std::endl; 
    outx = mod(k*k - x1 - x2, p); 
    outy = mod(k*(x1 - outx) - y1, p); 
}

void Point_times_k(int x, int y, int k, int &outx, int &outy, int p, int a, int b)
{
    int flag[5]; 
    for (int i = 0; i < 5; i++)
    {
        flag[i] = k % 2; 
        k >>= 1; 
    }

    outx = 0; 
    outy = 0; 
    int temp_x = x, temp_y = y; 
    for (int i = 0; i < 5; i++)
    {
        if (flag[i])
            Point_Add(outx, outy, temp_x, temp_y, outx, outy, p, a, b); 
        Point_Add(temp_x, temp_y, temp_x, temp_y, temp_x, temp_y, p, a, b); 
    }
}

int mod(int n, int p)
{
    return (n % p + p) % p; 
}