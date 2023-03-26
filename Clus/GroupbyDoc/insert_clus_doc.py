import numpy as np
import pandas as pd
from pathlib import Path

raw_path_size = r"D:\GithubRepository\PARA\Clus\20220911\test\Clus-DoC Results\DBSCAN Results\DBSCAN Results.xls"
raw_path_statistics = Path(raw_path_size).parent.parent / r"ROI_set/after_col_mark/statistics.xlsx"
target_path1 = Path(raw_path_size).parent.parent / "Clus-DoC Ch1.xls"
target_path2 = Path(raw_path_size).parent.parent / "Clus-DoC Ch2.xls"

for chan in ['Chan1', 'Chan2']:
    ROI_size = pd.read_excel(raw_path_size, usecols=['Size of ROI (nm)'], sheet_name=chan)
    number = pd.read_excel(raw_path_statistics, usecols=['non_clustered_events'], sheet_name=chan)
    background_density = number['non_clustered_events'] / ROI_size['Size of ROI (nm)']
    if chan == 'Chan1':
        raw_data = pd.read_excel(target_path1, sheet_name="Clus-DoC results")
    elif chan == 'Chan2':
        raw_data = pd.read_excel(target_path2, sheet_name="Clus-DoC results")

    raw_data['Relative density 2 of colocalized cluster'] = raw_data['Mean number of colocalised clusters per ROI'] / raw_data['Average area of colicalised clusters (nm^2)'] / background_density
    raw_data['Relative density 2 of non-colocalized cluster'] = raw_data['Mean number of non-colocalised clusters per ROI'] / raw_data['Average area of non-colicalised clusters (nm^2)'] / background_density

    # save to excel
    if chan == 'Chan1':
        raw_data.to_excel(target_path1, index=False, sheet_name="Clus-DoC results")
    elif chan == 'Chan2':
        raw_data.to_excel(target_path2, index=False, sheet_name="Clus-DoC results")

print("OK")



