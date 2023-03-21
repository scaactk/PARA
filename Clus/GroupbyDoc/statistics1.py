import os

import pandas as pd

root_path = r"D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\ROI_set\after_col_mark"
for root, dir, files in os.walk(root_path):
    statistics_channel_1 = pd.DataFrame(columns=["total_events",
                                                 "non_clustered_events/total_events",
                                                 "events_in_colocalized_cluster/total_events",
                                                 "events_in_noncolocalized_cluster/total_events",
                                                 "total_colocalized_events/total_events",
                                                 "noncluster_colocalized_event/total_events",
                                                 "colocalized_events_in_colocalized_clusters/total_events",
                                                 "colocalized_events_in_noncolocalized_cluster/total_events",
                                                 ])
    statistics_channel_2 = pd.DataFrame(columns=["total_events",
                                                 "non_clustered_events/total_events",
                                                 "events_in_colocalized_cluster/total_events",
                                                 "events_in_noncolocalized_cluster/total_events",
                                                 "total_colocalized_events/total_events",
                                                 "noncluster_colocalized_event/total_events",
                                                 "colocalized_events_in_colocalized_clusters/total_events",
                                                 "colocalized_events_in_noncolocalized_cluster/total_events",
                                                 ])
    for item in files:
        name = item.split('.')[0]
        suffix = item.split('.')[-1]
        if suffix == 'xlsx' and 'statistics' not in name:
            if name.split('_')[-1] == 'Ch1':
                channel = 1
            elif name.split('_')[-1] == 'Ch2':
                channel = 2
            else:
                print("error in input file")
                exit(-999)

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

            if channel == 1:
                statistics_channel_1.loc[len(statistics_channel_1.index)] \
                    = [number_of_total_events,
                       number_of_non_clustered_events / number_of_total_events,
                       sum_number_of_events_in_colocalized_cluster / number_of_total_events,
                       sum_number_of_events_in_noncolocalized_cluster / number_of_total_events,
                       sum_number_of_total_colocalized_events / number_of_total_events,
                       sum_number_of_noncluster_colocalized_events / number_of_total_events,
                       sum_number_of_colocalized_events_in_colocalized_clusters / number_of_total_events,
                       sum_number_of_colocalized_events_in_noncolocalized_cluster / number_of_total_events
                       ]
            elif channel == 2:
                statistics_channel_2.loc[len(statistics_channel_2.index)] \
                    = [number_of_total_events,
                       number_of_non_clustered_events / number_of_total_events,
                       sum_number_of_events_in_colocalized_cluster / number_of_total_events,
                       sum_number_of_events_in_noncolocalized_cluster / number_of_total_events,
                       sum_number_of_total_colocalized_events / number_of_total_events,
                       sum_number_of_noncluster_colocalized_events / number_of_total_events,
                       sum_number_of_colocalized_events_in_colocalized_clusters / number_of_total_events,
                       sum_number_of_colocalized_events_in_noncolocalized_cluster / number_of_total_events
                       ]
            # with open(root_path + '/' + name + '.txt', 'w') as f:  # 设置文件对象
            #     L = []
            #     L.append(["number_of_total_events\t", str(number_of_total_events), '\n'])
            #     L.append(["number_of_non_clustered_events\t", str(number_of_non_clustered_events), '\n'])
            #     L.append(["number_of_events_in_colocalized_cluster\t", str(sum_number_of_events_in_colocalized_cluster),
            #               '\n'])
            #     L.append(
            #         ["number_of_events_in_noncolocalized_cluster\t",
            #          str(sum_number_of_events_in_noncolocalized_cluster), '\n'])
            #     L.append(["number_of_total_colocalized_events\t", str(sum_number_of_total_colocalized_events), '\n'])
            #     L.append(["number_of_noncluster_colocalized_event\t", str(sum_number_of_noncluster_colocalized_events),
            #               '\n'])
            #     L.append(["number_of_colocalized_events_in_colocalized_clusters\t",
            #               str(sum_number_of_colocalized_events_in_colocalized_clusters), '\n'])
            #     L.append(["number_of_colocalized_events_in_noncolocalized_cluster\t",
            #               str(sum_number_of_colocalized_events_in_noncolocalized_cluster), '\n'])
            #     for i in L:
            #         f.writelines(i)
    print(statistics_channel_1.head())
    print(statistics_channel_2.head())
    output_name = root_path + '/' + "statistics1.xlsx"
    with pd.ExcelWriter(output_name) as writer:
        statistics_channel_1.to_excel(writer, sheet_name='Chan1', index=False)
        statistics_channel_2.to_excel(writer, sheet_name='Chan2', index=False)
    print("OK")
