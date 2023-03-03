readme
------------for find_ColCluster.py------------------------------------

1. modify the path of input
"""
root_path = r"D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\ROI_set"

"""
root path is for the input data

result will be generated into a sub-folder in root_path named "after_col_mark" under ROI_set

2. modify parameter
line 21-25:
"""
    # group data by class column and get total count and count of values greater than 0.4 for each group
    grouped = df.groupby(["ClusterID"])
    select1 = grouped.agg(Col1=("DOC", lambda x: len(x) >= 10))
    # Col2 is a new column name
    select2 = grouped.agg(Col2=("DOC", lambda x: sum(x >= 0.4) > 10))
"""
change the number 10 to any other filter number x for selecting a co-localized group which has x points' doc > than 0.4

3. how to run this script
conda activate clus    # this step is to activate the environment
python find_ColCluster.py    # this step is to run the script

or run this code in an IDE pycharm

------------------------for statistics.py----------------------------------
identify the root_path in code
root_path = r"D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\ROI_set\after_col_mark"

# run
conda activate clus    # this step is to activate the environment
python statistics.py    # this step is to run the script


