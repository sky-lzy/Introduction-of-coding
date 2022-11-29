#include "mex.h"
#include <random>
#include <ctime>

int inverse_23[23] = {0, 1, 12, 8, 6, 14, 4, 10, 3, 18, 7, 21, 2, 16, 5, 20, 13, 19, 9, 17, 15, 11, 22}; 
int message_x[28] = {0, 0, 0, 1, 1, 3, 3, 4, 5, 5, 6, 6, 7, 7, 9, 9, 11, 11, 12, 12, 13, 13, 17, 17, 18, 18, 19, 19}; 
int message_y[28] = {0, 1, 22, 7, 16, 10, 13, 0, 4, 19, 4, 19, 11, 12, 7, 16, 3, 20, 4, 19, 7, 16, 3, 20, 3, 20, 5, 18}; 

void Point_Add(int x1, int y1, int x2, int y2, int &outx, int &outy, int p, int a, int b); 
void Point_times_k(int x, int y, int k, int &outx, int &outy, int p, int a, int b);
int mod(int n, int p); 

// ECC encode
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs != 9)
        mexErrMsgTxt("Please input 9 parameters: p, a, b, Gx, Gy, Kx, Ky, len, message. \n"); 

    int p = int(*mxGetPr(prhs[0])); 
    int a = int(*mxGetPr(prhs[1])); 
    int b = int(*mxGetPr(prhs[2])); 
    int base_x = int(*mxGetPr(prhs[3])); 
    int base_y = int(*mxGetPr(prhs[4])); 
    int pub_x = int(*mxGetPr(prhs[5])); 
    int pub_y = int(*mxGetPr(prhs[6])); 
    int len = int(*mxGetPr(prhs[7])); 
    double* message = mxGetPr(prhs[8]); 
    if (p != 23)
        mexErrMsgTxt("Please set p = 23. \n"); 
    if (a != 1)
        mexErrMsgTxt("Please set a = 1. \n"); 
    if (b != 1)
        mexErrMsgTxt("Please set b = 1. \n"); 
    int r = mod(rand(), 23); 
    
    plhs[0] = mxCreateDoubleMatrix(len, 2, mxREAL); 
    plhs[1] = mxCreateDoubleMatrix(1, 2, mxREAL); 
    double* out1 = mxGetPr(plhs[0]); 
    double* out2 = mxGetPr(plhs[1]); 
    int rKx, rKy, rGx, rGy; 
    Point_times_k(pub_x, pub_y, r, rKx, rKy, p, a, b); 
    Point_times_k(base_x, base_y, r, rGx, rGy, p, a, b); 
    for (int i = 0; i < len; i++)
    {
        int temp_x = message_x[int(message[i])], temp_y = message_y[int(message[i])]; 
        Point_Add(temp_x, temp_y, rKx, rKy, temp_x, temp_y, p, a, b); 
        out1[i] = double(temp_x);
        out1[i + len] = double(temp_y); 
        // mexPrintf("%d, %d\n", temp_x, temp_y); 
    }
    out2[0] = double(rGx); 
    out2[1] = double(rGy); 
    
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