build_sys = 0; % 0: MacOS

if(build_sys == 0)
    mex -v -largeArrayDims CXXFLAGS="\$CXXFLAGS -fopenmp" -I/usr/include -cxx -c kdtree2.cpp utils.cpp kdtree2rnearest.cpp
    mex -v -largeArrayDims CXXFLAGS="\$CXXFLAGS -fopenmp" CXXLIBS="\$CXXLIBS -fopenmp" -cxx kdtree2.o utils.o kdtree2rnearest.o -o kdtree2rnearest
end