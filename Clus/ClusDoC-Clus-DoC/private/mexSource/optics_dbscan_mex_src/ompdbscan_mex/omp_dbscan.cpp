/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*   Files: omp_main.cpp clusters.cpp  clusters.h utils.h utils.cpp          */
/*   			dbscan.cpp dbscan.h kdtree2.cpp kdtree2.hpp          */
/*		    						             */
/*   Description: an openmp implementation of dbscan clustering algorithm    */
/*				using the disjoint set data structure        */
/*                                                                           */
/*   Author:  Md. Mostofa Ali Patwary                                        */
/*            EECS Department, Northwestern University                       */
/*            email: mpatwary@eecs.northwestern.edu                          */
/*                                                                           */
/*   Copyright, 2012, Northwestern University                                */
/*   See COPYRIGHT notice in top-level directory.                            */
/*                                                                           */
/*   Please cite the following publication if you use this package 	     */
/* 									     */
/*   Md. Mostofa Ali Patwary, Diana Palsetia, Ankit Agrawal, Wei-keng Liao,  */
/*   Fredrik Manne, and Alok Choudhary, "A New Scalable Parallel DBSCAN      */
/*   Algorithm Using the Disjoint Set Data Structure", Proceedings of the    */
/*   International Conference on High Performance Computing, Networking,     */
/*   Storage and Analysis (Supercomputing, SC'12), pp.62:1-62:11, 2012.	     */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include "dbscan.h"
#include "utils.h"
#include "kdtree2.hpp"
#include <omp.h>

int* omp_dbscan(double* data_x, double* data_y, int numpoints, int minPts, double eps, int threads)
{
	double	seconds;

	int* clusters;

	int classical = 0;

	omp_set_num_threads(threads);

	NWUClustering::ClusteringAlgo dbs;
	dbs.set_dbscan_params(eps, minPts);

	cout << "Input parameters " << " minPts " << minPts << " eps " << eps << endl;

	cout << "Reading points: " << endl;
	dbs.read_data(data_x, data_y, numpoints);

	// build kdtree for the points
	double start = omp_get_wtime();
	dbs.build_kdtree();
	cout << "Build kdtree took " << omp_get_wtime() - start << " seconds." << endl;
	start = omp_get_wtime();
	
	//run_dbscan_algo(dbs);
	run_dbscan_algo_uf(dbs);
	cout << "DBSCAN (total) took " << omp_get_wtime() - start << " seconds." << endl;

	clusters = new int[numpoints];
	if(clusters == NULL)
		cout << "Cannot allocate memory for output" << endl;

	dbs.writeClusters(clusters);
	
	return clusters;
}

