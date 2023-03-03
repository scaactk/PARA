import numpy as np
import pandas as pd
import os


def mark_data(file_path):
    # read excel file into a pandas dataframe
    df = pd.read_excel(file_path, header=None)

    """
    # generate column name by ASCII code
    for i in range(65,91):
    print('\"',chr(i),'\"',sep='', end=', ')
    """
    df.columns = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                  "DOC", "Lr", "D1_D2", "Lr_rAboveThresh", "RelativeDensity", "ClusterID"]

    df['Col'] = ""
    print(df.head())

    # group data by class column and get total count and count of values greater than 0.4 for each group
    grouped = df.groupby(["ClusterID"])
    select1 = grouped.agg(Col1=("DOC", lambda x: len(x) >= 10))
    # Col2 is a new column name
    select2 = grouped.agg(Col2=("DOC", lambda x: sum(x >= 0.4) > 10))
    select = select1['Col1'] & select2['Col2']
    # print(select)

    # for index, row in df.iterrows():
    #     # print(row['ClusterID'], select[row['ClusterID']])
    #     if select[row['ClusterID']]:
    #         print(select[row['ClusterID']])
    #         df.loc[index, 'Col'] = 1
    #     else:
    #         print("yyy")
    #         df.loc[index, 'Col'] = 0

    # Another write methods, filter by numpy, numpy's logic is much better than dataframe
    df['Col'] = np.where(select[df['ClusterID']], 1, 0)
    print(df.head())

    # fun = lambda x : pd.DataFrame([X.DOC ], index=["Col"])
    # for name, group in g:
    #     print(name)
    #     if len(group) <= 10:
    #         pass

    # # select groups where count is greater than 10 and count of values greater than 0.4 is greater than 4
    # selected_groups = group[(group[(df.columns[-1], 'count')] > 10) & (group[(df.columns[-1], '<lambda>')] > 4)]
    #
    # # get a list of selected class names
    # selected_class_names = selected_groups.index.tolist()
    #
    # # create a new column 'mark' and mark rows based on selected class names
    # df['mark'] = df.apply(lambda row: 1 if row[df.columns[-2]] in selected_class_names else 0, axis=1)

    return df


# modify your path for data and file here
root_path = r"D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\ROI_set"

depth = 1
for root, dirs, files in os.walk(root_path):
    if depth == 2:
        break
    for item in files:
        file_path = os.path.join(root_path, item)
        print(file_path)
        df = mark_data(file_path)

        target_path = os.path.join(root_path, "after_col_mark")
        if not os.path.exists(target_path):
            os.makedirs(os.path.join(root_path, "after_col_mark"))
        file_name = os.path.join(target_path, item.split('.')[0] + '.xlsx')
        print(file_name)
        df.to_excel(file_name, index=False)

    depth += 1