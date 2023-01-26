#ifndef __OMP_DBSCAN_H
#define __OMP_DBSCAN_H

int* omp_dbscan(double* data_x, double* data_y, int numpoints, int minPts, double eps, int threads);

#endif