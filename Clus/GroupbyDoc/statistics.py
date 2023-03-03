import os

import pandas as pd
import numpy as np

root_path = r"D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\ROI_set\after_col_mark"
for root, dir, files in os.walk(root_path):
    for item in files:
        name = item.split('.')[0]
        suffix = item.split('.')[-1]
        if suffix == 'xlsx':
            data = pd.read_excel(root_path + '/' + item)
            number_of_total_events = len(data)
            whether_cluster = data.groupby('ClusterID')

            sum_number_of_events_in_colocalized_cluster = 0
            sum_number_of_events_in_noncolocalized_cluster = 0
            sum_number_of_total_colocalized_events = 0
            sum_number_of_noncluster_colocalized_events = 0
            sum_number_of_colocalized_events_in_colocalized_clusters = 0
            sum_number_of_colocalized_events_in_noncolocalized_cluster = 0

            for key, value in whether_cluster:
                if key == 0:  # ClusterID==0
                    number_of_non_clustered_events = len(whether_cluster.get_group(0))
                    sum_number_of_total_colocalized_events += len(value[value['DOC'] > 0.4])
                    sum_number_of_noncluster_colocalized_events = len(value[value['DOC'] > 0.4])

                elif key != 0:  # ClusterID!=0
                    sum_number_of_events_in_colocalized_cluster += len(value[value['Col'] == 1])
                    sum_number_of_events_in_noncolocalized_cluster += len(value[value['Col'] == 0])
                    sum_number_of_total_colocalized_events += len(value[value['DOC'] > 0.4])
                    sum_number_of_colocalized_events_in_colocalized_clusters \
                        += len(value[(value['Col'] == 1) & (value['DOC'] > 0.4)])
                    sum_number_of_colocalized_events_in_noncolocalized_cluster \
                        += len(value[(value['Col'] == 0) & (value['DOC'] > 0.4)])

                    # temp = value.groupby('Col')
                    # for temp_key, temp_value in temp:
                    #     sum_number_of_events_in_colocalized_cluster += len(temp.get_group(1))
                    #     sum_number_of_events_in_noncolocalized_cluster += len(temp.get_group(0))
                    #     sum_number_of_total_colocalized_events += len(value[value['DOC'] > 0.4])

            with open(root_path + '/' + name + '.txt', 'w') as f:  # 设置文件对象
                L = []
                L.append(["number_of_total_events\t", str(number_of_total_events), '\n'])
                L.append(["number_of_non_clustered_events\t", str(number_of_non_clustered_events), '\n'])
                L.append(["number_of_events_in_colocalized_cluster\t", str(sum_number_of_events_in_colocalized_cluster),
                          '\n'])
                L.append(
                    ["number_of_events_in_noncolocalized_cluster\t",
                     str(sum_number_of_events_in_noncolocalized_cluster), '\n'])
                L.append(["number_of_total_colocalized_events\t", str(sum_number_of_total_colocalized_events), '\n'])
                L.append(["number_of_noncluster_colocalized_event\t", str(sum_number_of_noncluster_colocalized_events),
                          '\n'])
                L.append(["number_of_colocalized_events_in_colocalized_clusters\t",
                          str(sum_number_of_colocalized_events_in_colocalized_clusters), '\n'])
                L.append(["number_of_colocalized_events_in_noncolocalized_cluste\t",
                          str(sum_number_of_colocalized_events_in_noncolocalized_cluster), '\n'])
                for i in L:
                    f.writelines(i)
            print("OK")