#include "mex.h"

int inverse_23[23] = {0, 1, 12, 8, 6, 14, 4, 10, 3, 18, 7, 21, 2, 16, 5, 20, 13, 19, 9, 17, 15, 11, 22}; 
int message_x[28] = {0, 0, 0, 1, 1, 3, 3, 4, 5, 5, 6, 6, 7, 7, 9, 9, 11, 11, 12, 12, 13, 13, 17, 17, 18, 18, 19, 19}; 
int message_y[28] = {0, 1, 22, 7, 16, 10, 13, 0, 4, 19, 4, 19, 11, 12, 7, 16, 3, 20, 4, 19, 7, 16, 3, 20, 3, 20, 5, 18}; 

void Point_Add(int x1, int y1, int x2, int y2, int &outx, int &outy, int p, int a, int b); 
void Point_times_k(int x, int y, int k, int &outx, int &outy, int p, int a, int b);
int mod(int n, int p); 

// ECC decode
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs != 7)
        mexErrMsgTxt("Please input 7 parameters: p, a, b, private key, len, C1, C2"); 

    int p = int(*mxGetPr(prhs[0])); 
    int a = int(*mxGetPr(prhs[1])); 
    int b = int(*mxGetPr(prhs[2])); 
    int pri_key = int(*mxGetPr(prhs[3])); 
    int len = int(*mxGetPr(prhs[4])); 
    double* C1 = mxGetPr(prhs[5]); 
    double* C2 = mxGetPr(prhs[6]); 
    if (p != 23)
        mexErrMsgTxt("Please set p = 23. \n"); 
    if (a != 1)
        mexErrMsgTxt("Please set a = 1. \n"); 
    if (b != 1)
        mexErrMsgTxt("Please set b = 1. \n"); 

    int kCx, kCy; 
    Point_times_k(int(C2[0]), int(C2[1]), pri_key, kCx, kCy, p, a, b); 
    kCy = mod(-kCy, p); 

    plhs[0] = mxCreateDoubleMatrix(1, len, mxREAL); 
    double* out = mxGetPr(plhs[0]); 
    for (int i = 0; i < len; i++)
    {
        int C1_x = int(C1[i]), C1_y = int(C1[i + len]); 
        // mexPrintf("%d, %d\n", C1_x, C1_y); 
        int decode_x, decode_y; 
        Point_Add(C1_x, C1_y, kCx, kCy, decode_x, decode_y, p, a, b); 
        for (int j = 0; j < 28; j++)
            if (message_x[j] == decode_x && message_y[j] == decode_y)
            {
                out[i] = j; 
                break; 
            }
    }
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