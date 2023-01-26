//============================================================================
// Name        : coptics.cpp
// Author      : Toan Nguyen
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================
#ifndef CPP_ONLY
#include "mex.h"
#endif

#include <iostream>
#include "coptics.h"
#include "kdtree2.hpp"

using namespace std;

array2dfloat input_data;
int dims;
int num_points;

int read_file(char* infilename)
{
	string line, line2, buf;
	ifstream file(infilename);
	stringstream ss;

	int i,j;

	if (file.is_open())
	{
		// get the first line and get the dimensions
		getline(file, line);
		line2 = line;
		ss.clear();
		ss << line2;

		dims = 0;
		while(ss >> buf) // get the corordinate of the points
			dims++;

		// get point count
		num_points = 0;
		while (!file.eof())
		{
			if(line.length() == 0)
				continue;
			num_points++;
			getline(file, line);
		}
		cout << "Points " << num_points << " Dimensions " << dims << endl;
		//allocate memory for the points

		// allocate memory for points
		input_data.clear();

		file.clear();
		file.seekg (0, ios::beg);

		getline(file, line);

		i = 0;
		while (!file.eof())
		{
			if(line.length() == 0)
				continue;

			ss.clear();
			ss << line;

			j = 0;
			vector<float> point(dims);
			point.clear();
			while(ss >> buf && j < dims) // get the corordinate of the points
			{
				point.push_back(atof(buf.c_str()));
				j++;
			}
			input_data.push_back(point);
			i++;
			getline(file, line);
		}

		file.close();
	}
	else
	{
		cout << "Error: no such file: " << infilename << endl;
		return -1;
	}
	return 0;
}

float* c_dist;
float* r_dist;
int* mark;
vector<int> order;

typedef pair <int, float> mypair;
vector< mypair > seeds;

bool compare(const mypair&i, const mypair&j)
{
    return i.second < j.second;
}

float calCoreDist(kdtree2_result_vector result_vec)
{
	vector<float> values;
	values.resize(result_vec.size());
	for(int i=0; i<result_vec.size(); i++)
		values[i] = result_vec[i].dis;
	sort(values.begin(), values.end());
	return values[1];
}

void update(int p, kdtree2_result_vector result_vec)
{
	// for each q in neighbors
	for(int i=0; i<result_vec.size(); i++)
	{
		int q = result_vec[i].idx;
		if (q == p)
			continue;
		if (mark[q] == 1)
			continue;
		float new_r_dist = max(c_dist[p], result_vec[i].dis);
#ifdef PRINT_DEBUG
		cout << " q: " << q+1 << " dist: " << result_vec[i].dis << " new_r_dist: " << new_r_dist << " r_dist old: " << r_dist[q];
#endif
		if (r_dist[q] == FLT_MAX)
		{
			r_dist[q] = new_r_dist;
			seeds.push_back(mypair(q,new_r_dist));
		}
		else if (new_r_dist < r_dist[q])
		{
			r_dist[q] = new_r_dist;
			for(int k=0; k < seeds.size(); k++)
			{
				if(seeds[k].first == q)
				{
					seeds[k].second = new_r_dist;
					break;
				}
			}
		}
#ifdef PRINT_DEBUG
		cout << " r_dist new: " << r_dist[q] << endl;
#endif
	}

}

int optics(int minPts)
{
	c_dist = new float[num_points];
	r_dist = new float[num_points];
	mark = new int[num_points]; // 0: unprocessed, 1:processed
	for(int i=0; i<num_points;i++)
	{
		r_dist[i] = FLT_MAX;
		mark[i] = 0;
	}
	order.clear();

	// create KDTREE for finding neighbors
	kdtree2 *tree = new kdtree2(input_data, false);

	// for each unprocessed point in DB
	seeds.clear();
	for(int p=0; p < 1; p++)
	{
		if(mark[p] == 1)
			continue;

		order.push_back(p);
		mark[p] = 1;

		// get minPts neighbors
		vector<float> point(dims);
		point = input_data[p];

		kdtree2_result_vector result_vec;
		tree->n_nearest( point, minPts+1, result_vec );

		c_dist[p] = calCoreDist(result_vec);
		r_dist[p] = 1.1*c_dist[p];

#ifdef PRINT_DEBUG
		cout << "c_dist[" << p+1 << "]: " << c_dist[p] << endl;
#endif
		update(p, result_vec);

		while(seeds.size() > 0)
		{
			//sort seeds
			std::sort(seeds.begin(), seeds.end(), compare);
#ifdef PRINT_DEBUG
			for(int k=0; k<seeds.size(); k++)
				cout << seeds[k].first +1 << " " << seeds[k].second << endl;
#endif
			int q = seeds.front().first;
#ifdef PRINT_DEBUG
			cout << "size: " << seeds.size() << " q: " << q+1 << " dist: " << seeds.front().second << endl;
#endif
			seeds.erase (seeds.begin());

			vector<float> point_q(dims);
			point_q = input_data[q];
			kdtree2_result_vector result_vec_q;
			tree->n_nearest( point_q, minPts+1, result_vec_q );
			c_dist[q] = calCoreDist(result_vec);
			mark[q] = 1;
			order.push_back(q);
			update(q, result_vec_q);
		}
#ifdef PRINT_DEBUG
		cout << endl;
#endif
	}

	delete tree;

	return 0;
}

int clear()
{
	input_data.clear();
	if(c_dist)
		delete c_dist;
	if(r_dist)
		delete r_dist;
	if(mark)
		delete mark;
	order.clear();
	seeds.clear();
	return 0;
}

#ifdef CPP_ONLY
int main(int argc, char** argv) {

	cout << "Optics in C" << endl; // prints Hi
	if (read_file("./Debug/optics_small.txt") == -1)
		return 1;

#ifdef PRINT_DEBUG2
	cout << "input data: " << endl;
	for(int i=0; i<input_data.size(); i++)
	{
		vector<float> point(dims);
		point = input_data[i];
		for(int j=0; j<dims;j++)
			cout<<point[j] << " ";
		cout << endl;
	}
#endif

	optics(5);

#ifdef PRINT_DEBUG
	cout << "final order: " << endl;
	for(int i=0; i<order.size(); i++)
		cout << order[i] + 1 << " ";
	cout<<endl;
#endif

#ifdef PRINT_DEBUG2
	cout << "r_dist: " << endl;
	for(int i=0; i<num_points; i++)
		cout << r_dist[i] << " ";
	cout<<endl;

	cout << "c_dist: " << endl;
	for(int i=0; i<num_points; i++)
		cout << c_dist[i] << " ";
	cout<<endl;
#endif

	clear();

	return 0;
}
#else

void mexFunction(int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[]){

	// [RD order] = coptics(x1_array, y1_array, minPts)
	const mwSize *d;
	double *x, *y;
	int minPts = 0;

	if(nlhs != 3 || nrhs != 3)
	{
		mexPrintf("Incorrect # of input/output parameters\n");
		mexPrintf("Usage: [RD order] = coptics(x1_array, y1_array, minPts)");
		return;
	}

	double *outRD, *outCD, *outOrder;

	// retrieve input points
	x = mxGetPr(prhs[0]);
	y = mxGetPr(prhs[1]);
	d = mxGetDimensions(prhs[1]);
	num_points = (int)d[0];

	// retrieve minPts
	minPts = mxGetScalar(prhs[2]);

	mexPrintf("Number of input points: %d\n", num_points);
	mexPrintf("minPts: %d\n", minPts);

	//associate outputs
	plhs[0] = mxCreateDoubleMatrix(1, num_points, mxREAL);
	outRD = mxGetPr(plhs[0]);

	plhs[1] = mxCreateDoubleMatrix(1, num_points, mxREAL);
	outCD = mxGetPr(plhs[1]);

	plhs[2] = mxCreateDoubleMatrix(1, num_points, mxREAL);
	outOrder = mxGetPr(plhs[2]);

	for(int i=0; i<num_points; i++)
	{
		vector<float> point(2);
		point[0] = (float)x[i];
		point[1] = (float)y[i];
		input_data.push_back(point);
		//mexPrintf("(%0.2f, %0.2f)\n", point[0], point[1]);
	}

	dims = 2;

	mexPrintf("Running optics...\n");
	optics(minPts);
	
	for(int i=0; i<num_points; i++)
	{
		outRD[i] = r_dist[i];
		outCD[i] = c_dist[i];
		outOrder[i] = order[i]+1;
	}
	mexPrintf("Optics - done!!!\n");

	clear();
}

#endif
