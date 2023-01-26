#include <matrix.h>
#include <mex.h>
#include <time.h>
#include "omp_dbscan.h"

/* Definitions to keep compatibility with earlier versions of ML */
#ifndef MWSIZE_MAX
typedef int mwSize;
typedef int mwIndex;
typedef int mwSignedIndex;

#if (defined(_LP64) || defined(_WIN64)) && !defined(MX_COMPAT_32)
/* Currently 2^48 based on hardware limitations */
# define MWSIZE_MAX    281474976710655UL
# define MWINDEX_MAX   281474976710655UL
# define MWSINDEX_MAX  281474976710655L
# define MWSINDEX_MIN -281474976710655L
#else
# define MWSIZE_MAX    2147483647UL
# define MWINDEX_MAX   2147483647UL
# define MWSINDEX_MAX  2147483647L
# define MWSINDEX_MIN -2147483647L
#endif
#define MWSIZE_MIN    0UL
#define MWINDEX_MIN   0UL
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  //t_dbscan(double* x_array, double* y_array, double minPtr, double eps, double threads) 

  mexPrintf("Using omp_dbscan...\n");
  
  const mwSize *dims;
  int N;
  double *x, *y, *clusters;
  double minPts, eps, threads;
  
  //associate inputs
  x = mxGetPr(prhs[0]);
  y = mxGetPr(prhs[1]);
  minPts = mxGetScalar(prhs[2]);
  eps = mxGetScalar(prhs[3]);
  threads = mxGetScalar(prhs[4]);
 
  dims = mxGetDimensions(prhs[0]);
  N = (int)dims[0];

  //associate outputs   
  plhs[0] = mxCreateDoubleMatrix(1, N, mxREAL); 
  clusters = mxGetPr(plhs[0]);
  
  //processing
  clock_t begin, end;
  double time_spent;

  begin = clock();
  int* clusters_int = omp_dbscan(x, y, N, minPts, eps, threads);
  
  for(int i=0; i<N ;i++)
      clusters[i] = clusters_int[i];

  end = clock();
  time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
  mexPrintf("Time to run omp_dbscan function: %0.3f \n", time_spent);
}


