import os
import pandas as pd

root_path = r'D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\ROI_set\after_col_mark'
for root, dir, files in os.walk(root_path):
    mean_channel_1 = pd.DataFrame(columns=["ROI",
                                           "mean_DoC_for_nonclustered_events",
                                           "mean_DoC_for_clustered_and_col_events",
                                           "mean_DoC_for_clustered_and_noncol_events",
                                           ])
    mean_channel_2 = pd.DataFrame(columns=["ROI",
                                           "mean_DoC_for_nonclustered_events",
                                           "mean_DoC_for_clustered_and_col_events",
                                           "mean_DoC_for_clustered_and_noncol_events",
                                           ])
    for item in files:
        name = item.split('.')[0]
        suffix = item.split('.')[-1]
        if suffix == 'xlsx' and 'statistics' not in name and 'mean' not in name:
            ROI_number = name.split('_')[1]
            if name.split('_')[-1] == 'Ch1':
                channel = 1
            elif name.split('_')[-1] == 'Ch2':
                channel = 2
            else:
                print("error in input file")
                exit(-999)
            data = pd.read_excel(root_path + '/' + item)[['DOC', 'ClusterID', 'Col']]

            sum_of_nonclustered_events = 0
            sum_of_clustered_and_col_events = 0
            sum_of_clustered_and_noncol_events = 0

            number_of_non_clustered_events = 0
            number_of_clustered_and_col_events = 0
            number_of_clustered_and_noncol_events = 0

            for row in data.itertuples():
                if getattr(row, 'ClusterID') == 0:
                    sum_of_nonclustered_events += getattr(row, 'DOC')
                    number_of_non_clustered_events += 1
                elif getattr(row, 'ClusterID') != 0:
                    if getattr(row, 'Col') == 1:
                        sum_of_clustered_and_col_events += getattr(row, 'DOC')
                        number_of_clustered_and_col_events += 1
                    elif getattr(row, 'Col') == 0:
                        sum_of_clustered_and_noncol_events += getattr(row, 'DOC')
                        number_of_clustered_and_noncol_events += 1
                    else:
                        print("error")
                        exit(-999)

            if channel == 1:
                mean_channel_1 = mean_channel_1.append({"ROI": ROI_number,
                                                        "mean_DoC_for_nonclustered_events": sum_of_nonclustered_events / number_of_non_clustered_events,
                                                        "mean_DoC_for_clustered_and_col_events": sum_of_clustered_and_col_events / number_of_clustered_and_col_events,
                                                        "mean_DoC_for_clustered_and_noncol_events": sum_of_clustered_and_noncol_events / number_of_clustered_and_noncol_events
                                                        }, ignore_index=True)
            elif channel == 2:
                mean_channel_2 = mean_channel_2.append({"ROI": ROI_number,
                                                        "mean_DoC_for_nonclustered_events": sum_of_nonclustered_events / number_of_non_clustered_events,
                                                        "mean_DoC_for_clustered_and_col_events": sum_of_clustered_and_col_events / number_of_clustered_and_col_events,
                                                        "mean_DoC_for_clustered_and_noncol_events": sum_of_clustered_and_noncol_events / number_of_clustered_and_noncol_events
                                                        }, ignore_index=True)

    print(mean_channel_1.head())
    print(mean_channel_2.head())
    output_name = root_path + '/' + 'mean.xlsx'
    with pd.ExcelWriter(output_name) as writer:
        mean_channel_1.to_excel(writer, sheet_name='Chan1', index=False)
        mean_channel_2.to_excel(writer, sheet_name='Chan2', index=False)
    print("OK")

