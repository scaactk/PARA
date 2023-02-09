1. modify the path of input
"""
root_path = "D:\GithubRepository\PARA\Clus/20220911/test\Clus-DoC Results"
file_list = [
    "ROI_1_in_cluster_Ch1.xls",
    "ROI_1_in_cluster_Ch2.xls",
    "ROI_2_in_cluster_Ch1.xls",
    "ROI_2_in_cluster_Ch2.xls",
]
"""
root path is for the input data
file_list is for the data name list
result will be generated into a sub-folder in root_path named "after_col_mark"

2. how to run this script
conda activate xxx
python find_ColCluster.py

or run this code in an IDE pycharm